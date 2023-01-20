function salidaMag = magnitud(tramas, ventana)
     if isequal(ventana, 'rectangular')
        Vent = rectwin(size(tramas, 1));
    end
    if isequal(ventana, 'hanning')
        Vent = hanning(size(tramas, 1));
    end
    if isequal(ventana, 'hamming')
        Vent = hamming(size(tramas, 1));
    end

    salidaMag = sum(abs(tramas) .* Vent);
end

