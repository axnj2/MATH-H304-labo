bdclose all;
Simulink.sdi.clear;
clear all;
close all;
clc;


%%%%%%% parameters for the simulink model %%%%%%%
% system model parameters
A0 = 5.35;
T = 0.4484;

% points de fonctionnement
y0 = 0;
u0 = 0.32;

% gain du régulateur proportionnel
K = 3.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input signals :

from_real_data = false;
% type of synthetic input : (only valid  for from_real_data = false)
step_reference = true;
perturbation_step = false;

step_reference_amplitude = 1;

if from_real_data
    data_to_load = "data/labo2/TODO";
    % load the data
    load(data_to_load,  "time", "input", "output", "Fs");
    perturbation_step_amplitude = 0;
else
    Fs = 10000;
    duration = 10;
    % time vector
    time = 0:1/Fs:duration;
    time = time';
   
    input = y0*ones(size(time));
    output = 0*ones(size(time)); % not used

    % input signal
    if step_reference
        start_time = 1;
        input(start_time*Fs:end) = input(start_time*Fs:end) + step_reference_amplitude;
    end

    % perturbation signal
    if perturbation_step
        perturbation_step_amplitude = 0.1;
    else
        perturbation_step_amplitude = 0;
    end
end    

% format the data correctly for simulink
input = [time, input];
output = [time, output];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mdl_name = "simulink/simulink_s2_22b_22c_2020a_03.slx";
% open model
%open_system(mdl_name);

% run simulink model with the time vector
out = sim(mdl_name, time); 
out.yout.plot



