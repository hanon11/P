close all
clear all
%% Muestreamos una función suma de tres funciones coseno 2D 
%Frecuencia de muestreo en las dimensiones x e y
Fsx = 100;
Fsy = 100;
%Número de muestras en cada dimensión
Nx = 200;
Ny = 200;

[x,y,z1] =  cosdiscreta2D(Nx,Ny, Fsx, Fsy, 2.5, 5, 0, 0);
[x,y,z2] =  cosdiscreta2D(Nx,Ny, Fsx, Fsy, 5, 0, 20.5, pi/4);
[x,y,z3] =  cosdiscreta2D(Nx,Ny, Fsx, Fsy, 6, 40.5, 80, pi/2);
z = z1+z2+z3;
z = z + 3.5;


%Visualizamos en 3D

figure,surf(x,y,z);

%Visualizamos en 2D
figure, imagesc(x,y,z); colormap gray;
%% Calculamos los parámetros de amplitud, frecuencia y fase de las funciones coseno a partir de la señal muestreada
F = fft2(z);

%Cálculo de los valores del dominio del espectro de Fourier
frecuenciasx = linspace(0,Fsx,Nx+1);
frecuenciasy = linspace(0,Fsy,Ny+1);
frecuenciasx = frecuenciasx(1:end-1);
frecuenciasy = frecuenciasy(1:end-1);

% Representamos en 3D el espectro de Fourier
figure,surf(frecuenciasx,frecuenciasy,abs(F));

% Representamos en 2D el espectro de Fourier
%figure,imagesc(frecuenciasx,frecuenciasy,abs(F)); colormap gray;
figure,imagesc(frecuenciasx,frecuenciasy,log(1+abs(F))); colormap gray;

% Representación 3D del espectro de Fourier (centrado)
Fcent = fftshift(F);
figure,surf(abs(Fcent));

% Representamos en 2D el espectro de Fourier (centrado)
%figure,imagesc(abs(Fcent)), colormap gray;
figure,imagesc(log(1+abs(Fcent))), colormap gray;


%Localizamos los coeficientes espectales con valores no nulos
limite = 0.1;
[f,c] = find(abs(F) > limite);

%Componente continua
CC = F(1,1)/prod(size(z));

%Amplitudes
Amplitudes = [];
for i=2:length(f), %Si CC = 0, i = 1
    Amplitudes = [Amplitudes, abs(F(f(i),c(i)))/(prod(size(z))/2)];
end

% Fases
Fases = [];
for i=2:length(f), %Si CC = 0, i = 1
    Fases = [Fases, angle(F(f(i),c(i)))];
end

%Frecuencias
Frecuenciasx = [];
Frecuenciasy = [];
for i=2:length(f), %Si CC = 0, i = 1
    Frecuenciasx = [Frecuenciasx, frecuenciasx(c(i))];
    Frecuenciasy = [Frecuenciasy, frecuenciasy(f(i))];    
end

CC
[Amplitudes;Frecuenciasx;Frecuenciasy;Fases]
