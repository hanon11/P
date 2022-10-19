close all, clear all
N = 200;
Fs = 100;
A = [3 1 2 0.5];
F = [1 2 4 18];
Fase = [pi/4 0 pi/2 pi/2];

%% EJERCICIO 3
[x,y] = sindiscreta_compuesta(N,Fs,A,F,Fase);
figure, plot(x,y);
title("Ej3 - SinDiscretaCompuesta");

%% EJERCICIO 4
F = fft(y);
figure, plot(ifft(F));
title("Ej4 - Transformada de Fourier");

%% EJERCICIO 5
figure
bar(abs(F));
title("Ej5 - Modulo de la transformada");

%% EJERCICIO 6
figure
frecuencias = linspace(0,100,N+1);
bar(frecuencias(1:end-1), abs(F));
axis([0 20 0 300])
title("Ej6 - Con valores de frecuencia de estudio");

%% EJERCICIO 7
yPrima = y+5;

F = fft(yPrima);
figure
bar(frecuencias(1:end-1), abs(F));
axis([0 20 0 300])
title("Ej7");

%% EJERCICIO 8
figure
bar(frecuencias(1:end-1), angle(F));
title("Ej8");

%% EJERCICIO 9
figure
bar(frecuencias(1:end-1), real(F));
title("Ej9 - Parte real");
figure
bar(frecuencias(1:end-1), imag(F));
title("Ej9 - Parte imaginaria");

%% EJERCICIO 10
