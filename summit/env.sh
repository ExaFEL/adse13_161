module load gcc/6.4.0
module load cuda/9.1.85

# variables needed for conda
export CONDA_PREFIX=/gpfs/alpine/proj-shared/chm137/adse13_161/summit/conda

export PATH=$CONDA_PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

# variables needed for CCTBX
export CCTBX_PREFIX=/gpfs/alpine/proj-shared/chm137/adse13_161/summit/cctbx

# variables needed for run only
export LS49_BIG_DATA=/gpfs/alpine/proj-shared/chm137/data/LS49

# variables needed to run CCTBX
if [[ -d $CONDA_PREFIX ]]; then
  source $CONDA_PREFIX/etc/profile.d/conda.sh
  conda activate myenv
fi
if [[ -e $CCTBX_PREFIX/build/setpaths.sh ]]; then
  source $CCTBX_PREFIX/build/setpaths.sh
fi
