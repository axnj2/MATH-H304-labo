function sys = labo3_generate_sys(coeff,  n_poles, n_zeros,  is_integrator)
    arguments
        coeff (1,:) double % in order, the coeff of the numerator and then the coeff of the denominator
        % for example : a0x + a1/(b0x + 1) =>  [a0, a1, b0]
        % for exemple : a0x + a1/x(b0x + 1) => [a0, a1, b0] and is_integrator = true
        n_poles (1,1) double
        n_zeros (1,1) double
        is_integrator (1,1) logical
    end

    % extract the numerator and the denominator
    Num = coeff(1:n_zeros + 1);
    Den = coeff(n_zeros + 2:end);

    assert(length(Den) == n_poles);

    if is_integrator
        Den = [Den 1 0];
    else
        Den = [Den 1];
    end

    sys = tf(Num, Den);
end