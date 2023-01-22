%%
close all
clear all

intervalo = 1; %1 segundo
Fs = 100;      %Frec. de muestreo
FsCont = 1000000; %Frec. de muestreo (simulación se señal continua)

%Parámetros de la señal
A = 1; %por poner algo
F = [2.5, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200]; % a partir de la 60 no funciona
Fase = 0; %variar la fase

tCont = 0:1/FsCont:intervalo;

for i = 1: length(F)
    tDisc = 0:1/Fs:intervalo;
    
    yCont = A * cos(2*pi*F(i)*tCont + Fase);
    
    yDisc = A * cos(2*pi*F(i)*tDisc + Fase);
    
    figure,
    plot(tCont,yCont);
    hold on;
    plot(tDisc,yDisc,'x--r');
    title (['Frecuencia = ',num2str(F(i)),'Hz']);
    pause;
end