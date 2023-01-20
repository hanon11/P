function salida=cruces_por_cero(segmentos,ventana)
    N = size(segmentos,1);
    S = sign(segmentos);
    result=(abs(S(:,2:end)-S(:,1:end-1)))/2;
    salida=sum(enventanado(result,ventana)/size(segmentos,2));
end