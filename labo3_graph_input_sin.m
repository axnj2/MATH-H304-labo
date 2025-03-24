bdclose all;
Simulink.sdi.clear;
clear all;
close all;
clc;

Fs = 10000;

figure
hold on

load("data\labo3\mesure_sinus_0_2_Hz.mat")


plot(time, output, time, input)
legend("Sortie y(t)", "Entrée u(t)")
grid on
xlim([0, 12])
xlabel("temps (s)")
ylabel("input/output (V)")