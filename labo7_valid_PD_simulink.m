Simulink.sdi.clear;

%%% Le but de ce script est de définir les valeurs des paramètres utilisés
%%% dans le fichier Simulink "SimuBFContinuDiscret"

%%% Système
A0 = 5.35;    %Gain statique
T = 0.44;     %Constante de temps 1
u0 = 0;       %Point de fonctionnement : grandeur réglante
y0 = 0;       %Point de fonctionnement : grandeur réglée
fs = 10;      %Fréquence d'échantillonnage
echelon = 1;  %Amplitude de l'échelon de consigne

% Si votre système n'est pas intégrateur, décommentez la ligne suivante
% den = [tau1*tau2 tau1+tau2 1];

% Si votre système est intégrateur, décommentez la ligne suivante
den = [T 1 0];


%%% Contrôleur
kp = 0.69;
kd = 0.58;
T_filtrage = kd/(kp*10); %Constante de temps du filtre
D = tf(kp) + tf([kd 0], [T_filtrage 1]);
[num_reg, den_reg] = tfdata(D);


%%% Filtre anti-repli
zeta = 0.7;   %Facteur d'amortissement
T = 0.01;      %Position de la paire de pôle
wn =  100;     %pulsation naturelle
open("simulink/SimuBFContinuDiscret_regu_PD_2020a.slx")
out = sim("simulink/SimuBFContinuDiscret_regu_PD_2020a.slx");
out.yout.plot
