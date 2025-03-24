clc; clear all; close all;


function [frequency, gain, phase] = get_bode_point(input, output, time, f, A_in, A_out, phi_in, phi_out)
    % fit the input
    mean_input = mean(input);
    mean_output = mean(output);
    options = optimset('MaxFunEvals', 1000, 'MaxIter', 1000);%, "Display", "iter");
    fun_cost_input = @(x) cost_function(x, input - mean_input, time);
    [x_input] = fminsearch(fun_cost_input, [f, A_in, phi_in], options)

    % figure
    % plot(time, input - mean_input, time, gen_sin(x_input, time))
    % fit the output
    fun_cost_output = @(x) cost_function(x, output - mean_output, time);
    [x_output] = fminsearch(fun_cost_output, [f, A_out, phi_out], options)

    % hold on
    % plot(time, output - mean_output, time, gen_sin(x_output, time))
    xlabel("time [s]");
    ylabel("input/output [V]");
    legend("input", "input fit", "output", "output fit");

    % calculate the gain and phase
    gain = x_output(2) / x_input(2);
    phase = (x_output(3) - x_input(3)) * 180 / pi;
    frequency = mean([x_output(1), x_input(1)]);
end

function output = gen_sin(x, time)
    % x = [f, A, phi]
    output = x(2) * sin(2*pi*x(1)*time + x(3));
end

function cost = cost_function(x, input_to_fit, time)
    % x = [f, A, phi]
    % difference between the sin and the input

    % generate the sin
    genereted_sin = gen_sin(x, time);

    epsilon = input_to_fit - genereted_sin;
    cost = sum(epsilon.^2);
end

load("data/labo3/mesure_sinus_0_2_Hz.mat", "time", "input", "output", "fs");

time = time(1:200000);
input = input(1:200000);
output = output(1:200000);

% get the bode point
[frequency1, gain1, phase1] = get_bode_point(input(1:200000), output(1:200000), time(1:200000), 0.2, 1, 2, -2, -3)

load("data/labo3/mesure_sinus_1_Hz.mat", "time", "input", "output", "fs");

[frequency2, gain2, phase2] = get_bode_point(input(1:200000), output(1:200000), time(1:200000), 1, 6, 2, -2, -0.1)

load("data/labo3/mesure_sinus_0_1_Hz_V2.mat", "time", "input", "output", "fs");

[frequency3, gain3, phase3] = get_bode_point(input(1:300000), output(1:300000), time(1:300000), 0.12, 0.5, 1, -2, -0.3)

load("data/labo3/mesure_sinus_0_5_Hz_V2.mat", "time", "input", "output", "fs");

[frequency4, gain4, phase4] = get_bode_point(input(1:200000), output(1:200000), time(1:200000), 0.5, 0.5, 1, -2, -0.3)

load("data/labo3/mesure_sinus_0_2_Hz_V2.mat", "time", "input", "output", "fs");

[frequency5, gain5, phase5] = get_bode_point(input(1:200000), output(1:200000), time(1:200000), 0.2, 0.5, 1, -2, -0.3)

H = tf(2.463, [1.703, 1]);
[mag, phase, wout] = bode(H);
hold on


tiledlayout(2,1)
nexttile
semilogx(wout, 20*log10(squeeze(mag)), 'r', 'LineWidth', 2)
hold on
semilogx([frequency1, frequency2, frequency3, frequency4, frequency5], [20*log10(gain1), 20*log10(gain2), 20*log10(gain3), 20*log10(gain4), 20*log10(gain5)], 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b')
grid on
xlabel('Frequency (rad/s)')
ylabel('Magnitude (dB)')
title('Bode plot')
legend('Theoretical', 'Experimental')
xlim([0.05,10])

nexttile
semilogx(wout, squeeze(phase), 'r', 'LineWidth', 2)
hold on
semilogx([frequency1, frequency2, frequency3, frequency4, frequency5], [phase1, phase2, phase3, phase4, phase5], 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b')
grid on
xlabel('Frequency (rad/s)')
ylabel('Phase (degrees)')
xlim([0.05, 10])



savefig("figures/labo3/bode_plot_all_measurements.fig")
saveas(gcf, "figures/labo3/bode_plot_all_measurements.png")
