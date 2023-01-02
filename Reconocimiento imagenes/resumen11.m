close all;
clear all;

I = imread('vajilla7.jpg');
Igray = rgb2gray(I);
figure, imshow(Igray);

%Umbralización
figure, imhist(Igray), axis tight;

T = graythresh(Igray);
BW = im2bw(Igray,T);
figure, subplot(1,5,1),imshow(BW),title('Umbralizada');

%Dilatación
ele = strel('disk',5);
BWDilatada = imdilate(BW,ele);
subplot(1,5,2),imshow(BWDilatada),title('Dilatada');
BWErosionada = imerode(BW,ele);
subplot(1,5,3),imshow(BWErosionada),title('Erosionada');

%Clausura = Dilatación + Erosión
BWClausura = imclose(BW,ele);
subplot(1,5,4),imshow(BWClausura),title('Clausura');

%Apertura = Erosión + Dilatación
BWApertura = imopen(BW,ele);
subplot(1,5,5),imshow(BWApertura),title('Apertura');

%Solución 1
figure, subplot(1,4,1),imshow(BW),title('1-Umbralizar');
subplot(1,4,2),imshow(BWClausura),title('2-Clausura');
I2 = imerode(BWClausura,ele);
subplot(1,4,3),imshow(I2),title('3-Erosión');
I3 = imerode(I2,ele);
subplot(1,4,4),imshow(I3),title('4-Erosión');

%Solución 2 (mejor)
figure, subplot(1,2,1),imshow(BW),title('1-Umbralizar');
BW2 = imfill(BW,'holes');
subplot(1,2,2),imshow(BW2),title('2-Relleno de agujeros');

% Combinación de operaciones morfológicas
figure,subplot(1,5,1),imshow(Igray),title('Imagen');
% Borde
bordes = imopen(Igray,ele) - imerode(Igray,ele);
subplot(1,5,2),imshow(bordes,[]);
title('Bordes');
% Top-Hat
imagen_resaltada = Igray - imopen(Igray,ele);
subplot(1,5,3),imshow(imagen_resaltada,[]);
title('Top-hat');
% Bottom-Hat
imagen_resaltada = imclose(Igray,ele) - Igray;
subplot(1,5,4),imshow(imagen_resaltada,[]);
title('Bottom-hat');
% Realce
imagen = Igray - (Igray - imopen(Igray,ele)) ...
    - (imclose(Igray,ele) - Igray);
subplot(1,5,5),imshow(imagen,[]);
title('Realce');

