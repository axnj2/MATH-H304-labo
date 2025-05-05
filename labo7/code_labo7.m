clear all; close all; clc;

kp = 0.22;                         
w_n =  100;
zeta = 0.7;
A0 = 5.35;
T = 0.45;
G = tf(A0, [T 1 0]);      % Système réglé 
F = tf((w_n^2), [1 2*zeta*w_n (w_n^2)]);   % Filtre anti-repli

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
L_num1 = kp * G * delay1 * F;
L_num2 = kp * G * delay2 * F;

figure;
bode(L_cont, 'b', L_num1, 'r--', L_num2, 'g-.');
legend('Régulateur continu', ...
       sprintf('Numérique, fs1 = %.1f Hz', fs1), ...
       sprintf('Numérique, fs2 = %.1f Hz', fs2));
title('Comparaison des courbes de Bode - Boucles ouvertes');
grid on;

figure
margin(L_cont, {1e-1, 1e2});
figure
margin(L_num1, {1e-1, 1e2});
figure
margin(L_num2, {1e-1, 1e2});
ylim([-360, 0])