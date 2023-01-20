function segmentos_enventanados = enventanado(segmentos, ventana)
    N=size(segmentos,1);
    
    if ventana == 'hanning'
            v=hanning(N);
    elseif ventana == 'hamming'
            v=hamming(N);
    else
            v=rectwin(N);
    end
    
    ventanas=repmat(v,1,size(segmentos,2));
    
    segmentos_enventanados=segmentos.*ventanas;
end