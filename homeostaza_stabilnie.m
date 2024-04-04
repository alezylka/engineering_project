% Main script code

% Stałe modelu
b1 = 0.01;
b2 = 0.08;
b3 = 0.09;
c1 = 2;
c2 = 0.06;
c3 = 0.72;

% Zmienne modelu
ATPi = 0.57;
ATPgli = 0.2546;
maxGli = 300;
metabolizm = 0.126;
C16 = 12750;

% Warunki początkowe
ATP0 = 0.57;
Gli0 = 300;
I0 = 0.05;
E0 = 1.3;
y0 = [ATP0, Gli0, I0, E0, C16];

% Czas symulacji
tspan = [0 720];

% Dodatkowe opcje solvera ODE związane z obsługą zdarzeń
% options = odeset('Events', @(t, y) diet_event(t, y, maxGli));

% Rozwiązanie układu równań różniczkowych
[t, solution] = ode45(@(t, y) model1(t, y, ATPi, ATPgli, maxGli, metabolizm, b1, b2, b3, c1, c2, c3, b1), tspan, y0);


% Zastosowanie filtracji dolnoprzepustowej na przebiegu ATP i glikogenu
atp_filtered = sgolayfilt(solution(:, 1), 3, 23);
glikogen_filtered = sgolayfilt(solution(:, 2), 5, 25); 
%fat_filtered = sgolayfilt(solution(:, 5), 8, 29);

% Obliczenie wartości 'dieta' dla każdego kroku czasowego
% dieta_values = 0.65 * (heaviside(t - 5) .* heaviside(10 - t));

% Stosunek glukagonu do insuliny
glukagon_to_insulina = solution(:, 4) ./ solution(:, 3);

% Stosunek insuliny do glukagonu
insulina_to_glukagon = solution(:, 3) ./ solution(:, 4);

% Wykresy
figure;

subplot(2, 2, 1);
plot(t, atp_filtered, 'b', 'LineWidth', 0.5);
xlabel('Czas [min]');
ylabel('Stężenie glukozy [mol ATP]');
title('ATP');

subplot(2, 2, 2);
plot(t, glikogen_filtered, 'g', 'LineWidth', 0.5);
xlabel('Czas [min]');
ylabel('Ilość glikogenu [g]');
title('Glikogen');

subplot(2, 2, 3);
plot(t, solution(:, 3), 'r', 'LineWidth', 0.5);
xlabel('Czas [min]');
ylabel('Stężenie insuliny [j.u.]');
title('Insulina');

subplot(2, 2, 4);
plot(t, solution(:, 4), 'm', 'LineWidth', 0.5);
xlabel('Czas [min]');
ylabel('Stężenie glukagonu [j.u.]');
title('Glukagon');
sgtitle('Symulacja układu równań różniczkowych');

figure;
plot(t, solution(:, 5), 'r', 'LineWidth', 0.5);
xlabel('Czas [min]');
ylabel('Poziom kwasów tłuszczowych [g]');
title('C16');


