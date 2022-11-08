function salida = tasaCrucesxCero(tramas, ventana)
    tramas = enventanado(tramas,ventana);
    S = sign(tramas);
    salida = sum(abs(S(2:end,:)-S(1:end-1,:))/2)/size(tramas,1);
end