function coefMel = MFCC(tramasPalabra, bancoFiltrosMel)
    aux = abs(fft(tramasPalabra));
    aux = aux(1:size(bancoFiltrosMel, 2), :);
    aux = bancoFiltrosMel * aux;

    coefMel = dct(log10(aux))';
end

