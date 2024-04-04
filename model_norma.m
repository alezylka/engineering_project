function dydt = model_norma(t, y, ATPi, ATPgli, maxGli, metabolizm, b1, b2, b3, c1, c2, c3, d1)

    ATP = y(1);
    Gli = y(2);
    I = y(3);
    E = y(4);
    C16 = y(5); 

    var = maxGli > Gli;
    var2 = Gli > 0;
    var3 = ATP < ATPgli;

    % Zastosowanie funkcji schodkowej do kontroli aktywacji i dezaktywacji różnych procesów
    step_function = 25; % Przykładowa funkcja schodkowa - zawsze aktywna

     % Wyrażenie funkcji schodkowej w postaci potęgowej
    step_power_series = step_function * (heaviside(t - 4) - heaviside(t - 11));

    % Zastosowanie funkcji Heaviside'a do zmiany diety w trzech różnych przedziałach czasowych
    if (t >= 60 && t <= 65) || (t >= 400 && t <= 420) || (t >= 660 && t <= 670)
        % Wybór odpowiedniej wartości diety w zależności od przedziału czasowego
        if t >= 60 && t <= 65
            dieta = 9.12;
            % dieta = 12.12;
        elseif t >= 400 && t <= 420
            dieta = 5.13;
            % dieta = 6.13;
        elseif t >= 660 && t <= 670
            dieta = 3.42;
            % dieta = 3.42;
        end
    else
        dieta = 0; % Po upływie czasu zdefiniowanego w funkcji Heaviside'a dieta wraca do zera
    end
    
    %dieta = 0.65 * (1 + heaviside(t - 5) * heaviside(10 - t));
    dATPdt = -metabolizm + dieta - (E / I) * var * ATP + (I / E) * (Gli * (38/180));
    dglikogendt = (((E / I) * var * ATP * 180) / 38) - (I / E) * var2 * Gli;
    dIdt = b1 * (ATP - ATPi) - b2 * I + b3;
    dEdt = -c1 * (ATP - ATPgli) * var3 - c2 * E + c3;

    % Równanie opisujące przebieg kwasów tłuszczowych
    if (t >= 60 && t <= 65) || (t >= 400 && t <= 420) || (t >= 660 && t <= 670)
        % tutaj mnożę prawą stronę x0,0001, bo muszę spowolnić jeszcze
        % bardziej spalanie tłuszczów podczas jedzenia (uzupełniania
        % energii)
        %if Gli > maxGli
        %    dC16dt = abs(d1 * d1 * ((ATP * (E/I) * var * dIdt / 129) - d1 * C16 * (I / E)) * step_power_series);
        %else
        %    dC16dt = d1 * d1 * ((ATP * (E/I) * var * dIdt / 129) - d1 * C16 * (I / E)) * step_power_series;
        %end
        dC16dt = d1 * d1 * ((ATP * (E/I) * var * dIdt / 129) - d1 * C16 * (I / E)) * step_power_series;
    else
        %if Gli > maxGli
        %    dC16dt = abs(d1 * ((ATP * (E/I) * var * dIdt / 129) - d1 * C16 * (I / E)));
        %else
        %    dC16dt = d1 * ((ATP * (E/I) * var * dIdt / 129) - d1 * C16 * (I / E));
        %end
        % tutaj mnożę prawą stronę równania x0,01, bo tu tempo metabolizmu
        % jest do 100 razy mniejsze
        dC16dt = d1 * ((ATP * (E/I) * var * dIdt / 129) - d1 * C16 * (I / E));
    end

    dydt = [dATPdt; dglikogendt; dIdt; dEdt; dC16dt];
end
