close all;
clear all;

Igray = imread('pout.tif');

%Modificar el brillo de la imagen
inc = 10;
Igray3 = Igray + inc;
Igray4 = Igray - inc;
figure, subplot(3,1,1);imshow(Igray3);title('Más brillo');
subplot(3,1,2);imshow(Igray);title('Normal');
subplot(3,1,3);imshow(Igray4);title('Menos brillo');
inc = 2;
Igray5 = Igray * inc;
Igray6 = Igray / inc;
figure,subplot(3,1,1);imshow(Igray5);title('Más brillo');
subplot(3,1,2);imshow(Igray);title('Normal');
subplot(3,1,3);imshow(Igray6);title('Menos brillo');

%Obtener el histograma de una imagen
figure,subplot(1,3,1);imhist(Igray5),axis tight;title('Más brillo');
subplot(1,3,2);imhist(Igray),axis tight;title('Normal');
subplot(1,3,3);imhist(Igray6),axis tight;title('Menos brillo');

%Modificar el contraste
[Igray7, f_expansion] = histeq(Igray);
figure,subplot(2,2,1);imshow(Igray);title('Normal');
subplot(2,2,3);imhist(Igray),axis tight;
subplot(2,2,2);imshow(Igray7);title('Más contraste');
subplot(2,2,4);imhist(Igray7),axis tight;

figure, plot(f_expansion), title('función de expansión');

%Transparencia 37
Imin = 75;
Imax = 175;
CMIN = 0;
CMAX = 255;
gamma = 1; %Transparencia 39
Igray8=imadjust(Igray,[Imin/255,Imax/255],[CMIN/255,CMAX/255],gamma);
gamma = 0.5;
Igray9=imadjust(Igray,[Imin/255,Imax/255],[CMIN/255,CMAX/255],gamma);
gamma = 1.5;
Igray10=imadjust(Igray,[Imin/255,Imax/255],[CMIN/255,CMAX/255],gamma);
figure,subplot(1,4,1); imshow(Igray);title('Normal');
subplot(1,4,2);imshow(Igray8);title('gamma = 1');
subplot(1,4,3);imshow(Igray9);title('gamma = 0.5');
subplot(1,4,4);imshow(Igray10);title('gamma = 1.5');

I = imread('gomasSacapuntas.jpg');
Igray = rgb2gray(I);

%Obtener un perfil
figure, imshow(Igray);

%Seleccionar una parte de la imagen (una goma y analizar su perfil)
Igray2 = imcrop();
figure,imshow(Igray2);
perfil = improfile ();
figure, plot(perfil), title ('Perfil');

%Igray = imread('pout.tif');
%Filtros de reducción de ruido
J1 = imnoise(Igray,'salt & pepper',0.005);  %La degradación de la señal durante el proceso de captación o transmisión.
J2 = imnoise(Igray,'gaussian',0,0.005);     %Saturación de la carga que recibe un pixel.

h = fspecial('average',[5 5]);
%También conv2(J1,h,'same');
J1media = imfilter(J1,h);
J2media = imfilter(J2,h);
figure,subplot(2,3,1),imshow(Igray),title('Normal');
subplot(2,3,2),imshow(J1),title('Sal y pimienta');
subplot(2,3,3);imshow(J1media),title('Filtrado');
subplot(2,3,4),imshow(Igray),title('Normal');
subplot(2,3,5),imshow(J2),title('Gaussiano');
subplot(2,3,6);imshow(J2media),title('Filtrado');

