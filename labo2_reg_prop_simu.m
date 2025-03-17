bdclose all;
Simulink.sdi.clear;
clear all;
close all;
clc;

%%% performance criteria parameters
% number of points for the average
N = 100;

%%%%%%% parameters for the simulink model %%%%%%%
% system model parameters
A0 = 5.35;
T = 0.4484;

% points de fonctionnement
y0 = 0;
u0 = 0.32;

% gain du régulateur proportionnel
K = 0.224;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input signals :

from_real_data = true;
% type of synthetic input : (only valid  for from_real_data = false)
step_reference = true;
perturbation_step = false;

step_reference_amplitude = 1;
perturbation_step_amplitude = 1;


if from_real_data
    data_to_load = "data/labo2/mesure_regu_K_9_223_ref_1V_no_overshoot.mat";
    % load the data
    load(data_to_load, "input",  "time", "output", "reference", "Fs");
    perturbation_step_amplitude = 0;
    time = time';
    real_command = input';
    input = reference';
    output = output';
    
    
    y0 = mean(output(1:N));
    u0 = mean(real_command(1:N));
    
else
    Fs = 10000;
    duration = 30;
    % time vector
    time = 0:1/Fs:duration;
    time = time';
    
    input = y0*ones(size(time));
    output = 0*ones(size(time)); % not used
    
    % input signal
    if step_reference
        start_time = 1;
        input(start_time*Fs:end) = input(start_time*Fs:end) + step_reference_amplitude;
    end
    
    % perturbation signal
    if perturbation_step
        % do nothing, keep the value of perturbation_step_amplitude
    else
        perturbation_step_amplitude = 0;
    end
end

% format the data correctly for simulink
input = [time, input];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mdl_name = "simulink/simulink_s2_22b_22c_2020a_03.slx";
% open model
open_system(mdl_name);

% run simulink model with the time vector
out = sim(mdl_name, time);
%out.yout.plot
%%% get the results from the simulation
commande_signal = out.yout.getElement(2).Values.Data;
output_signal = out.yout.getElement(3).Values.Data;
reference_signal = out.yout.getElement(1).Values.Data;

%%% Calculate the performance criteria
% static error
static_error = abs(mean(output_signal(end-N:end)) - mean(reference_signal(end-N:end)))
overshoot = (max(output_signal) - reference_signal(end))/reference_signal(end)
% damping ratio
% overshoot = exp(-pi*zeta/sqrt(1-zeta^2))
% -log(overshoot) = pi*zeta/sqrt(1-zeta^2)
% log(overshoot)^2 = pi^2*zeta^2/(1-zeta^2)
% log(overshoot)^2*(1-zeta^2) = pi^2*zeta^2
% log(overshoot)^2 - zeta^2*log(overshoot)^2 = pi^2*zeta^2
% log(overshoot)^2 = pi^2*zeta^2 + zeta^2*log(overshoot)^2
% log(overshoot)^2 = zeta^2*(pi^2 + log(overshoot)^2)
% zeta = sqrt(-log(overshoot)^2/(pi^2 + log(overshoot)^2))
zeta = sqrt((log(overshoot))^2/(pi^2 + log(overshoot)^2))

%%%%%%%%%%%%% Ploting the results %%%%%%%%%%%%%%%%
%%% plot the results including:
% le signal de commande u(t)
% le signal de sortie y(t)
% le signal de consigne r(t)

figure;
hold on;
plot(time, commande_signal, 'DisplayName', 'commande u(t)', 'LineWidth', 3 );
plot(time, output_signal, 'DisplayName', 'sortie y(t)', 'LineWidth', 2 );
plot(time, reference_signal, 'DisplayName', 'consigne r(t)');
if from_real_data
    plot(time, output, 'DisplayName', 'sortie réelle y(t)', 'LineWidth', 0.01);
    plot(time, real_command, 'DisplayName', 'commande réelle u(t)', 'LineWidth', 0.01);
end
hold off;
legend;
xlabel('temps (s)');
ylabel('amplitude (V)');





