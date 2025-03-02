clear all;
close all;
clc;

duration = 20; % durée de l'expérience
fs = 1000; % fréquence d'échantillonage
[time, data] = acqui2(fs,duration);
% time est un vecteur colonne de fs*duration lignes
% data est une matrice de 8 colonnes et fs*duration lignes

input_channel = 1;
output_channel = 2;
input = data(1:end,input_channel);
output = data(1:end,output_channel);