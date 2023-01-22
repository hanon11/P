clear all, close all
%% EJERCICIO 2
Nx = 200;
Ny = 200;
Fs = 100;
frecx = linspace(0,Fs,Nx+1);
frecy = linspace(0,Fs,Ny+1);
A = 1;
Fase = 0;

[x,y,z1] = sindiscreta2D(Nx, Ny, Fs, Fs, A, 15, 0, Fase);
[x,y,z2] = sindiscreta2D(Nx, Ny, Fs, Fs, A, 0, 15, Fase);
[x,y,z3] = sindiscreta2D(Nx, Ny, Fs, Fs, A, 15, 15, Fase);
z = z1+z2+z3;
figure("name", "Ejercicio 2")
subplot(2,2,1),surf(x,y,z);
subplot(2,2,2),imagesc(x,y,z), colormap gray;
tf = fft2(z);
subplot(2,2,3),surf(frecx(1:end-1),frecy(1:end-1),abs(tf));
subplot(2,2,4),imagesc(frecx(1:end-1),frecy(1:end-1),abs(tf)), colormap gray;

% ¿Dónde aparecen en la imagen los coeficientes espectrales? ¿Cómo podemos 
% mostrar en el centro los valores correspondientes a la frecuencia cero?
% aparecen en la imagen de abajo a la derecha en forma de puntos blancos.
% help fftshift:
% fftshift Shift zero-frequency component to center of spectrum.
% Luego podemos mostrarlos en el centro usando fftshift

%% EJERCICIO 3
Fx = [eps, 5, 10, 25, 50];
z = 0;
for i=1:length(Fx)
    [x,y,z1] = sindiscreta2D(Nx, Ny, Fs, Fs, 10, Fx(i), 0, Fase);
    z = z + z1;
end
figure("name", "Ejercicio 3")
subplot(2,2,1),surf(x,y,z);
subplot(2,2,2),imagesc(x,y,z), colormap gray;
tf = fft2(z);
subplot(2,2,3),surf(frecx(1:end-1),frecy(1:end-1),abs(tf));
subplot(2,2,4),imagesc(frecx(1:end-1),frecy(1:end-1),abs(tf)), colormap gray;

% ¿Dónde aparecen en la imagen los coeficientes espectrales?¿Qué ocurre a medida
% que aumenta el valor de la frecuencia?
% al igual que la anterior, pero aparecen arriba, muy pegados al borde.
% Además solo se visualizan 3 puntos, cuando en realidad son 5. Esto es
% debido a que los valores de los extremos (epsilon y 50), no llegan a ser
% captados por nuestra funcion

%% EJERCICIO 4
Nx = 200;
Ny = 200;
Fs = 100;
frecx = linspace(0,Fs,1025);
frecy = linspace(0,Fs,1025);
A = 1;
Fase = 0;

[x,y,z1] = sindiscreta2D(Nx, Ny, Fs, Fs, A, 15, 0, Fase);
[x,y,z2] = sindiscreta2D(Nx, Ny, Fs, Fs, A, 0, 15, Fase);
[x,y,z3] = sindiscreta2D(Nx, Ny, Fs, Fs, A, 15, 15, Fase);
z = z1+z2+z3;
tf4 = fft2(z, 1024, 1024);
figure("name", "Ejercicio 4")
subplot(2,2,1),surf(x,y,z);
subplot(2,2,2),imagesc(x,y,z), colormap gray;
subplot(2,2,3),surf(frecx(1:end-1),frecy(1:end-1),abs(tf4));
subplot(2,2,4),imagesc(frecx(1:end-1),frecy(1:end-1),abs(tf4)), colormap gray;

%% EJERCICIO 5
Fx = [eps, 5, 10, 25, 50];
z = 0;
for i=1:length(Fx)
    [x,y,z1] = sindiscreta2D(Nx, Ny, Fs, Fs, 10, Fx(i), 0, Fase);
    z = z + z1;
end
figure("name", "Ejercicio 5")
subplot(2,2,1),surf(x,y,z);
subplot(2,2,2),imagesc(x,y,z), colormap winter;
tf = log(1+abs(fft2(z, 1024, 1024)));
subplot(2,2,3),surf(frecx(1:end-1),frecy(1:end-1),abs(tf));
subplot(2,2,4),imagesc(frecx(1:end-1),frecy(1:end-1),abs(tf)), colormap("parula");
% el resto de datos que antes parencían 0, ahora se pueden observar por el
% hecho de haber cambiado la escala

