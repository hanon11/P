function tramas = segmentacion(senal, numMuestras, despl)
    tramas = buffer(senal,numMuestras,numMuestras-despl,"nodelay");
end