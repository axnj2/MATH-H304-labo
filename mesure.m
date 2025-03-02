clear all;
close all;
clc;

duration = 20; % durée de l'expérience
fs = 1000; % fréquence d'échantillonage

openinout; %Permet l'accès aux ports du calculateur analogique.
[time, data] = acqui2(fs,duration);
closeinout %Permet de retirer l'accès aux ports du calculateur analogique.
% time est un vecteur colonne de fs*duration lignes
% data est une matrice de 8 colonnes et fs*duration lignes

input_channel = 1;
output_channel = 2;
input = data(:, input_channel);
output = data(:, output_channel);

save("mesure_XXXX.mat", "time", "input", "output");