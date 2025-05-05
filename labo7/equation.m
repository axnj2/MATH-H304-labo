% Paramètres du régulateur et de l'échantillonnage
k_p = ...;      % Gain proportionnel
k_d = ...;      % Gain dérivé
T_s = ...;      % Constante du filtre dérivé
T_e = ...;      % Période d'échantillonnage

% Pré-calculs des coefficients
a0 = T_e + 2*T_s;
a1 = T_e - 2*T_s;

b0 = k_p*(T_e + 2*T_s) + 2*k_d;
b1 = k_p*(T_e - 2*T_s) - 2*k_d;

alpha = a1 / a0;
beta0 = b0 / a0;
beta1 = b1 / a0;

% Initialisation
u = zeros(1, N);     % N = nombre d'échantillons
e = zeros(1, N);     % vecteur de l'erreur e(k)
% Remplir e avec les valeurs désirées (e.g. e = r - y)

% Boucle de calcul (début à k=2 car on a besoin de e(k-1), u(k-1))
for k = 2:N
    u(k) = -alpha * u(k-1) + beta0 * e(k) + beta1 * e(k-1);
end
