orden = 10;

lpc_segmento = lpc(segmento,orden);

Fourier = fft(segmento);

frecuencias = linspace(0,Fs,length(segmento)+1);
frecuencias = frecuencias(1:end-1);

estsenal = filter([0 -lpc_segmento(2:end)],1,[segmento;zeros(orden,1)]);
error = [segmento;zeros(orden,1)] - estsenal;
G = sqrt(sum(error .^ 2));

H = freqz(G,lpc_segmento,round(length(segmento)/2));
Fourier = Fourier(1:round(length(segmento)/2));
frecuencias = frecuencias(1:round(length(segmento)/2));

 

figure, plot(frecuencias, 20*log10( abs(Fourier) + eps ));

hold on, plot(frecuencias, 20*log10(abs(H) + eps ),'r');