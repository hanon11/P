inpict = imread('prueba.jpg');
%lo paso a blanco y negro..
I = rgb2gray(inpict);
%filtro para reducir ruido
I = medfilt2(I);
BW = imbinarize(I);
figure, imshow(BW);

%relleno para las monedas irregulares
BW2 = imfill(BW, 'holes');
figure, imshow(BW2);
prop = regionprops(BW2, 'Area', 'Centroid');
%obtengo el contorno
boundaries = bwboundaries(BW2);


figure, imshow(inpict); hold on;
for k=1:length(boundaries)
    b = boundaries{k};
    plot(b(:,2),b(:,1),'g','LineWidth',3);
end

hold off;
title('Num monedas '+ string(length(boundaries)))
stats = regionprops(BW2, 'Area');
areas = [stats.Area];

% Train a classifier using the extracted size features
classifier = fitcecoc(areas', [1 2 5 10 20 50 100 200]);

% Predict the denominations of the coins in the image
predictions = predict(classifier, areas');

