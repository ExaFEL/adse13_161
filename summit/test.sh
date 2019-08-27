#!/bin/bash

set -e

source env.sh

# # Run all regression tests. Note: may take a while.
# rm -rf test
# mkdir test
# pushd test
#   libtbx.python $CCTBX_PREFIX/modules/LS49/tests/public-test-all.py
# popd

# # Run module regression tests.
rm -rf test
mkdir test
pushd test
  libtbx.run_tests_parallel module=LS49 nproc=12
popd

