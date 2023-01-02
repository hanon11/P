close all
clear all
clc

figure;
cam = webcam(1);
% Capturar una imagen de la cámara web
img = snapshot(cam);
% Ajustar el tamaño de la imagen y convertirla a escala de grises
img = imresize(img, [500 NaN]); % Ajustar el tamaño a 500 píxeles de alto
img = rgb2gray(img); % Convertir a escala de grises
imshow(img);
% Detectar y leer el texto de la imagen
results = ocr(img);
number = results.Text;
% Cerrar la cámara web y mostrar el resultado
clear cam;
disp(['El número detectado es: ' number]);

