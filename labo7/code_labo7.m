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

% Fréquences d'échantillonnage
fs1 = 100;                     
fs2 = 0.5;                      
Ts1 = 1/fs1;                    
Ts2 = 1/fs2;                    

% ici on prend un retard d'une période complète d'échantillonnage
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

% Create a single figure with three subplots for margin plots
figure;

% Calculate margins for continuous controller
[Gm_cont, Pm_cont] = margin(L_cont);

subplot(3, 1, 1);
margin(L_cont, {1e-1, 1e2});
title(sprintf('Continuous Controller (GM = %.2f dB, PM = %.2f deg)', 20*log10(Gm_cont), Pm_cont));

% Calculate margins for digital controller 1
[Gm_num1, Pm_num1] = margin(L_num1);

subplot(3, 1, 2);
margin(L_num1, {1e-1, 1e2});
title(sprintf('Digital Controller, fs = %.1f Hz (GM = %.2f dB, PM = %.2f deg)', fs1, 20*log10(Gm_num1), Pm_num1));

% Calculate margins for digital controller 2
[Gm_num2, Pm_num2] = margin(L_num2);

subplot(3, 1, 3);
margin(L_num2, {1e-1, 1e2});
title(sprintf('Digital Controller, fs = %.1f Hz (GM = %.2f dB, PM = %.2f deg)', fs2, 20*log10(Gm_num2), Pm_num2));
ylim([-360, 0]);

% Adjust the layout
sgtitle('Margin Analysis Comparison');