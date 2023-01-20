%% Se nos da una señal de dos dimensiones y nos piden calcular los siguientes parámetros
clear all;
close all;

%% Datos que nos aportan para resolver el problema
load muestra_2D;

Fsx = 100;
Fsy = Fsx;

%% ¿Componente Continua?
fourier = fft2(z);

CC = sign(fourier(1,1)) * abs(fourier(1,1))/numel(z);

% Para la 1D: CC = sign(fourier(1,1)) * abs(fourier(1,1))/length(z);
% Apuntes extras:
% % ¿Que pasa si le añado 5 a la señal?
% z = z + 5;
% fourier = fft2(z);
% CC = sign(fourier(1,1)) * abs(fourier(1,1))/(prod(size(z))); % Sale 5
% 
% % ¿ Y si relleno fourier con ceros?
% fourier = fft2(z,1024,1024);
% CC = sign(fourier(1,1)) * abs(fourier(1,1))/(prod(size(z))); % Sale lo mismo, 5
% 
% z = z - 5;

%% ¿Amplitud de cada funcion? valores señal entre frecuencia de muestreo
mayor = find(abs(fourier) > 0.1);

A = abs(fourier(mayor(2:end)))/(numel(z)/2); % Ponemos de 2:end para quitarle la componente continua
% Para la 1D: A = abs(fourier(mayor(2:end)))/(length(z)/2);
%% ¿Frecuencias Fx y Fy de cada funcion?
frecx = linspace(0,Fsx,size(z,2)+1);
frecy = linspace(0,Fsy,size(z,1)+1);

[f,c] = find(abs(fourier) > 0.1); % Habria que comprobar si esta la componente continua

Fx = frecx(c);
Fy = frecy(f);
% PARA LA 1D: F = frec(indices)
%% ¿Fase de cada funcion (suponiendo que se trata de señales senosoidales)?

angulo = angle(fourier(mayor(2:end))) + pi/2;

% angulo = angle(fourier(mayor(2:end))) (Señales cosenosoidales)

%% ¿Resolución espectral en cada dimension?

resolucion_x = Fsx/size(z,2);
resolucion_y = Fsy/size(z,1);

%% ¿Cómo podría eliminar la función con el par de frecuencias distintas a cero?
[f,c] = find(abs(fourier) > 0.1);
indices = [f c];
for i = 1:size(indices, 1)
    if indices(i,1) ~= 1 && indices(i,2) ~= 1
        fourier(indices(i,1), indices(i,2)) = 0;
    end
end
%% GRAFICA FOURIER
figure, surf(abs(fourier));
figure, imagesc(abs(fourier)),colormap gray;
title("Transformada de Fourier 2D");
