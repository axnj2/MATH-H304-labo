bdclose all;
Simulink.sdi.clear;
clear all;
close all;
clc;

Fs = 10000

figure
hold on

data_to_load1 = "data/labo1/mesure_pulse_5.mat";
plot_data("data/labo1/mesure_pulse_3.mat", "r", Fs)
% plot_data("data/labo1/mesure_pulse_8.mat", "b", Fs)
% plot_data("data/labo1/mesure_pulse_10.mat", "g", Fs)
% plot_data("data/labo1/mesure_pulse_3.mat", "y", Fs)
legend()
xlabel("time (s)")
ylabel("normalized input/output (non unit)")

function plot_data(data_to_load, color, Fs)
    epsilon = 0.1;

    % load the data
    load(data_to_load,  "time", "input", "output");

    REF = mean(input(1:300));
    pulse_area = sum(input- REF(1,1))/Fs;
    output_ref = mean(output(1: 200));
    
    find_start = find(input > REF+epsilon, 1);
   
    centered_input = input-REF;
    
    %plot(centered_output, color)
    %plot(centered_input, color)
    
    input = input(find_start-10000:end);
    output = output(find_start-10000:end);
    time = time(find_start-10000:end);
    time = time - time(1);
    
    normalised_output = (output - output_ref)/pulse_area; %réponse indicielle normalisée
    normalized_input =  (input-REF)/pulse_area;
    
    max_input = max(input);
    
    
    plot(time, normalised_output, color, 'DisplayName', num2str(max_input))
    plot(time, normalized_input, color)
end 



