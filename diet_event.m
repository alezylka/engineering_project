function [value, isterminal, direction] = diet_event(t, y, maxGli)
    % Zdarzenie występuje, gdy Gli osiągnie wartość maxGli
    value = y(2) - maxGli;
    isterminal = 1;  % Stop the integration
    direction = 1;   % Only when Gli is increasing
end
