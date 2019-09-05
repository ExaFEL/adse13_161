#!/bin/bash
# Run demo

WORK_DIR=$PWD/demo
pushd $WORK_DIR
export OMP_NUM_THREADS=2
export OMP_PLACES=threads
export OMP_PROC_BIND=spread
export N_SIM=1 # total number of images to simulate
export ADD_SPOTS_ALGORITHM=cuda # cuda or JH or NKS
export DEVICES_PER_NODE=1
#strace -ttt -f -o $$.log libtbx.python $CCTBX_PREFIX/modules/LS49/adse13_161/step5_batch.py
libtbx.python $CCTBX_PREFIX/modules/LS49/adse13_161/step5_batch.py
popd


