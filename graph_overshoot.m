bdclose all;
Simulink.sdi.clear;
clear all;
close all;
clc;

figure
hold on

load("data\labo2\mesure_regu_K_0_440_ref_1V_overshoot.mat")
input = input(1:80000);
output = output(1:80000);
reference = reference(1:80000);
time = time(1:80000);

plot(time, output, time, input, time, reference)
legend("Sortie y(t)", "Consigne r(t)","Commande u(t)")
xlim([0, 5])
ylim([0.2, 2.3])
xlabel("time (s)")
ylabel("commande/sortie/consigne (V)")