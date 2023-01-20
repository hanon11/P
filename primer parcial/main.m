%% Lucía Atienza Olmo
clear all, close all
load muestraN2022_1D.mat
Fs = 400;

F = fft(y);
%% ¿Componente continua?
ComponenteContinua = F(1)/length(F);

%% ¿Amplitud de cada función? 
espectro = find(abs(F)>0.1);
espectro = espectro(2:end); %quitamos la componente continua
A = abs(F(espectro))/Fs;

%% ¿Frecuencia de cada función? 
f = linspace(0,Fs,length(y)+1);
frec = f(abs(F) > 0.1); %la 0 es la componente continua. Las 5 siguientes son las frecuencias. 
%Las 5 restantes son las simetricas conjugadas

%% ¿Fase de cada función? 
angulo = angle(F(espectro)); % son 10 valores, los 5 ultimos son los simetricos conjugados
%como la frecuencia mas alta y más baja corresponden a señales
%senosoidales, el valor corresponde al devuelto en la línea anterior + pi/2. Las
%otras 3, no necesitan tener un incremento de pi/2 por el hecho de ser señales
%cosenosoidales
angulo(1) = angulo(1) + pi/2; % luego añadimos pi/2 a las señales seno
angulo(5) = angulo(5) + pi/2; % luego añadimos pi/2 a las señales seno


%% ¿Cuál es la frecuencia fundamental?¿Y los armónicos? 
final = (length(frec)-1)/2;
FF = min(frec(2:final));

%% ¿Cuál es el ancho de banda?

%% ¿Cuál es la resolución espectral? 
ResolEspect = Fs/length(y);

%% Visualice la parte real y la parte imaginaria del espectro de frecuencias. ¿Qué observas? 
f = linspace(0,Fs,length(y)+1);
figure,
bar(f(1:end-1), real(F)); title("Parte real");

figure,
bar(f(1:end-1), imag(F)); title("Parte imaginaria");
%%  eliminar la función con la frecuencia más alta
figure
plot(f(1:end-1), fftshift(ifft(F)));title("Antes de eliminar")

y(espectro(length(espectro)/2)) = 0;
y(espectro(length(espectro))) = 0;
nuevaF = fft(y);
figure
plot(f(1:end-1), fftshift(ifft(nuevaF)));title("Despues de eliminar")

%%  Incremente la resolución espectral a 1024
f = linspace(0,Fs,1025);
F = fft(y,1024);
figure
plot(f(1:end-1), ifft(F));





