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

% Warunki początkowe
ATP0 = 0.57;
Gli0 = 300;
I0 = 0.05;
E0 = 1.3;
C16 = 12750;
y0 = [ATP0, Gli0, I0, E0, C16];

% Czas symulacji
tspan = [0 20];

% Rozwiązanie układu równań różniczkowych
[t, solution] = ode45(@(t, y) model_brak_skl_zapas(t, y, ATPi, ATPgli, maxGli, metabolizm, 0, b1, b2, b3, c1, c2, c3), tspan, y0);

% Zastosowanie filtracji dolnoprzepustowej na przebiegu glikogenu
glikogen_filtered = sgolayfilt(solution(:, 2), 4, 21); % Eksperymentalnie dobrane stopnie i długość okna

% Wykresy
figure;

subplot(2, 2, 1);
plot(t, solution(:, 1), 'b', 'LineWidth', 0.5);
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