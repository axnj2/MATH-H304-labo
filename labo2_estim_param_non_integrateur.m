% launch after labo2_reg_prop_simu.m

% we have output_signal, reference_signal, time, Fs, y0, u0
input_signal =  reference_signal;

% Define epsilon for threshold detection
epsilon = 0.01 * (max(input_signal) - min(input_signal));

% Calculate the amplitude of the step
step_reference_amplitude = max(input_signal) - u0;
pulse_area = step_reference_amplitude;
find_start = find(input_signal > u0 + epsilon, 1);
output_ref = mean(output_signal(find_start-110: find_start-10));

simulated_output_data = (output_signal-output_ref)/pulse_area; %réponse indicielle normalisée
normalized_input =  (input_signal-u0)/pulse_area;
% calcul la valeur initiale de la sortie
initial_value = mean(simulated_output_data(find_start-110: find_start-10));
final_value = mean(simulated_output_data(end-100:end));
% First define simulated_output_time
simulated_output_time = time;


slope_window = 10;
coefficients = zeros(2, length(simulated_output_data)); 
for i = find_start:length(simulated_output_data)-slope_window
    % coefficients(i, 1) = a, coefficients(i, 2) = b dans la formule y = ax + b
    coefficients(:, i) = [polyfit(simulated_output_time(i:i+slope_window),simulated_output_data(i:i+slope_window),1)]'; 
end


simulated_output_time = time;

figure;
%plot(simulated_output_time, coefficients(1,:));
plot(simulated_output_time, simulated_output_data);
hold on
plot(simulated_output_time, normalized_input)
max(coefficients(1,:))
% indice de la valeur maximale de la pente
index = find(coefficients(1,:) == max(coefficients(1,:)))

tangent_line = polyval([coefficients(:, index)]', simulated_output_time(find_start:(caracteristic_crossing_time+2)*Fs));
plot(simulated_output_time(find_start:(caracteristic_crossing_time+2)*Fs), tangent_line, 'r');


scatter(zero_crossing_time, initial_value, 'r');
scatter(caracteristic_crossing_time, final_value, 'r');

% add a vertical line at the caracteristic_crossing_time
%plot(ones(1, length(simulated_output_time))*caracteristic_crossing_time, simulated_output_data, 'g');
plot(simulated_output_time, ones(1, length(simulated_output_time))*initial_value, 'g');
plot(simulated_output_time, ones(1, length(simulated_output_time))*final_value, 'g');
plot(simulated_output_time, ones(1, length(simulated_output_time))*(initial_value + (final_value - initial_value)*(1-1/exp(1))), 'g');

% find the time where the tangent_line crosses the initial value
zero_crossing_time = roots([coefficients(:, index)]' - [0, initial_value])
% find the time where the tangent_line crosses the final value
caracteristic_crossing_time = roots([coefficients(:, index)]' - [0,  final_value])
% FIXME : it should be when the output_data crosses  (1-1/e) * final value
% and not the tangent line crossing the final value, but the should be equal


% calcul de la constante de temps
T = (caracteristic_crossing_time - zero_crossing_time)
% calcul du délai
L = zero_crossing_time - find_start/Fs
% calcul du gain statique
A0 = final_value % gain statique = valeur finale seulement car réponse indicielle normalisée
