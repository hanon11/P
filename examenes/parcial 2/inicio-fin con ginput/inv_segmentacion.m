function palabra = inv_segmentacion(segmentos, despl)
    palabra = segmentos(end-despl+1:end,:);
    palabra = palabra(:);
    
    inicio = segmentos(1:end-despl,1);
    palabra = [inicio;palabra];
end