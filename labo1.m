bdclose all;
Simulink.sdi.clear;
clear all;
close all;
clc;
addpath("simulink"); %Ajoute le répertoire contenant les fichiers


% définition des constantes
epsilon = 0.3; % marge d'erreur pour la détection du début de l'impulsion
slope_window = 10; % nombre de points pour calculer la coefficients
Fs = 1000;
pulse_duration = 0.01; % durée de l'impulsion en secondes
time_after_pulse = 50; % durée après l'impulsion en secondes
time_before_pulse = 1; % durée avant l'impulsion en secondes
impul_amplitude = 200; % amplitude de l'impulsion d'entrée;

%openinout; %Permet l'accès aux ports du calculateur analogique.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%METTEZ VOTRE CODE ICI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%closeinout %Permet de retirer l'accès aux ports du calculateur analogique.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Traitement des données pour Simulink
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%COM = [time', Data(:,1)]; %(Commande) Réarrange la structure des données pour leur utilisation dans Simulink.
%OUT = [time', Data(:,2)]; %(Sortie) Réarrange la structure des données pour leur utilisation dans Simulink.

% Crée une impulsion de 0.25 secondes à 1.5V + 3V = 4,5V à un sample rate de 10000Hz
impul = impul_amplitude*ones(1, pulse_duration*Fs);
% ajoute des zeros avant et après l'impulsion 1 second avant et 10 secondes après 
% (durée totale de 11.25 secondes)
t = 0:1/Fs:time_before_pulse+pulse_duration + time_after_pulse;
t = t(1:end-1);

input = [1.5*ones(1, time_before_pulse*Fs), impul, 1.5*ones(1, time_after_pulse*Fs)];
COM = [t; input]';
OUT = [t; zeros(1, length(t))]';
REF = 1.5*ones(2,2);

mdl = "simulink/simulink_s1";
% % open the simulink model
% open_system(mdl);
% run simulink model with the time vector
out = sim(mdl, t); %create object
out;
out.yout.plot
simulated_output_time = out.yout.get("simu_output").Values.Time;
simulated_output_data = out.yout.get("simu_output").Values.Data;

pulse_area = sum(COM(:,2)- REF(1,1))/Fs;

% %plot
% figure;
% plot(simulated_output_time, simulated_output_data);

% trouvons le temps de départ

find_start = find(COM(:,2) > 1.5+epsilon, 1);
simulated_output_data = (simulated_output_data-mean(simulated_output_data(find_start-110: find_start-10)))/pulse_area; %réponse indicielle normalisée
% calcul la valeur initiale de la sortie
initial_value = mean(simulated_output_data(find_start-110: find_start-10));
final_value = mean(simulated_output_data(end-100:end));

% calcule la pente de la sortie pour tous les temps après le début de l'impulsion
% en faisant la régression linéaire sur les slope_window points suivants
coefficients = zeros(2, length(simulated_output_data)); 
for i = find_start:length(simulated_output_data)-slope_window
    % coefficients(i, 1) = a, coefficients(i, 2) = b dans la formule y = ax + b
    coefficients(:, i) = [polyfit(simulated_output_time(i:i+slope_window),simulated_output_data(i:i+slope_window),1)]'; 
end


figure;
plot(simulated_output_time, coefficients(1,:), simulated_output_time, simulated_output_data);
hold on
max(coefficients(1,:))
% indice de la valeur maximale de la pente
index = find(coefficients(1,:) == max(coefficients(1,:)))


% find the time where the tangent_line crosses the initial value
zero_crossing_time = roots([coefficients(:, index)]' - [0, initial_value])
% find the time where the tangent_line crosses the final value
caracteristic_crossing_time = roots([coefficients(:, index)]' - [0,  final_value])
% FIXME : it should be when the output_data crosses  (1-1/e) * final value
% and not the tangent line crossing the final value, but the should be equal

tangent_line = polyval([coefficients(:, index)]', simulated_output_time(find_start:caracteristic_crossing_time*Fs));
plot(simulated_output_time(find_start:caracteristic_crossing_time*Fs), tangent_line, 'r');


scatter(zero_crossing_time, initial_value, 'r');
scatter(caracteristic_crossing_time, final_value, 'r');
% add a vertical line at the caracteristic_crossing_time
plot(ones(1, length(simulated_output_time))*caracteristic_crossing_time, simulated_output_data, 'g');
plot(simulated_output_time, ones(1, length(simulated_output_time))*initial_value, 'g');
plot(simulated_output_time, ones(1, length(simulated_output_time))*final_value, 'g');
plot(simulated_output_time, ones(1, length(simulated_output_time))*(initial_value + (final_value - initial_value)*(1-1/exp(1))), 'g');

% calcul de la constante de temps
T = (caracteristic_crossing_time - zero_crossing_time)
% calcul du délai
L = zero_crossing_time - find_start/Fs
% calcul du gain statique
A0 = final_value % gain statique = valeur finale seulement car réponse indicielle normalisée
