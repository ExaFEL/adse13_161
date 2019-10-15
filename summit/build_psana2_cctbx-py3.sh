#!/bin/bash

set -e

if [[ -z $LS49_BIG_DATA ]]; then
    echo "Please set LS49_BIG_DATA and run again"
    exit 1
fi
if [[ ! -f $LS49_BIG_DATA/1m2a.pdb ]]; then
    echo "LS49_BIG_DATA does not contain a file named '1m2a.pdb', are you sure it's pointing to the right place?"
    exit 1
fi

# Setup environment.
cat > env.sh <<EOF
module load gcc/6.4.0
module load cuda/9.1.85

export PYVER=3.6

# variables needed for conda
export CONDA_PREFIX=$PWD/conda
export PATH=\$CONDA_PREFIX/bin:\$PATH
export LD_LIBRARY_PATH=\$CONDA_PREFIX/lib:\$LD_LIBRARY_PATH

# variables needed for psana
export LCLS2_DIR="$PWD/lcls2"
export PATH="\$LCLS2_DIR/install/bin:\$PATH"
export PYTHONPATH="\$LCLS2_DIR/install/lib/python\$PYVER/site-packages:\$PYTHONPATH"

# variables needed for CCTBX
export CCTBX_PREFIX=$PWD/cctbx

# variables needed for run only
export LS49_BIG_DATA=$LS49_BIG_DATA

# variables needed to run CCTBX
if [[ -d \$CONDA_PREFIX ]]; then
  source \$CONDA_PREFIX/etc/profile.d/conda.sh
  conda activate myenv
fi
if [[ -e \$CCTBX_PREFIX/build/setpaths.sh ]]; then
  source \$CCTBX_PREFIX/build/setpaths.sh
fi
EOF

root_dir=$PWD

# Clean up any previous installs.
rm -rf conda
rm -rf lcls2
rm -rf cctbx

source env.sh

# Install Conda environment.
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-ppc64le.sh
bash Miniconda3-latest-Linux-ppc64le.sh -b -p $CONDA_PREFIX
rm Miniconda3-latest-Linux-ppc64le.sh
source $CONDA_PREFIX/etc/profile.d/conda.sh

PACKAGE_LIST=(
    # LCLS2 requirements:
    python=$PYVER
    cmake
    numpy
    cython
    matplotlib
    pytest
    mongodb
    pymongo
    curl
    rapidjson
    ipython
    requests
    mypy
)

conda create -y -n myenv "${PACKAGE_LIST[@]}" -c defaults -c anaconda
conda activate myenv
conda install -y amityping -c lcls-ii
conda install -y bitstruct -c conda-forge

# Build mpi4py
CC=$OMPI_CC MPICC=mpicc pip install -v --no-binary mpi4py mpi4py

# Install Psana
git clone https://github.com/slac-lcls/lcls2.git $LCLS2_DIR
pushd $LCLS2_DIR
git checkout e540a92831bf6e991770fd4869ed411183423ae4
./build_all.sh -d
popd

echo
echo "Done. Please run 'source env.sh' to use this build."
