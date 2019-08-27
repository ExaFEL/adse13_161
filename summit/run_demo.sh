# Run demo
rm -rf demo
mkdir demo
pushd demo
export OMP_NUM_THREADS=2
export OMP_PLACES=threads
export OMP_PROC_BIND=spread
export N_SIM=20 # total number of images to simulate
export ADD_SPOTS_ALGORITHM=cuda # cuda or JH or NKS
export DEVICES_PER_NODE=6
libtbx.python $CCTBX_PREFIX/modules/LS49/adse13_161/step5_batch.py
popd

