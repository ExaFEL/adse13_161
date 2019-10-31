#!/bin/bash

set -e

# Setup environment.
cat > env.sh <<EOF
module load gcc/7.4.0
module load cuda/10.1.168

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
    pytest=4.6
    mongodb
    pymongo
    curl
    rapidjson
    ipython
    requests
    mypy
    h5py
    # extra CCTBX requirements:
    biopython
    future
    ipython
    jinja2
    mock
    msgpack-python
    pillow
    psutil
    pytest-mock
    pytest-xdist
    pyyaml
    reportlab
    scikit-learn
    six
    tabulate
    tqdm=4.23.4
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
CC=/sw/summit/gcc/7.4.0/bin/gcc CXX=/sw/summit/gcc/7.4.0/bin/g++ ./build_all.sh -d
popd

# Install CCTBX wtih DIALS (locale needs to be set)
export LC_ALL=en_US.utf-8
pip install dials-data
pip install mrcfile
pip install orderedset
pip install procrunner
mkdir -p $CCTBX_PREFIX
cd $CCTBX_PREFIX
wget "https://raw.githubusercontent.com/cctbx/cctbx_project/master/libtbx/auto_build/bootstrap.py"
# this $CONDA_PREFIX is for the myenv environment, not $PWD/conda
python bootstrap.py hot update build --builder=dials --use-conda $CONDA_PREFIX --nproc=16
cd -

echo
echo "Done. Please run 'source env.sh' to use this build."
