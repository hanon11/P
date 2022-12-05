%% PRINCIPAL.m
close all
clear all

%% Parámetros
tiempoTrama = 0.03;
tiempoDesplTrama = 0.01;
a = 0.95;
ventana = 'rectangular';
numTramasRuido = 10;

fragmentos = [
    1       18000
    18000   33000
    33000   47000
    47000   64000
    64000   80000
    80000   96000
    96000   113000
    113000  130000
    130000  146800
    146800  166000];

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
    
    [ini, fin] = inicioFin (conjTramas, numTramasRuido, ventana);
    
    palabra = invSegmentacion (conjTramas(:,ini:fin), longDespTrama);
    
    figure, 
    subplot(1,2,1),plot(y(fragmentos(i,1):fragmentos(i,2)));
    subplot(1,2,2),plot(palabra);
    
    pause;
end



 