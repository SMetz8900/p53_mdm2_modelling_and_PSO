# p53_mdm2_modelling_and_PSO

This repository contains the code for a project for the university course "Think Mathematically, Act Algorithmically: Optimization Techniques (Complementary Studies)" in the summer semester 2024. 

The project uses Particle Swarm Optimization to attempt to recover theoretical parameter values of a system of DDEs modeling p53 and Mdm2 interaction. 

## Structure of the repo 
### Main files 
- PSO_3_params (Runs a PSO for 3 parameters) 
- PSO_4_params (Runs a PSO for 4 parameters) 
- PSO_5_params (Runs a PSO for 5 parameters) 
- PSO_6_params (Runs a PSO for 6 parameters)

### Additional files (**Do not need to be run separately**)
- params.m (Contains theoretical parameter values)
- plot_theoretical_pso_params.m (Creates comparison plots between solved DDEs using theoretical parameter values and the PSO recovered values)
- PSO_p53_mdm2_simulation (Simulink model of the DDEs.)
- theoreticalModelData.mat (Contains DDEs solution for the theoretical parameter values)
- PSOParamsModelData.mat (Contains DDEs solution for the PSO parameter values)
