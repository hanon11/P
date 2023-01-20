inpict = imread('prueba.jpg');
%lo paso a blanco y negro..
I = rgb2gray(inpict);
%filtro para reducir ruido
I = medfilt2(I);
BW = imbinarize(I);
%figure, imshow(BW);

%relleno para las monedas irregulares
BW2 = imfill(BW, 'holes');
%figure, imshow(BW2);
prop = regionprops(BW2, 'Area', 'Centroid','MajorAxisLength');
%obtengo el contorno
boundaries = bwboundaries(BW2);

r =[];
figure, imshow(inpict); hold on;
for k=1:length(boundaries)
    b = boundaries{k};
    plot(b(:,2),b(:,1),'g','LineWidth',3);
    r = [r prop(k).MajorAxisLength];
end

hold off;
title('Num monedas '+ string(length(boundaries)))



