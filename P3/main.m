close all
clear all
%% Parámetros
tiempoTrama = 0.03;
tiempoDesplTrama = 0.01;
a = 0.95;
ventana = 'rectangular';
fragmentos = [ 8099 12225
    23706 28950
    38180 43100
    53020 59150
    69120 75640
    84980 92510
    100788 107160
    118460 124700
    134900 142420
    152200 157500];
%% Lectura de la señal de audio
[y,Fs] = audioread('numeros.wav');
y = y(:,1); %Nos quedamos con el primer canal
%% Preénfasis
y = preenfasis(y,a);
%% Segmentación
longTrama = round(Fs * tiempoTrama);
longDespTrama = round (Fs * tiempoDesplTrama);
%% Extracción de características en el dominio del tiempo
for i=1:size(fragmentos,1)
    conjTramas = segmentacion (y(fragmentos(i,1):fragmentos(i,2)), ...
        longTrama, longDespTrama);
    conjEnergias = energia (conjTramas,ventana);
    conjMagnitudes = magnitud (conjTramas,ventana);
    conjTasaCrucesCeros = tasaCrucesxCero(conjTramas,ventana);
    conjTasaMaximos = tasaMaximos(conjTramas,ventana)/longTrama;
    figure,
    h(1) = subplot(2,2,1);plot(conjEnergias);
    h(2) = subplot(2,2,2);plot(conjMagnitudes);
    h(3) = subplot(2,2,3);plot(conjTasaCrucesCeros);
    h(4) = subplot(2,2,4);plot(conjTasaMaximos);
    linkaxes(h,'x');
end