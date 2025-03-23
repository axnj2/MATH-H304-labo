function cost = labo3_cost(coeff, input, output, time, n_poles, n_zeros,  is_integrator)
    arguments
        coeff (:,1) double % in order, the coeff of the numerator and then the coeff of the denominator
        % for example : a0x + a1/(b0x + 1) =>  [a0, a1, b0]
        % for exemple : a0x + a1/x(b0x + 1) => [a0, a1, b0] and is_integrator = true
        input (:,1) double  % the input of the system has to centered input(0) = 0
        output (:,1) double % the output of the system has to centered output(0) = 0
        time (1,:) double   % time vector
        n_poles (1,1) double
        n_zeros (1,1) double
        is_integrator (1,1) logical
    end

    % extract the numerator and the denominator
    sys = labo3_generate_sys(coeff, n_poles, n_zeros, is_integrator);
    simulated_output = lsim(sys, input, time);

    epsilon = output - simulated_output;

    % cost is the sum of the square of the error
    cost = epsilon' * epsilon; 
end