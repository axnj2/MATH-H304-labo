clear;
close all;
clc;

duration = 10;
Fs = 10000;
normalized = 1;  % 1 = on normalise, 0 = on normalise pas


[time, data] = acqui(Fs, duration);

input_channel  = 1;  
output_channel = 2; 
reference_channel = 3;  % consigne

input_signal  = data(:, input_channel);
output_signal = data(:, output_channel);
reference_signal = data(:, reference_channel);  

input_signal  = -input_signal;  
input_signal  = input_signal';
output_signal = output_signal';
reference_signal = reference_signal';
time          = time'; % askip c nécessaire


save("data/experiment_measurement.mat", "time", "input_signal", "output_signal", "reference_signal", "Fs");

% on jarte l'offset sur base des 200 premiers points comme d'hab
N_init = 200;
baseline_input  = mean(input_signal(1:N_init));
baseline_output = mean(output_signal(1:N_init));
baseline_ref = mean(reference_signal(1:N_init));


% normalise as usual
pulse_area = sum(input_signal - mean(input_signal(1:100))) / Fs;


if pulse_area > 5  % je met un max de 5 mais je me rappelle plus des values du vrai
    warning('Amplitude de l’échelon trop élevée, risque de non-linéarité !');
end

if normalized == 1  % Si on veut normaliser
    input_norm  = (input_signal - mean(input_signal(1:100))) / pulse_area;
    output_norm = (output_signal - mean(output_signal(1:100))) / pulse_area;
    reference_norm = (reference_signal - mean(reference_signal(1:100))) / pulse_area;
else
    input_norm  = input_signal;
    output_norm = output_signal;
    reference_norm = reference_signal;
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
