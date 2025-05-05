clc; clear all; close all;

% maximum linear amplitude
max_amplitude = 4.5-0.32;

% fonction de transfert du système réglé
A0 = 5.35;      %Gain statique
Tsys = 0.45;   %Constante de temps

H = tf([A0], [Tsys 1 0]);

% fonction de transfert du régulateur
kp = 0.69; 
kd = 0.58;
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
open_loop = series(forward_path, F);


figure
step(Transfert_function)
grid on

% show the gain and phase margin
figure
margin(open_loop,{10^-2,10^2} );
[Gm, Pm, Wcg, Wcp] = margin(open_loop);
disp('Gain margin (dB):');
disp(20*log10(Gm));
disp('Phase margin (degrees):');
disp(Pm);
disp('Gain crossover frequency (rad/s):');
disp(Wcg);
disp('Phase crossover frequency (rad/s):');
disp(Wcp);

% show the overshoot and settling time
[y, t] = step(Transfert_function);
overshoot = (max(y) - 1) * 100;
risetime = t(find(y >= 0.95, 1)) - t(find(y >= 0.05, 1));
disp('Overshoot (%):');
disp(overshoot);
disp('Rise time (s):');
disp(risetime);

figure
nyquist(open_loop)
grid on


% plot the control signal during the step response
figure

% Transfer function from reference to control signal
Control_TF = feedback(D, series(H, F));

% Simulate step response
[u, t] = step(Control_TF);

% Plot the control signal
plot(t, u);
title('Control Signal During Step Response');
xlabel('Time (s)');
ylabel('Control Signal Amplitude');

% merci sonnet pour ce qui suit (gratuit avec GitHub copilot)
hold on;
plot([t(1) t(end)], [max_amplitude max_amplitude], 'r--');
plot([t(1) t(end)], [-max_amplitude -max_amplitude], 'r--');
grid on;

% evaluate the time during which the control signal is above the max amplitude
above_max_amplitude = u > max_amplitude;
below_max_amplitude = u < -max_amplitude;

% Find intervals where signal exceeds upper limit
if any(above_max_amplitude)
    transitions_to_above = find(diff([0; above_max_amplitude]) == 1);
    transitions_from_above = find(diff([above_max_amplitude; 0]) == -1);
    
    time_above = sum(t(transitions_from_above) - t(transitions_to_above));
    
    % Highlight regions above max amplitude
    for i = 1:length(transitions_to_above)
        plot(t(transitions_to_above(i):transitions_from_above(i)), ...
             u(transitions_to_above(i):transitions_from_above(i)), 'r', 'LineWidth', 2);
    end
    
    fprintf('Signal exceeds upper limit in %d intervals for a total of %.4f seconds\n', ...
        length(transitions_to_above), time_above);
else
    time_above = 0;
end

% Find intervals where signal exceeds lower limit
if any(below_max_amplitude)
    transitions_to_below = find(diff([0; below_max_amplitude]) == 1);
    transitions_from_below = find(diff([below_max_amplitude; 0]) == -1);
    
    time_below = sum(t(transitions_from_below) - t(transitions_to_below));
    
    % Highlight regions below min amplitude
    for i = 1:length(transitions_to_below)
        plot(t(transitions_to_below(i):transitions_from_below(i)), ...
             u(transitions_to_below(i):transitions_from_below(i)), 'r', 'LineWidth', 2);
    end
    
    fprintf('Signal exceeds lower limit in %d intervals for a total of %.4f seconds\n', ...
        length(transitions_to_below), time_below);
else
    time_below = 0;
end
hold off;

% Total time outside limits
total_time_outside = time_above + time_below;
fprintf('Total time outside amplitude limits: %.4f seconds (%.2f%% of simulation time)\n', ...
    total_time_outside, 100*total_time_outside/t(end));


% convert to digital model
% discretize the regulator
D_num = c2d(D, Ts, 'tustin');
D_num

z = tf('z', Ts);
D_num_2 = kp + 2*kd*(z-1)/(2*T_filtrage*(z-1) + Ts*(z+1))

iztrans(D_num_2, z)

