function exterma = interpolateExterma(X, Y, Z)
% Exterpolation and Exterma extraction
% Each input is an array with 2 values, t and f(t).
    exterma = Y(1)+...
        ((X(2)-Y(2))*(Z(1)-Y(1))^2 - (Z(2)-Y(2))*(Y(1)-X(1))^2)...
        /(2*(X(2)-Y(2))*(Z(1)-Y(1)) + (Z(2)-Y(2))*(Y(1)-X(1)));
end
