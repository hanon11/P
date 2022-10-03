Fs=200; %200 muestras por minuto
%la frecuencia de muestreo debe ser al menos el doble de las frecuencias de
%la señal
N = 400;
t = (0:N-1)*1/Fs;
y=2*cos(2*pi*5*t+0) + 6*cos(2*pi*3*t+pi/2) + 18*cos(2*pi*7*t +pi/4);

fourier=fft(y);
%va a devolver tantos numeros complejos como muestreos
frecuencias = linspace(0,Fs,N+1);

bar(frecuencias(1:end-1),abs(fourier));
pos = find(abs(fourier)>0.1);
frecuencias(pos);
amplitud = abs(fourier(pos))/(N/2);
fase = angle(fourier(pos));

figure, bar(frecuencias(1:end-1), real(fourier)); 
figure, bar(frecuencias(1:end-1), imag(fourier));
%la que tiene fase 0, solo tiene parte real. La que tiene fase pi/2 solo
%tiene parte imaginaria. Por esto solo aparecen dos barras
% Imag
% ^
% |
% |
% |_________> Real
%resolucion espectral de 0.5 y el ancho de banda es la mitad de muestras de
%muestreo, ya que la segunda mitad es conjungada
%quitamos la frecuencia mas alta
fourier(15) = 0;
fourier(387) = 0;

figure, plot(t,y);
ynew = real(ifft(fourier));
figure, plot(t,ynew);
%que pasa si me cargo la baja frecuencia. Y la intermedia
%que ocurre si añado un valor a y (y=y+5) Esta info esta en la componente
%continua de forma escalada.
