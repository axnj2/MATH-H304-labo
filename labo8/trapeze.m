clc; clear all;  close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Automatique : Code de mise en oeuvre du régulateur numérique en temps réel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

openinout; %Open the ports of the analog computer.
Ts=0.005;%Set the sampling time.
lengthExp=40; %Set the length of the experiment (in seconds).
N0=lengthExp/Ts; %Compute the number of points to save the datas.
Data=zeros(N0,1); %Vector saving the datas. If there are several datas to save, change "1" to the number of outputs.
DataCommands=ones(N0,1); %Vector storing the input sent to the plant.
errordata = zeros(N0,1);
refdata = ones(N0,1);
realcommand = zeros(N0,1);
cond=1; %Set the condition variable to 1.
i=2; %Set the counter to 1.
tic %Begins the first strike of the clock.
time=0:Ts:(N0-1)*Ts; %Vector saving the time steps.

u0 = -0.32;
kp = 0.69;
kd = 0.2;
T_f = kd/(kp*10);
consigne = -1;
refdata = zeros(N0,1);
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ramp time
consigne_initiale = -1;
consigne_finale = 8;
T_ramp_start = 5;
v_max = 1/(1); % en volt / s
a_max = v_max/(2);
T_phase_1 = v_max/a_max;
distance_phase1 = v_max^2/(2*a_max);
temps_phase_2 = (abs(consigne_finale - consigne_initiale) - 2* a_max*(T_phase_1)^2)/v_max;
trapeseconsigne = 0

while cond==1

    [in1,in2,in3,in4,in5,in6,in7,in8]=anain; %Acquisition of the measurements. Change the variable names to meaningful ones.

    %%%%%%%%%%%%%%%%%% Put your control law here
    output_sys = -in1;
    %%%%%%%%%%%%%%%%%%
    erreur = (consigne-output_sys);

    input = kp*erreur + (1/(2*T_f + Ts) * ((2*T_f - Ts)* DataCommands(i-1) + 2*kd*(erreur - errordata(i-1))));
    anaout(input,0); %Command to send the input to the analog computer.

    Data(i,1)=output_sys; %Save one of the measurements (in1).
    DataCommands(i) = input; %Save the input send to the system/
    errordata(i) = erreur;
    realcommand(i)=in2;
    refdata(i) = consigne;

    t=toc; %Second strike of the clock.
    
    if  i*Ts > (T_ramp_start+ 2*T_phase_1 + temps_phase_2)
        ;
    elseif i*Ts > (T_ramp_start+ T_phase_1 + temps_phase_2)
        trapeseconsigne = distance_phase1 + v_max*(T_ramp_start+ T_phase_1 + temps_phase_2 - T_ramp_start - T_phase_1) - a_max/2*(i*Ts-(T_ramp_start+ T_phase_1 + temps_phase_2))^2 + v_max*(i*Ts -(T_ramp_start+ T_phase_1 + temps_phase_2));
    elseif  i*Ts > (T_ramp_start+ T_phase_1)
        trapeseconsigne = distance_phase1 + v_max*(i*Ts - T_ramp_start - T_phase_1);
    elseif i*Ts > T_ramp_start
        trapeseconsigne = a_max/2*(i*Ts-T_ramp_start)^2;
    end
    consigne = -trapeseconsigne + consigne_initiale;

    %%%%%%%%%%% Check if the computations are done within the sampling time
    if t>i*Ts
        disp('Sampling time too small');%Test if the sampling time is too small.
    else
        while toc<=i*Ts %Does nothing until the second strike of the clock reaches the sampling time set.
        end
    end
    if i==N0 %Stop condition.
        cond=0;
    end
    i=i+1;
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

closeinout %Close the ports.

figure %Open a new window for plot.
plot(time,Data(:,1),time,DataCommands(:), time, realcommand, time, refdata, time, errordata); %Plot the experiment (input and output).
legend("signal réglé", "commande", "commande réelle", "référence", "erreur")
save("../data/labo8/régu_trapeze","kd","Data", "DataCommands", "errordata", "realcommand", "refdata", "time")
