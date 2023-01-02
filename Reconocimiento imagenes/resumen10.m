close all;
clear all;

I = imread('vajilla9.jpg');
Igray = rgb2gray(I);
figure, imshow(Igray);

%Umbralización
figure, imhist(Igray), axis tight;

%Global con el método de Otsu
T = graythresh(Igray);
BW = im2bw(Igray,T);
figure, imshow(BW)

%Umbrales de imagen multinivel (Otsu)
%Probar esta función con trafico.jpg
T = multithresh(Igray,2);
disp (T);
seg = imquantize(Igray,T); 
C = label2rgb(seg); % colorea cada región
figure, imshow(C);
%figure, imshow(seg,[]);

%Umbral de imagen adaptable
%https://programmerclick.com/article/2315596467/
%T = adaptthresh(Igray);
%T = adaptthresh(Igray,0.5);
%Variar el tamaño de la vecindad
figure, surf(Igray);
%T = adaptthresh(Igray,0.5,'NeighborhoodSize',[11 11]);
T = adaptthresh(Igray,0.5,'NeighborhoodSize',[101 101]);
figure, surf(T);
figure, surf(im2double(Igray)-T);
BW = imbinarize(Igray,T);
figure, imshow(BW);


%Etiquetado de componentes conexas
%CC = bwconncomp(BW,8);
%L = labelmatrix(CC);
L = bwlabel(BW,8);
C = label2rgb(L); % colorea cada región
figure, imshow(C);

%Crecimiento de regiones
[IRGrow,num_reg,ISeed,IThreshold] = regiongrow(Igray,230,80);
figure, subplot(2,2,1);
imshow(Igray,[]);
title('Imagen');
subplot(2,2,2);
imshow(IRGrow,[]);
title('Img. segmentada');
subplot(2,2,3);
imshow(ISeed,[]);
title('Img. semillas');
subplot(2,2,4);
imshow(IThreshold,[]);
title('Img. umbral');

%Transformada de Hough
%Rectas
Iborde = edge(Igray,'sobel');
figure,imshow(Iborde);
[H, theta, rho] =hough(Iborde);
%Detección de 4 líneas con más puntos
peaks = houghpeaks(H,4);
lines = houghlines(Iborde, theta, rho, peaks);
figure,imshow(Igray,[]);
for k = 1:length(lines),
   xy = [lines(k).point1; lines(k).point2];
   line(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','g');
end
%Círculos
[centros, radios, metricas] = imfindcircles(Iborde,[50 100]);
viscircles(centros, radios,'EdgeColor','b');

