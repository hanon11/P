clear all;
close all;
clc

%% Ejercicio 1
t = 2;
Fs = 8000;
Ch = 1;
num_bits = 16;

senal = grabacion(t, Fs, Ch, num_bits);

% Recortar señal
figure,
subplot(1, 2, 1), plot(senal), title("Original");
[x,y] = ginput(2);
senal = senal(round(x(1)):round(x(2)));
subplot(1, 2, 2), plot(senal), title("Recortada");
%load('senal.mat')

%% Ejercicio 2
a = 0.9;

senalPre = preenfasis(senal, a);

figure, plot(abs(fft(senal))), hold on;
plot(abs(fft(senalPre))), hold off;
title("Original vs Preenfasis");
legend("Original", "Preenfasis");

figure, subplot(1, 2, 1), plot(abs(fft(senalPre))), title("Original");
subplot(1, 2, 2), plot(abs(fft(senal))), title("Preenfasis");

%% Ejercicio 3
num_muestras = 51;
despl = 1024;

%ventana = "rectangular";
%ventana = "hamming";
ventana = 'hanning';

segmentos = segmentacion(senal, num_muestras, despl);
segmento_enventanados = enventanado(segmentos, ventana);

figure, plot(abs(fft(segmentos)));
figure, plot(abs(fft(segmento_enventanados)));

%% Ejercicio 4

salidaE = energia(segmentos, 'hanning');
salidaM = magnitud(segmentos, 'hanning');
salidaCPC = cruces_por_cero(segmentos, 'hanning');


%% Ejercicio 5
load('senal.mat')
figure, plot(senal);
segmentos_nuevos = inicio_fin(segmentos, 10);

%% Ejercicio 6
palabra = inv_segmentacion(segmentos_nuevos,despl);
