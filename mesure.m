clear all;
close all;
clc;

% à chaud valeur de seuil : -0.32

duration = 10; % durée de l'expérience
fs = 10000; % fréquence d'échantillonage

[time, data] = acqui(fs,duration);
% time est un vecteur colonne de fs*duration lignes
% data est une matrice de 8 colonnes et fs*duration lignes

input_channel = 1;
output_channel = 2;
input = data(:, input_channel);
output = data(:, output_channel);

input = -input';
output = output';
time = time';

size(input)


save("data/labo1/mesure_pulse_7.mat", "time", "input", "output");

plot(time, input, time, output);
