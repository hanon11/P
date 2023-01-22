clear all, close all, clc

% Cargamos la señal
load("nombre01.mat");

% Mostramos la señal
figure, plot(senal);
title("Señal original")

tiempoTrama = 0.03;
longTrama = tiempoTrama * Fs;

% Sospecho que las vocales estan en 1550 y 2700, y cojo las tramas en esas
% zonas
vocal1 = senal(1550:1550+longTrama-1);
vocal2 = senal(2700:2700+longTrama-1);

figure, plot(vocal1)
title("Trama vocal 1")
figure, plot(vocal2)
title("Trama vocal 2")

%% Calculo pitch mediante center clipping
porc_clip = 0.3;
umbral = porc_clip*max(abs(vocal1));

y = sign(vocal1) .* max(0, abs(vocal1)-umbral);

figure, plot(y);
title("Despues del center clipping")
% Ventana de hamming para reducir el inicio y el final de la trama
ventana = hamming(length(y));
y = y .* ventana;

%Correlacion
[correlacion, intervalos] = xcorr(y);
centro = round(length(correlacion)/2);
correlacion = correlacion(centro:end);
intervalos = intervalos(centro:end);
figure, plot(intervalos, correlacion);
title("Correlacion")

% Busco picos
[picos, maximos] = findpeaks(correlacion);
[~, ord] = sort(picos);
T0 = (maximos(ord(end))-1)/Fs;
pitch = 1 / T0;
disp("Como el pitch es " + num2str(pitch) + " > 195, el locutor es una mujer.")

%% Detección vocales
[F1_v1, F2_v1] = env(vocal1, Fs);
[F1_v2, F2_v2] = env(vocal2, Fs);

disp("F1 vocal 1: " + num2str(F1_v1) + "; F2 vocal 1: " + num2str(F2_v1));
disp("Según la gráfica, sería una letra 'O' (valores 'O': 500-700, 950-1200)");
disp("F1 vocal 2: " + num2str(F1_v2) + "; F2 vocal 2: " + num2str(F2_v2));
disp("Según la gráfica, sería una letra 'A' (valores 'A': 700-1000, 1200-2000)")

disp("Nombre: Lola        Sexo: Mujer");

function [F1, F2] = env(vocal, Fs)
    ventana = hamming(length(vocal));
    vocal = vocal .* ventana;
    
    orden = 10;
    lpcCoefs = lpc(vocal, orden);
    estimacion = filter([0 -lpcCoefs], 1, [vocal; zeros(orden, 1)]);
    error = [vocal; zeros(orden, 1)] - estimacion;

    G = sqrt(sumsqr(error));
    H = freqz(G, lpcCoefs, round(length(vocal)/2));

    frecuencias = linspace(1, Fs, length(vocal)+1);
    frecuencias = frecuencias(1:end-1);
    frecuencias = frecuencias(1:floor(length(vocal)/2));
    
    [~, maximos] = findpeaks(abs(H));
    F1 = frecuencias(maximos(1));
    F2 = frecuencias(maximos(2));
end