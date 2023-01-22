%% 
clc;
clear all;
close all;
operacion = 'convolución';
%operacion = 'correlación';

%% Señales (el nº de muestras debe ser impar)
%x = [0.25 0.5 1 0.5 0.25];
x = [1 2 3 2 1];
% Señal periódica 2 cos (2*pi*2) y con Fs = 40
%x = [2 1.9021 1.6180 1.1756 0.618 0 -0.618 -1.1756 -1.618 -1.9021 -2 -1.9021 -1.618 -1.1756 -0.618 0 0.618 1.1756 1.618 1.9021 2 1.9021 1.618 1.1756 0.618 0 -0.618 -1.1756 -1.618 -1.9021 -2 -1.9021 -1.618 -1.1756 -0.618 0 0.618 1.1756 1.618 1.9021 2];
% Señal periódica 2 cos (2*pi*2) y con Fs = 4
%x = [-2 2 -2 2 -2 2 -2];
    
%h = = [0.25 0.5 1 0.5 0.25];
%h = [1 2 3 4 5];
h = [1 2 3 2 1];
%h = [1 1 1 1 1];
%h = [1 0.5 0 0.5 1];
%h = [0 0 1 0 0];
%h = [0 1 0 0 0];
%h = [0 0 0 0 1];
% Señal periódica 2 cos (2*pi*2) y con Fs = 40
%h = [2 1.9021 1.6180 1.1756 0.618 0 -0.618 -1.1756 -1.618 -1.9021 -2 -1.9021 -1.618 -1.1756 -0.618 0 0.618 1.1756 1.618 1.9021 2 1.9021 1.618 1.1756 0.618 0 -0.618 -1.1756 -1.618 -1.9021 -2 -1.9021 -1.618 -1.1756 -0.618 0 0.618 1.1756 1.618 1.9021 2];
% Señal periódica 2 cos (2*pi*2) y con Fs = 4
%h = [-2 2 -2 2 -2 2 -2];

%% Se representa
n = 5; %Posición donde comienza la convolución/correlación
%n = 50; %Posición donde comienza la convolución/correlación para la señal periódica con Fs = 40
%n = 9;  %Posición donde comienza la convolución/correlación para la señal periódica con Fs = 4

dominio = -n-ceil(length(h)/2):n+ceil(length(h)/2);
rangox = zeros(size(dominio));
rangoh = zeros(size(dominio));
rangoconv = zeros(size(dominio));

%Centramos las señales
centro = find(dominio == 0);
rangox(centro-round(length(x)/2)+1:centro+round(length(x)/2)-1) = x;
rangoh(centro-round(length(h)/2)+1:centro+round(length(h)/2)-1) = h;

figure,
subplot(3,1,1), stem(dominio,rangox), title('x');
subplot(3,1,2), stem(dominio,rangoh), title('h');
subplot(3,1,3), stem(dominio,rangoconv), title (operacion);
pause(0.5);
%% Se refleja la señal (si la operación es convolución)

if operacion == 'convolución'
    h = h(end:-1:1);
    rangoh(round(length(rangoh)/2)-round(length(h)/2)+1:round(length(rangoh)/2)-round(length(h)/2)+length(h)) = h;
end


subplot(3,1,1), stem(dominio,rangox), title('x');
subplot(3,1,2), stem(dominio,rangoh), title('h');
subplot(3,1,3), stem(dominio,rangoconv), title (operacion);
pause(0.5);
%% Comienza la convolución/correlación

for i=-n:n
    posicion = find(i == dominio);
    rangoh = zeros(size(dominio));
    rangoh(posicion-round(length(h)/2)+1:posicion+round(length(h)/2)-1) = h;

    rangoconv(posicion) = sum(rangox .* rangoh);
    
    
    subplot(3,1,1), stem(dominio,rangox), title('x');
    subplot(3,1,2), stem(dominio,rangoh), title('h');
    subplot(3,1,3), stem(dominio,rangoconv), title (operacion);
    pause(0.5);
end 
    