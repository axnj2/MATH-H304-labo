% Renommage des variables
temps = time;            % Temps (s)
commande_u = input;      % Commande u(t)
sortie_y = output;       % Sortie y(t)
consigne_r = reference;  % Consigne r(t)

% Affichage des signaux sans normalisation
figure('Name','Acquisition en temps réel','NumberTitle','off');
hold on; grid on;
plot(temps, commande_u, 'LineWidth', 1.5, 'DisplayName', 'commande u(t)');
plot(temps, consigne_r, 'LineWidth', 1.5, 'DisplayName', 'consigne r(t)');
plot(temps, sortie_y, 'LineWidth', 1.5, 'DisplayName', 'sortie y(t)');

% Ajout des labels et légende
xlabel('temps (s)');
ylabel('amplitude (V)');
legend('Location', 'best');
hold off;
