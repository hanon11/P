function salida = tasaCrucesxCero(tramas, ventana)
    tamTrama = size(tramas,1);
    tramas = enventanado(tramas,ventana);
    salida = sum(abs(sign(tramas(2:end,:)) - sign(tramas(1:end-1,:)))/2) / tamTrama;
end
