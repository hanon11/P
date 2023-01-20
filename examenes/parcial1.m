%% Francisco Chanivet Sánchez
% Declaración e inicialización de variables
Fsx = 100;
Fsy = Fsx;
%% Apartado 1
surf(z); % Así podemos observar si hay oscilación en algún punto de la gráfica
%% Apartado 2
fourier = fft2(z);
A = fourier(1,1) / (length(z(1,:))*length(z(:,1)));
%% Apartado 3
Fx = length(z(1,:))/Fsx;
Fy = length(z(:,1))/Fsy;
%% Apartado 5
Nx = length(z(1,:))
Ny = length(z(:,1))
%% Apartado 6
[ok_f,ok_c] = find(abs(fourier) > 0.01);
fourier_new = fourier(ok_f,ok_c);
%% Apartado 7
fourier = fft2(z);
figure, surf(abs(fourier)), figure, imagesc(abs(fourier)), colormap gray;