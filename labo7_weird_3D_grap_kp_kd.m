clc; clear all; close all;



kp_values = 5:0.1:7;
kd_values = 0.5:0.02:0.7;
% print number of evaluations :
number_of_evaluations = length(kp_values) * length(kd_values);
fprintf('Number of evaluations: %d\n', number_of_evaluations);

Gm_values = zeros(length(kp_values), length(kd_values));
Pm_values = zeros(length(kp_values), length(kd_values));
risetime_values = zeros(length(kp_values), length(kd_values));
share_time_saturated_values = zeros(length(kp_values), length(kd_values));
for i = 1:length(kp_values)
    for j = 1:length(kd_values)
        % Calculate performance metrics
        [Gm, Pm, risetime, share_time_saturated] = performance(kp_values(i), kd_values(j));
        
        % Store the results
        Gm_values(i,j) = Gm;
        Pm_values(i,j) = Pm;
        risetime_values(i,j) = risetime;
        share_time_saturated_values(i,j) = share_time_saturated;
    end
end
% Plot the results
figure;
subplot(2,2,1);
surf( kd_values,kp_values, Gm_values);
xlabel('kp');
ylabel('kd');
zlabel('Gain Margin (dB)');
title('Gain Margin');
grid on;
subplot(2,2,2);
surf( kd_values,kp_values,  Pm_values);
xlabel('kp');
ylabel('kd');
zlabel('Phase Margin (degrees)');
title('Phase Margin');
grid on;
subplot(2,2,3);
surf( kd_values,kp_values,  risetime_values);
xlabel('kp');
ylabel('kd');
zlabel('Rise Time (s)');
title('Rise Time');
grid on;
subplot(2,2,4);
surf( kd_values,kp_values, share_time_saturated_values);
xlabel('kp');
ylabel('kd');
zlabel('Saturation Time (%)');
title('Saturation Time');
grid on;

% plot only the rise time and color the surface if it is winthin the specs
winthin_specs =  share_time_saturated_values < 5 & Pm_values > 30 & Gm_values > 6;
figure;
% Create grid coordinates for scatter3
[KP, KD] = ndgrid(kp_values, kd_values);
scatter3(KP(:), KD(:), risetime_values(:), 50, winthin_specs(:), 'filled');

xlabel('kp');
ylabel('kd');
zlabel('Rise Time (s)');
title('Rise Time with Specs');



function [Gm, Pm, risetime, share_time_saturated] = performance(kp, kd)
    % maximum linear amplitude
    max_amplitude = 4.5-0.32;

    % fonction de transfert du système réglé
    A0 = 5.35;      %Gain statique
    Tsys = 0.45;   %Constante de temps

    H = tf([A0], [Tsys 1 0]);

    % fonction de transfert du régulateur
    T_filtrage = kd/(kp*10); %Constante de temps du filtre

    D = tf(kp) + tf([kd 0], [T_filtrage 1]);

    % fonction de transfert du filtre anti-repli
    zeta = 0.7;   %Facteur d'amortissement
    Tfilter = 0.01;     %Position de la paire de pôle
    omegan = 1/Tfilter; %pulsation naturelle

    F  = tf([omegan^2], [1 2*zeta*omegan omegan^2]);

    % délay de la boucle du à la digitalisation
    Fs = 100; % fréquence d'échantillonnage
    Ts = 1/Fs; % période d'échantillonnage

    % add the delay to the system
    H.InputDelay = Ts;

    % fonction de transfert du système bouclé
    forward_path = series(D,H);
    Transfert_function = feedback(forward_path,F);

    [Gm, Pm, temp, temp1] = margin(Transfert_function);

    % show the overshoot and settling time
    [y, t] = step(Transfert_function);
    risetime = t(find(y >= 0.95, 1)) - t(find(y >= 0.05, 1));


    % Transfer function from reference to control signal
    Control_TF = feedback(D, series(H, F));

    % Simulate step response
    [u, t] = step(Control_TF);
    % evaluate the time during which the control signal is above the max amplitude
    above_max_amplitude = u > max_amplitude;
    below_max_amplitude = u < -max_amplitude;

    % Find intervals where signal exceeds upper limit
    if any(above_max_amplitude)
        transitions_to_above = find(diff([0; above_max_amplitude]) == 1);
        transitions_from_above = find(diff([above_max_amplitude; 0]) == -1);
        
        time_above = sum(t(transitions_from_above) - t(transitions_to_above));
    else
        time_above = 0;
    end

    % Find intervals where signal exceeds lower limit
    if any(below_max_amplitude)
        transitions_to_below = find(diff([0; below_max_amplitude]) == 1);
        transitions_from_below = find(diff([below_max_amplitude; 0]) == -1);
        
        time_below = sum(t(transitions_from_below) - t(transitions_to_below));
    else
        time_below = 0;
    end


    % Total time outside limits
    total_time_outside = time_above + time_below;
    share_time_saturated = 100*total_time_outside/t(end);
end

