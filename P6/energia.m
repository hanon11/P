function salida = energia(tramas, ventana)
    tramasEnventanadas = zeros(size(tramas));

    tamTrama = size(tramas,1);
    switch ventana
        case 'rectangular'
            vent = rectwin(tamTrama);
        case 'hamming'
            vent = hamming(tamTrama);
        case 'hanning'
            vent = hanning(tamTrama);
    end
    
    for i = 1:size(tramas,2)
         tramasEnventanadas(:,i) = tramas(:,i).^2.*vent.^2;
    end
    salida=sum(tramasEnventanadas);

end