function palabra = invSegmentacion(tramasPalabra, despl)
    palabra = [];
    for i = 1:size(tramasPalabra,2)
        palabra = [palabra tramasPalabra(1:despl,i)'];
    end
end