bdclose all;
Simulink.sdi.clear;
clear all;
close all;
clc;

Fs = 10000;

figure
hold on

load("mesure_integrateur.mat")
output = output - mean(output(1:200));
input = input - mean(input(1:200));
input = input(15000:40000);
output = output(15000:40000);
time = time(15000:40000);

plot(time, -output, time, input)
xlim([1.5, 4])
xlabel("time (s)")
ylabel("input/output (V)")