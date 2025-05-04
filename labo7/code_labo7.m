clear all; close all; clc;

kp = 5;                         
w_n =  0.01;
zeta = 0.7;
G = tf((w_n^2), [1 2*zeta*w_n (w_n^2)]);      % Système réglé 

% Régulateur analogique 
L_cont = kp * G;

% Fréquences d’échantillonnage
fs1 = 100;                     
fs2 = 0.5;                      
Ts1 = 1/fs1;                    
Ts2 = 1/fs2;                    

% ici on prend un retard d’une période complète d’échantillonnage
delay1 = tf(1,1,'InputDelay', Ts1);
delay2 = tf(1,1,'InputDelay', Ts2);

% Boucles ouvertes avec régulation numérique approximée
L_num1 = kp * G * delay1;
L_num2 = kp * G * delay2;

figure;
bode(L_cont, 'b', L_num1, 'r--', L_num2, 'g-.');
legend('Régulateur continu', ...
       sprintf('Numérique, fs1 = %.1f Hz', fs1), ...
       sprintf('Numérique, fs2 = %.1f Hz', fs2));
title('Comparaison des courbes de Bode - Boucles ouvertes');
grid on;


[Gm_cont, Pm_cont, Wcg_cont, Wcp_cont] = margin(L_cont);
[Gm1, Pm1, Wcg1, Wcp1] = margin(L_num1);
[Gm2, Pm2, Wcg2, Wcp2] = margin(L_num2);

% on s'en fout de Wcg et Wcp, ce qu'on veut c'est marge de gain et marge de
% phase donc Gm et Pm

fprintf('Régulateur continu      : marge de gain = %.2f dB, marge de phase = %.2f°\n', 20*log10(Gm_cont), Pm_cont);
fprintf('Régulation numérique fs1: marge de gain = %.2f dB, marge de phase = %.2f°\n', 20*log10(Gm1), Pm1);
fprintf('Régulation numérique fs2: marge de gain = %.2f dB, marge de phase = %.2f°\n', 20*log10(Gm2), Pm2);
