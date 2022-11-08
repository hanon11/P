function salida = energia(tramas, ventana)
    nTramas=length(tramas);
    if ventana == "hanning"
        v=hanning(nTramas);
    elseif ventana == "hamming"
        v=hamming(nTramas);
    else
        v=rectwin(nTramas);
    end
    salida=sum(enventanado(tramas.^2,v.^2));
end