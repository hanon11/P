function tramasEnventanadas = enventanado(tramas,ventana)
    tramasEnventanadas = [];
    nTramas=length(tramas);
    if strcmp(ventana,'hamming')
        v=hamming(nTramas);
    elseif strcmp(ventana,'hanning')
        v=hanning(nTramas);
    else
        v=rectwin(nTramas);
    end
    for i=1:size(tramas,2)
        tramasEnventanadas = [tramasEnventanadas tramas(:,i).*v];
    end
end