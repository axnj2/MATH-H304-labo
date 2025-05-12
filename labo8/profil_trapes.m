clear all
Ts=0.005;%Set the sampling time.
lengthExp=40; %Set the length of the experiment (in seconds).
N0=lengthExp/Ts; %Compute the number of points to save the datas.

consigne_initiale = -1;
consigne_finale = 8;
T_ramp_start = 1;
v_max = 1/(2); % en volt / s
a_max = v_max/(5);
T_phase_1 = v_max/a_max;
distance_phase1 = v_max^2/(2*a_max);
temps_phase_2 = (abs(consigne_finale - consigne_initiale) - 2* a_max*(T_phase_1)^2)/v_max;


consigne_hist = zeros(N0, 1);

trapeseconsigne = 0;
phase = 0;
for i = 1:N0
    consigne_hist(i) = -trapeseconsigne + consigne_initiale;
    if  i*Ts > (T_ramp_start+ 2*T_phase_1 + temps_phase_2)
        ;
    elseif i*Ts > (T_ramp_start+ T_phase_1 + temps_phase_2)
        trapeseconsigne = distance_phase1 + v_max*(T_ramp_start+ T_phase_1 + temps_phase_2 - T_ramp_start - T_phase_1) - a_max/2*(i*Ts-(T_ramp_start+ T_phase_1 + temps_phase_2))^2 + v_max*(i*Ts -(T_ramp_start+ T_phase_1 + temps_phase_2));
    elseif  i*Ts > (T_ramp_start+ T_phase_1)
        trapeseconsigne = distance_phase1 + v_max*(i*Ts - T_ramp_start - T_phase_1);
    elseif i*Ts > T_ramp_start
        trapeseconsigne = a_max/2*(i*Ts-T_ramp_start)^2;
    end
end

plot(consigne_hist)
