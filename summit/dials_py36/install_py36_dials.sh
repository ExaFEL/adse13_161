#!/usr/bin/bash

# setup compiler
module load gcc/7.4.0
module load cuda/10.1.168

# variables needed for conda
export CONDA_PREFIX=$PWD/conda

# Install Conda environment.
rm -fr $CONDA_PREFIX
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-ppc64le.sh
bash Miniconda3-latest-Linux-ppc64le.sh -b -p $CONDA_PREFIX
rm Miniconda3-latest-Linux-ppc64le.sh
source $CONDA_PREFIX/etc/profile.d/conda.sh

# clean up
mkdir -p dials
cd dials
rm -fr *

# set language to ensure utf-8 encoding
export LC_ALL=en_US.utf-8

# get bootstrap.py
wget "https://raw.githubusercontent.com/cctbx/cctbx_project/master/libtbx/auto_build/bootstrap.py"

# download sources and LS49
python bootstrap.py hot update --builder=dials
cd modules
git clone https://github.com/nksauter/LS49.git
cd ..

# install dependencies
python bootstrap.py base --use-conda ../dials_py36_env.txt
conda activate ./conda_base
pip install dials-data
pip install mrcfile
pip install orderedset
pip install procrunner
conda deactivate

# build with LS49 (https://github.com/nksauter/LS49)
python bootstrap.py build --builder=dials --use-conda --nproc=16 --config-flags="--enable_cuda"
./build/bin/libtbx.configure iota prime LS49 

cd ..

# run tests with ls49_big_data directory set as $LS49_BIG_DATA
