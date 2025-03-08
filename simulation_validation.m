bdclose all;
Simulink.sdi.clear;
clear all;
close all;
clc;


data_to_load = "data/labo1/mesure_pulse_5.mat";

% load the data
load(data_to_load,  "time", "input", "output");

t = time(1000:end);
COM = [t; input(1000:end)]';
OUT = [t; output(1000:end)]';
REF = mean(input(1:1000))*ones(2,2);



mdl = "simulink_s1_old_version";
% % open the simulink model
open_system(mdl);
% run simulink model with the time vector
out = sim(mdl, t); %create object
out.yout.plot
simu_output = out.yout{2}.Values.Data;
real_output = out.yout{4}.Values.Data;

plot( t, real_output);
hold on
plot(t, simu_output, "LineWidth", 2.5);
xlim([2,10])