h =conv2([1 4 6 4 1],[1 4 6 4 1]')/(16^2);
J1binomial = imfilter(J1,h);
J2binomial = imfilter(J2,h);
figure,subplot(2,3,1),imshow(Igray),title('Normal');
subplot(2,3,2),imshow(J1),title('Sal y pimienta');
subplot(2,3,3);imshow(J1binomial),title('Filtrado');
subplot(2,3,4),imshow(Igray),title('Normal');
subplot(2,3,5),imshow(J2),title('Gaussiano');
subplot(2,3,6);imshow(J2binomial),title('Filtrado');

h = fspecial('gaussian',[5 5]);
J1gaussian = imfilter(J1,h);
J2gaussian = imfilter(J2,h);
figure,subplot(2,3,1),imshow(Igray),title('Normal');
subplot(2,3,2),imshow(J1),title('Sal y pimienta');
subplot(2,3,3);imshow(J1gaussian),title('Filtrado');
subplot(2,3,4),imshow(Igray),title('Normal');
subplot(2,3,5),imshow(J2),title('Gaussiano');
subplot(2,3,6);imshow(J2gaussian),title('Filtrado');

J1median = medfilt2(J1,[5 5]);
J2median = medfilt2(J2,[5,5]);
figure,subplot(2,3,1),imshow(Igray),title('Normal');
subplot(2,3,2),imshow(J1),title('Sal y pimienta');
subplot(2,3,3);imshow(J1median),title('Filtrado');
subplot(2,3,4),imshow(Igray),title('Normal');
subplot(2,3,5),imshow(J2),title('Gaussiano');
subplot(2,3,6);imshow(J2median),title('Filtrado');

J1max    = ordfilt2(J1,9,ones(5,5));
J2max    = ordfilt2(J2,9,ones(5,5));
figure,subplot(2,3,1),imshow(Igray),title('Normal');
subplot(2,3,2),imshow(J1),title('Sal y pimienta');
subplot(2,3,3);imshow(J1max),title('Filtrado');
subplot(2,3,4),imshow(Igray),title('Normal');
subplot(2,3,5),imshow(J2),title('Gaussiano');
subplot(2,3,6);imshow(J2max),title('Filtrado');

J1min    = ordfilt2(J1,1,ones(5,5));
J2min    = ordfilt2(J2,1,ones(5,5));
figure,subplot(2,3,1),imshow(Igray),title('Normal');
subplot(2,3,2),imshow(J1),title('Sal y pimienta');
subplot(2,3,3);imshow(J1min),title('Filtrado');
subplot(2,3,4),imshow(Igray),title('Normal');
subplot(2,3,5),imshow(J2),title('Gaussiano');
subplot(2,3,6);imshow(J2min),title('Filtrado');

% Realzado (transparencia 77)
ganancia = 2;
h = ones(3,3)*(-1);
h(2,2) = 9 * ganancia - 1;
h = 1/9 * h;

Jrealz = imfilter(Igray,h);
figure,subplot(1,2,1);imshow(Igray),title('Normal');
subplot(1,2,2);imshow(Jrealz),title('Realzada');

%Detección de bordes
umbral = 0.2;
h = fspecial('prewitt'); %Probar con sobel
y = imfilter(Igray,h);
x = imfilter(Igray,h');
modulo = uint8(sqrt(double(x) .^2 + double(y) .^2));
Jborde = modulo > 0.2 * max(modulo(:)); 
figure,subplot(1,5,1),imshow(Igray);
subplot(1,5,2),imshow(x),title('x');
subplot(1,5,3),imshow(y),title('y');
subplot(1,5,4),imshow(modulo),title('módulo');
subplot(1,5,5),imshow(Jborde),title('borde');

h = fspecial('laplacian'); %Probar con log
Jborde = imfilter(Igray,h);
figure,subplot(1,2,1),imshow(Igray);
subplot(1,2,2),imshow(Jborde),title('borde');

Jborde = edge(Igray,'canny');
figure,subplot(1,2,1),imshow(Igray);
subplot(1,2,2),imshow(Jborde),title('borde');

%En el dominio de la frecuencia
h =fspecial('average',[5 5]);
A=fft2(Igray);
[f,c]=size(A);
H=fft2(h,f,c); %rellena con 0’s fuera de la máscara
G=A.*H;
JMedia=uint8(real(ifft2(G)));
figure, subplot(1,2,1), imshow(JMedia),title('Con FFT');
subplot(1,2,2), imshow(imfilter(Igray,h)), title ('Convolución');

