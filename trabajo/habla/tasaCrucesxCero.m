function tCC = tasaCrucesxCero(t, V)
    Vals = sign(t);
    if isequal(V, 'rectangular')
        Vent = rectwin(size(t, 1)-1);
    end
    if isequal(V, 'hanning')
        Vent = hanning(size(t, 1)-1);
    end
    if isequal(V, 'hamming')
        Vent = hamming(size(t, 1)-1);
    end

    tCC = (1 / size(Vals, 1)) * sum(0.5 .* abs(Vals(1:end-1, :) - Vals(2:end, :)) .* Vent);
end
