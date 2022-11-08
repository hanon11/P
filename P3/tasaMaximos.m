function salida = tasaMaximos(tramas, ventana)
    salida = [];
    for i=1:size(tramas,2)
        [max, index]=findpeaks(tramas(:,i));
        salida = [salida sum(index)];
    end
    salida = 1/2*enventanado(salida',ventana);
    salida = salida/size(tramas,2);
end