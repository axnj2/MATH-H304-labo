clear; clc; close all;

%% déf des modèles => H1(p) = A0 / [ p * (1 + p*T) ]
A0_1 = 2.463;
T_1  = 1.703;
num1 = A0_1; 
den1 = [T_1 1];
tf_system = tf(num1, den1, 'Name','Systeme réglé')  % en bo


%% ex de valeurs de gain pr voir
K1 = 4.2;  
K2 = 8.7;

TBF1_K1 = feedback(K1*tf_system, 1 );
TBF1_K2 = feedback(K2*tf_system, 1);

TBF1_K1_exp = tf([0,944], [0.114, 1], "Name", "exp syst avec K1")
TBF1_K2_exp = tf([0,982], [0.0575, 1], "Name", "exp syst avec K1")

disp('Premier Ordre, K=K1');
p1K1 = pole(TBF1_K1)

disp('Premier ordre, K=K2');
p1K2 = pole(TBF1_K2)

p1K1_exp = pole(TBF1_K1_exp)
p1K2_exp = pole(TBF1_K2_exp)




figure('Name','Avec PZMAP','NumberTitle','off');



% lieu d'evans
figure
rlocus(tf_system)
grid on
hold on
pzmap(TBF1_K1,"r", TBF1_K2, "r", TBF1_K1_exp, "b", TBF1_K2_exp, "b")%, "Color", "r")
%hold on
%pzmap(TBF1_K1_exp, TBF1_K1_exp)%, "Color", "b")
title('1er ordre, K=K1')
grid on