%% EJERCICIO 6
A = 1;
Fs = 100;
Fase = 0;
Nx = 200;
Ny = 200;

[x,y,z1] = cosdiscreta2D(Nx, Ny, Fs, Fs, 1, 25, 0, Fase);
[x,y,z2] = cosdiscreta2D(Nx, Ny, Fs, Fs, 1, 5, 5, Fase);
z = z1+z2;
tf = fft2(z, 1024, 1024);
figure("name", "Ejercicio 6")
subplot(2,2,1),surf(x,y,z);
subplot(2,2,2),imagesc(x,y,z), colormap winter;
subplot(2,2,3),surf(frecx(1:end-1),frecy(1:end-1),abs(tf));
subplot(2,2,4),imagesc(frecx(1:end-1),frecy(1:end-1),abs(tf)), colormap("parula");
% ¿Qué diferencia hay con respecto a la figura anterior?¿Puedes 
% identificar a qué funciones corresponden los módulos de los coeficientes
% espectrales?
% podemos diferenciar claramente en la figura de abajo a la derecha el
% coeficiente espectral cuyo FxFy=5 (se encuentra en la diagonal con su
% simetrico conjugado) y el correspondiente a 25,0, que se encuentra en el
% borde superior de la imagen

%% EJERCICIO 7
F = fftshift(fft2(z));
figure
imagesc(abs(F));
[x_, y_] = ginput();
r = 10;
[X,Y]=meshgrid(1:size(F,2), 1:size(F,1));
for i=1:length(x_)
    okx = sqrt((X - x_(i)).^2 + (Y - y_(i)).^2) <= r;
    F(okx) = 0;
end

znew = ifft2(ifftshift(F));
figure; surf(real(znew)); colormap gray;

%% EJERCICIO 8
A = imread("seminarista.jpg");
imshow(A)
tf = fft2(A);
shiftedFFT = fftshift(tf);
figure;
imagesc(log(abs(shiftedFFT))), colormap gray;
[x_, y_] = ginput();
r = 40;
[X,Y]=meshgrid(1:size(A,2), 1:size(A,1));
for i=1:length(x_)
    okx = sqrt((X - x_(i)).^2 + (Y - y_(i)).^2) <= r;
    shiftedFFT(okx) = 0;
end

figure;
imagesc(log(abs(shiftedFFT) +1)), colormap gray;
znew = ifft2(ifftshift(shiftedFFT));
figure; imagesc(abs(znew)); colormap gray;
title("Postprocesado")

%% EJERCICIO 9
B = imread("barco.jpg");

%figure, imshow(B)
tf = fft2(B);
shiftedFFT = fftshift(tf);
%figure; imagesc(log(abs(shiftedFFT))), colormap gray;   
m = ones(size(shiftedFFT));
for radio=10:10:60
    [X,Y]=meshgrid(1:size(B,2), 1:size(B,1));
    ok = find(sqrt((X-size(B,2)/2).^2 + (Y-size(B,1)/2).^2) <= radio);
    m(ok)=0;
    figure;
    imagesc(log(abs(shiftedFFT.*m))), colormap gray;   
    znew = ifft2(ifftshift(shiftedFFT.*m));
    figure; imagesc(abs(znew)); colormap gray;
    title("Postprocesado")
end
% si anulamos las frencuencias altas, la imagen se ve mas oscura

% si invertimos la mascara: anulamos las frecuencias altas y vemos la
% imagen difuminada
m = zeros(size(shiftedFFT));
for radio=10:10:60
    [X,Y]=meshgrid(1:size(B,2), 1:size(B,1));
    ok = find(sqrt((X-size(B,2)/2).^2 + (Y-size(B,1)/2).^2) <= radio);
    m(ok)=1;
    figure;
    imagesc(log(abs(shiftedFFT.*m))), colormap gray; 
    znew = ifft2(ifftshift(shiftedFFT.*m));
    figure; imagesc(abs(znew)); colormap gray;
    title("Postprocesado")
end