close all, clc, clear;
load templates.mat
inpict = imread('monedas2.jfif');
%lo paso a blanco y negro..
image = rgb2gray(inpict);
image = imbinarize(image);
image = imfill(imcomplement(image), 'holes');
[centers, radii] = imfindcircles(image, [20 90], 'Sensitivity', 0.9);

imshow(image); hold on;
viscircles(centers, radii, 'Color', 'b');

fprintf("Numero de monedas: " + length(radii) + "\n");
% si el ancho de un folio mide 210mm y son 720 pixeles en la imagen...
pixeles_ancho = size(image,1);
diam_monedas = zeros(size(radii));
monedas = zeros(size(radii));
total_dinero = 0;
for i=1:length(radii)
    diam_monedas(i) = ((radii(i)*210)/pixeles_ancho)*2;
    monedas(i) = prediccion(diam_monedas(i),templates, centers(i,:), inpict);
    total_dinero = total_dinero + monedas(i);
end
fprintf("Total dinero: " + total_dinero + " centimos\n");

