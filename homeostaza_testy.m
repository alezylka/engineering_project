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
metabolizm = 0.126;
C16 = 12750;

% Warunki początkowe
ATP0 = 0.57;
Gli0 = 300;
I0 = 0.05;
E0 = 1.3;
y0 = [ATP0, Gli0, I0, E0, C16];

% Zakresy testowanych wartości
maxGli_values = linspace(300, 500, 6); % Testowane wartości maxGli
ATPgli_values = [0.1, 0.25, 0.5]; % Testowane wartości ATPgli

% Inicjalizacja zmiennych do przechowywania wyników
results = cell(length(maxGli_values), length(ATPgli_values));

% Czas symulacji
tspan = [0 720];

% Pętla dla maxGli
for i = 1:length(maxGli_values)
    maxGli = maxGli_values(i);

    % Pętla dla ATPgli
    for j = 1:length(ATPgli_values)
        ATPgli = ATPgli_values(j);

        % Rozwiązanie układu równań różniczkowych
        [t, solution] = ode45(@(t, y) model_skl_zapas(t, y, ATPi, ATPgli, maxGli, metabolizm, b1, b2, b3, c1, c2, c3, b1), tspan, y0);

        % Zapisanie wyników do komórki results
        results{i, j} = struct('maxGli', maxGli, 'ATPgli', ATPgli, 't', t, 'solution', solution);

    end
end


% Analiza wyników (przykładowa analiza: rysowanie wykresów)
for i = 1:length(maxGli_values)
    for j = 1:length(ATPgli_values)
        result = results{i, j};
        
        % Rysowanie wykresów
        figure;
        subplot(2, 2, 1);
        plot(result.t, result.solution(:, 1), 'b', 'LineWidth', 0.5);
        xlabel('Czas [min]');
        ylabel('Stężenie glukozy [mol ATP]');
        title(['ATP - maxGli=', num2str(result.maxGli), ', ATPgli=', num2str(result.ATPgli)]);

        subplot(2, 2, 2);
        plot(result.t, result.solution(:, 2), 'g', 'LineWidth', 0.5);
        xlabel('Czas [min]');
        ylabel('Ilość glikogenu [g]');
        title(['Glikogen - maxGli=', num2str(result.maxGli), ', ATPgli=', num2str(result.ATPgli)]);

        subplot(2, 2, 3);
        plot(result.t, result.solution(:, 3), 'r', 'LineWidth', 0.5);
        xlabel('Czas [min]');
        ylabel('Stężenie insuliny [j.u.]');
        title(['Insulina - maxGli=', num2str(result.maxGli), ', ATPgli=', num2str(result.ATPgli)]);

        subplot(2, 2, 4);
        plot(result.t, result.solution(:, 4), 'm', 'LineWidth', 0.5);
        xlabel('Czas [min]');
        ylabel('Stężenie glukagonu [j.u.]');
        title(['Glukagon - maxGli=', num2str(result.maxGli), ', ATPgli=', num2str(result.ATPgli)]);

        figure;
        plot(result.t, result.solution(:, 5), 'r', 'LineWidth', 0.5);
        xlabel('Czas [min]');
        ylabel('Poziom kwasów tłuszczowych [g]');
        title(['C16 - maxGli=', num2str(result.maxGli), ', ATPgli=', num2str(result.ATPgli)]);
    end
end

