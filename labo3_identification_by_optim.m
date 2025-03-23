clc;
clear all;
close all;

% load the data
load("data/labo1/mesure_pulse_6.mat", "time", "input", "output");
Fs = 10000;

A0_initial_guess = 6.02;
T_initial_guess = 0.367;

number_of_poles = 1;
number_of_zeros = 0;
is_integrator = true;

% find the starting values with the mean over the first second
u0 = mean(input(1:10000));
delta = std(input(1:10000));
y0 = mean(output(1:10000));

% find the start index :
start_index = find(input > u0 + 10*delta, 1);

% choose the end index when the output settles
y_final = mean(output(end-10000:end));
delta_y_final = std(output(end-10000:end));
end_index = find(movmean(output, 500) < y_final - (y_final-y0) * 0.05, 1, 'last');
end_index = end_index + (end_index - start_index)*2;

plot(time(start_index:end_index), output(start_index:end_index) - y0, time(start_index:end_index), input(start_index:end_index) - u0);
title("selected data");
xlabel("time [s]");
ylabel("input/output [V]");

training_input = input(start_index:end_index) - u0;
training_output = output(start_index:end_index) - y0;
training_time = time(start_index:end_index);

cost_func_order1 = @(x) labo3_cost(x, training_input, training_output, training_time, number_of_poles, number_of_zeros, is_integrator);
cost_func_order2 = @(x) labo3_cost(x, training_input, training_output, training_time, number_of_poles +1, number_of_zeros, is_integrator);


options = optimset('Display', 'iter', 'MaxFunEvals', 10000, 'MaxIter', 10000);
x_order1 = fminsearch(cost_func_order1, [A0_initial_guess, T_initial_guess], options)
x_order2 = fminsearch(cost_func_order2, [A0_initial_guess, 0, T_initial_guess], options)

sys = labo3_generate_sys(x_order1, number_of_poles, number_of_zeros, is_integrator);
sys_order_2= labo3_generate_sys(x_order2, number_of_poles +1, number_of_zeros , is_integrator);
simulated_output = lsim(sys, training_input, training_time);
simulated_output_order_2 = lsim(sys_order_2, training_input, training_time);

figure
% tiledlayout(1,2)
% set figure size
set(gcf, 'Position',  [100, 100, 550, 500])
nexttile
hold on
plot(training_time, training_output);
plot(training_time, simulated_output, training_time, simulated_output_order_2, "LineWidth", 3);
% title("output vs simulated output on training data");
xlabel("time [s]", "fontsize", 15);
ylabel("output [V]", "fontsize", 15);
legend("real output", "simulated output order 1", "simulated output order 2");
% put the legend on the lower right corner
legend('Location', 'southeast', "fontsize", 13);
xlim("tight");

% nexttile
% simulated_output_full_range = lsim(sys, input - u0, time);
% simulated_output_full_range_graphique = lsim(sys_graphique, input - u0, time);
% plot(time, output - y0);
% hold on
% plot(time, simulated_output_full_range, time, simulated_output_full_range_graphique, "LineWidth", 3);
% title("output vs simulated output on all data");
% xlabel("time [s]");
% ylabel("output [V]");
% legend("real output", "simulated output", "simulated output with initial guess");
% % put the legend on the lower right corner
% legend('Location', 'southeast', "fontsize", 13);


savefig("figures/labo3/optim_identif_param_order_2.fig");
saveas(gcf, "figures/labo3/optim_identif_param_order_2.png");



