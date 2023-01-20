%% Realizado por Francisco Chanivet Sánchez
clear all;
close all;
load muestra2DFeb2022.mat;

fourier = fft2(z);
%% Apartado a) Componente Continua
CC = sign(fourier(1,1)) * abs(fourier(1,1))/numel(z);

%% Apartado b) Amplitud
ok = find(abs(fourier) > 0.1);

A = abs(fourier(ok(2:end)))/(numel(z)/2); % Como aparece la componente continua porque es mayor de 0, entonces empezaremos por el 2

%% Apartado c) Frecuencias
frecx = linspace(0,Fsx,size(z,2)+1);
frecy = linspace(0,Fsx,size(z,1)+1);

[f,c] = find(abs(fourier) > 0.1);

Fx = frecx(c(2:end));
Fy = frecy(f(2:end));

%% Apartado d) Fase
fase = angle(fourier(ok(2:end))) + pi/2; % Debido a que estamos trabajando con una señal sinusoidal.

%% Apartado e) Resolucion espectral en cada eje
resolucion_x = Fsx/size(z,2);
resolucion_y = Fsy/size(z,1);

%% Apartado f) Coeficientes espectrales de la transformada de Fourier

figure,surf(abs(fourier));

% Podemos observar que los coeficientes espectrales de la transformada de Fourier se encuentran
% en las diagonales y en los laterales. Podemos observar que en la coordenada (0,0) se encuentra
% la componente continua de la funcion 

%% Apartado g)

parte_real = real(fourier);
parte_imaginaria = imag(fourier);

figure, surf(parte_real);
title("Parte real de la transformada");
figure, surf(parte_imaginaria);
title("Parte imaginaria de la transformada");

figure, imagesc(parte_real), colormap gray;
title("Parte real de la transformada");
figure, imagesc(parte_imaginaria), colormap gray;
title("Parte imaginaria de la transformada");

% En estas gráficas podemos observar donde se encuentra la conjugada de
% cada valor de la transformada de Fourier, esto se puede visualizar
% correctamente observando la gráfica de la parte imaginaria, que podemos
% apreciar que se encuentran en las diagonales de la gráfica. También
% podemos observar en la parte real de la gráfica los valores que
% representan la energía de la señal (esta se encuentra en la coordenada
% (0,0)) y los valores que corresponden al centro de la transformada.
%% Apartado h)
FmaxX = Fsx/2;
FmaxY = Fsy/2;

% La maxima frecuencia ha de ser de 50 Hz, luego la señal con frecuencias igual a 12.25 Hz
% pueden ser muestreadas.
%% Apartado i)

centro = ifft(fftshift(fourier));

figure,imagesc(abs(centro)),colormap gray;