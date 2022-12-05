function salida = magnitud(tramas, ventana)
    tramas = enventanado(tramas,ventana);
    salida = sum(abs(tramas));
end