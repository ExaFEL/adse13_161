To install (recommended location is $HOME):
./build_from_scratch.sh

Test run interactively on one node:
bsub -W 1:00 -nnodes 1 -P chm137 -alloc_flags "gpumps" -Is /bin/bash   
source env.sh  
./clean.sh #clean up result folder  
jsrun -n1 -a1 -c1 -g1 ./run_demo.sh # use one core and one gpu to generate one pattern  

Debugging note:
DEBUGXX (step5_pad.py) timing columns:   
Init  
Process 100 wavelengths  
save_bragg (False)  
Add water bg  
Add air bg  
Add noise  
Save to img.gz  

DEBUGXZ (sim/util_fmodel.py) timing columns:  
Create pdb object  
Calculate xray structure  
Looping over scatterers  
Extract phil parameters  

see debugging results here:  
https://docs.google.com/spreadsheets/d/1q0Z5FObQSrgwTDOcgw5qPVEPgSNgyGbPArEL4FouU6M/edit?usp=sharing



