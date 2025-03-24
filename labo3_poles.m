clear; clc; close all;

%% déf des modèles => H1(p) = A0 / [ p * (1 + p*T) ]
A0_1 = 5.58;
T_1  = 0.33;
num1 = A0_1; 
den1 = [T_1 1 0];
sys1_ol = tf(num1, den1, 'Name','Sys1erOrdre_OL');  % en bo

% H2(p) = A0 / [ p * (1 + p*T1 + p^2 * T2 ) ]
A0_2 = 5.522;  
T1_2 = 0.322;  
T2_2 = 0.0197;  
num2 = A0_2; 
den2 = [T2_2  T1_2  1  0];  % => p * (1 + p*T1_2 + p^2*T2_2)
sys2_ol = tf(num2, den2, 'Name','Sys2eOrdre_OL');  % Système en BO

%% ex de valeurs de gain pr voir
K1 = 0.22;  
K2 = 0.44;


TBF1_K1 = feedback(K1*sys1_ol, 1);
TBF1_K2 = feedback(K2*sys1_ol, 1);


TBF2_K1 = feedback(K1*sys2_ol, 1);
TBF2_K2 = feedback(K2*sys2_ol, 1);


disp('Premier Ordre, K=K1');
p1K1 = pole(TBF1_K1)

disp('Premier ordre, K=K2');
p1K2 = pole(TBF1_K2)

disp('Deuxieme Ordre, K=K1');
p2K1 = pole(TBF2_K1)

disp("Deuxieme Ordre, K=K2");
p2K2 = pole(TBF2_K2)



figure('Name','Avec PZMAP','NumberTitle','off');
subplot(2,2,1)
pzmap(TBF1_K1)
title('1er ordre, K=K1')
grid on

subplot(2,2,2)
pzmap(TBF1_K2)
title('1er ordre, K=K2')
grid on

subplot(2,2,3)
pzmap(TBF2_K1)
title('2e ordre, K=K1')
grid on

subplot(2,2,4)
pzmap(TBF2_K2)
title('2e ordre, K=K2')
grid on


% lieu d'evans
figure('Name','Lieu d''Evans : comparaisons','NumberTitle','off');

subplot(1,2,1)
rlocus(sys1_ol)
title('Lieu d''Evans du modèle 1er ordre')
grid on

subplot(1,2,2)
rlocus(sys2_ol)
title('Lieu d''Evans du modèle 2e ordre')
grid on
