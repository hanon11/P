function salida=energia(segmentos,ventana)
    N=size(segmentos,1);
    
    if ventana == 'hanning'
            v=hanning(N);
    elseif ventana == 'hamming'
            v=hamming(N);
    else
            v=rectwin(N);
    end
    v=v.^2;
    segmentos=segmentos.^2;
    salida=sum(enventanado(segmentos,v));
end