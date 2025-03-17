clear;
close all;
clc;

normalized = 1;  % 1 = on normalise, 0 = on normalise pas
data_to_load = "data/labo2/TODO";
load(data_to_load,  "time", "input", "output","reference", "Fs");

% on jarte l'offset sur base des 200 premiers points comme d'hab
N_init = 200;
baseline_input  = mean(input(1:N_init));
baseline_output = mean(output(1:N_init));
baseline_ref = mean(reference(1:N_init)); % Ant :ref = input non ? c'est quoi ref ?


% normalise as usual, Ant : du coup tu normalise tout le temps le signal ?
pulse_area = sum(input - mean(input(1:100))) / Fs;

% Ant :c'est vraiment nécesaire ? 
if pulse_area > 5  % je met un max de 5 mais je me rappelle plus des values du vrai
    warning('Amplitude de l’échelon trop élevée, risque de non-linéarité !');
end

if normalized == 1  % Si on veut normaliser
    input_norm  = (input - mean(input(1:100))) / pulse_area;
    output_norm = (output - mean(output(1:100))) / pulse_area;
    reference_norm = (reference - mean(reference(1:100))) / pulse_area;
else
    input_norm  = input;
    output_norm = output;
    reference_norm = reference;
end


% merci copilot !
figure('Name','Acquisition en temps réel','NumberTitle','off');
hold on; grid on;
plot(time, reference_norm, 'g', 'LineWidth',1.5, 'DisplayName','Consigne (normalisée)');
plot(time, input_norm,  'b', 'LineWidth',1.5, 'DisplayName','Entrée (normalisée)');
plot(time, output_norm, 'r', 'LineWidth',1.5, 'DisplayName','Sortie (normalisée)');
xlabel('Temps (s)');
ylabel('Amplitude (V)');
title('Acquisition des signaux de consigne, entrée et sortie');
legend('Location','best');



fprintf('Offset entrée  : %.3f V\n', baseline_input);
fprintf('Offset sortie  : %.3f V\n', baseline_output);
fprintf('Offset consigne : %.3f V\n', baseline_ref);
fprintf('Amplitude échelon détectée : %.3f V\n', pulse_area);
fprintf('Durée totale   : %.2f s, Nb échantillons : %d\n', time(end), length(time));
