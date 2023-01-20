function pitch = calcular_pitch(data, fs)
    ventana = hamming(length(data));

    for k = 1:floor(length(data)/2)-1
        data1 = data(floor(length(data)/2):length(data));
        data2 = data(floor(length(data)/2)-k:length(data)-k);
        ventana1 = ventana(floor(length(data)/2):length(data));
        ventana2 = ventana(floor(length(data)/2)-k:length(data)-k);
        STAMDF(k) = sum(abs(data1.*ventana1 - data2.*ventana2));
    end
    [~,indices] = sort(STAMDF);
    periodo_fundamental = indices(2)/fs;
    pitch = 1/periodo_fundamental;
end