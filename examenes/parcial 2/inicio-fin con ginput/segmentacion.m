function segmentos=segmentacion(signal,num_muestras,despl)
    N=round(size(signal,1)/num_muestras);
    solap=N-despl;
    segmentos=buffer(signal,N,solap);
end