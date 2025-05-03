%%% Le but de ce script est de définir les valeurs des paramètres utilisés
%%% dans le fichier Simulink "SimuBFContinuDiscret" <- situé dans le dossier simulink


%%% Système
A0 = ;      %Gain statique
tau1 = ;    %Constante de temps 1
tau2 = ;    %Constante de temps 2 (0 si 1er ordre)
u0 = ;      %Point de fonctionnement : grandeur réglante
y0 = ;      %Point de fonctionnement : grandeur réglée
fs = ;      %Fréquence d'échantillonnage
echelon = ; %Amplitude de l'échelon de consigne

% Si votre système n'est pas intégrateur, décommentez la ligne suivante
% den = [tau1*tau2 tau1+tau2 1];

% Si votre système est intégrateur, décommentez la ligne suivante
den = [tau1*tau2 tau1+tau2 1 0];


%%% Contrôleur
kp = ;     %Gain


%%% Filtre anti-repli
zeta = ;   %Facteur d'amortissement
T = ;      %Position de la paire de pôle
wn = ;     %pulsation naturelle