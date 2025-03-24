clear;
close all;
clc;

duration = 10;
Fs = 10000;

[time, data] = acqui(Fs, duration);

input_channel  = 1;  
output_channel = 2; 
reference_channel = 3;  % consigne

input_signal  = data(:, input_channel);
output_signal = data(:, output_channel);
reference_signal = data(:, reference_channel);  

input  = -input_signal';  
output = output_signal';
reference = reference_signal';
time          = time';

save("data/labo3/mesure_regu_1_K_4_2.mat", "time", "input", "output", "reference", "Fs"); 

plot(time, input, time, output, time, reference)
