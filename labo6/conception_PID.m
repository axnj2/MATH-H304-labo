close all; clear all;

wn = 3.17e3;
zeta = 0.047;
s = tf('s');

syst_ref = wn^2/(s^2 + 2*zeta*wn*s + wn^2);
%bode(syst_ref);

sisotool(syst_ref);

% PID parameters
Kp = 1;
Ti = 0.001;
Td = 0.0001;
Tf = 0.00001;
% PID controller
PI = (Kp/(Ti*s))*(1+Ti*s);
PID = (Kp/(Ti*s))*(1+Ti*s)*((1+Td*s)/(Tf*s+1));

% series systems
syst_PI = series(PI, syst_ref);
syst_PID = series(PID, syst_ref);

% Bode plot
%figure(1);
%bode(syst_PI);
figure(2);
bode(syst_PID);
