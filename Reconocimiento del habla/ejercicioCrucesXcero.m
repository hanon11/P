close all
clear all
%% Lectura de la señal de audio
[y,Fs] = audioread('a(1).wav');
ventana = 'rectangular';
tiempoTrama = 0.03;
tiempoDesplTrama = 0.01;
a = 0.95;

y = y(:,1); %Nos quedamos con el primer canal
y = y(110834:132398); %me quedo con una parte de la señal
figure
x = linspace(-pi,pi,length(y))';
plot(x,y);
y = preenfasis(y,a);

%% Segmentación
longTrama = round(Fs * tiempoTrama);
longDespTrama = round (Fs * tiempoDesplTrama);

conjTramas = segmentacion(y,longTrama,longDespTrama);
    
conjTasaCrucesCeros = tasaCrucesxCero(conjTramas,ventana);
figure
bar(conjTasaCrucesCeros);
