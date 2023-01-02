%%Representación polar
imagen = imread('rectangulo.png');
imagen = double(imagen); %Ahora 1 es el valor más alto
[y,x] = find(imagen == 1);
%Centroides
cx = mean(x);
cy = mean(y);
%Lo centro
xcent = x - cx;
ycent = y - cy;
[angulos, distancias] = cart2pol(xcent,ycent);
%Los ángulos negativos corresponden a puntos del tercer y cuatro cuadrante
%Prueba este ejemplo:
%coord = [1,0;1,1;0,1;-1,1;-1,0;-1,-1;0,-1;1,-1];
%[ang, dist] = cart2pol(coord(:,1),coord(:,2));
%Pongamos todos los ángulos entre 0 y 2*pi;
negativos = find(angulos < 0);
angulos(negativos) = angulos(negativos) + 2 * pi;
[angulos2, orden] = sort (angulos);
distancias2 = distancias(orden);
figure, subplot(1,2,1), imshow(imagen), title('borde');
subplot(1,2,2), plot(angulos2, distancias2), title ('representación polar');

%%Descriptores de Fourier
 
close all
clear all
 
% Crear la figura
N = 17; %Longitud del cuadrado
x = [  0:N-2    (N-1)*ones(1,N-1)     N-1:-1:1     zeros(1,N-1)];
y = [zeros(1,N-1)    0:N-2      (N-1)*ones(1,N-1)   N-1:-1:1 ];  
figure, plot(x,y,'*');
pause(1);
 
%Transformar las posiciones en números complejos
s = x + j * y;
 
% Aplicar la transformada de Fourier para calcular los descriptores de
% Fourier
a = fft(s);
 
% Aplica el proceso inverso para obtener los puntos a partir de M puntos
M = [2 4 8 16 24 32 40 48 56 61 62];
for i=1:length(M),
  a2 = a;
  a2(min(M(i)+1,length(a2)):end) = 0;
  s2 = ifft(a2);
  x2 = real(s2);
  y2 = imag(s2);
  figure, plot(x2,y2,'*'), pause(1);
end

%% Esqueleto de una región
imEntrada=imread('herramientas2.jpg');
imNivelGris = rgb2gray(imEntrada);
figure, imshow(imNivelGris);
umbral =graythresh(imNivelGris);
I = im2bw(imNivelGris,umbral);
I2=bwmorph(I,'skel',Inf);
figure, imshow(I2)
I2=bwmorph(I,'thin',Inf);
figure, imshow(I2)

%%Momentos invariantes de Hu
ima = imread('arandela.jpg');
imgray01 = rgb2gray(ima);
imshow(imgray01);
moHu=invmoments(imgray01);
imgray02 = imrotate(imgray01,45);
figure,imshow(imgray02);
moHu = [moHu;invmoments(imgray02)];
imgray03 = padarray(imgray01,[100 100],'both');
figure,imshow(imgray03);
moHu = [moHu;invmoments(imgray03)];
imgray04 = imresize(imgray01,0.25);
figure,imshow(imgray04);
moHu = [moHu;invmoments(imgray04)]

%% Compacidad

imEnt = imread('coins.png');
imshow(imEnt,[]);
imBW = im2bw(imEnt,80/255);
figure, imshow(imBW);
ele = strel('disk',5);
imBWerosionada = imerode(imBW,ele);
figure, imshow(imBWerosionada);
stats = regionprops(imBWerosionada,'Area','Perimeter');
area = [stats.Area];
perimetro = [stats.Perimeter];
compacidad = perimetro.^2 ./area

%% Descriptores de texturas
I = [1 1 5 6 8;2 3 5 7 1;4 5 7 1 2;8 5 1 2 5];
[CM, SI] = graycomatrix(I,'G',[]);
%[CM, SI] = graycomatrix(I,'NumLevels',4,'G',[]);
%[CM, SI] = graycomatrix(I);
%[CM, SI] = graycomatrix(I/max(I(:)));
stats = graycoprops(CM)

%% Descriptores de similitud

A=rgb2gray(imread('caracteres.jpg'));
[f_imag,c_imag] = size(A);
recorte = imcrop(A);
% Calcula la correlación entre el recorte y A
cc = normxcorr2(recorte, A);
figure,surf(cc);
figure, imagesc(cc), colormap(gray);
% Obtiene el índice donde la correlación es máxima (1)
[max_cc, imax] = max(abs(cc(:)));
% Convierte el índice a coordenas y,x
[fils, cols] = ind2sub(size(cc),imax(1));
% Comprueba que la plantilla se ajusta al trozo encontrado en la imagen original
[f_rec,c_rec] = size(recorte);
comprobacion=A(fils-f_rec:fils,cols-c_rec:cols);
figure,imshow(comprobacion);