clc,clear all, close all
imagenes = ['matriculas01.jpg'; 'matriculas02.jpg'; 'matriculas03.jpg'; 'matriculas04.jpg';...  
    'matriculas05.jpg'; 'matriculas06.jpg'; 'matriculas07.jpg'; 'matriculas08.jpg';...
    'matriculas09.jpg'];
for i=1:size(imagenes,1)
    imagen = imread(imagenes(i,:));
    [filas, columnas, nColores] = size(imagen);
    imagen = rgb2gray(imagen);
    imagen = imadjust(imagen,[0 1]);
%     Iborde = edge(imagen,'canny');
%     [H, theta, rho] = hough(Iborde);
%     peaks = houghpeaks(H,32);
%     lines = houghlines(Iborde, theta, rho, peaks);
%     figure,imshow(imagen,[]);
%     for k = 1:length(lines)
%        xy = [lines(k).point1; lines(k).point2];
%        line(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','g');
%     end
    nCol = 2; nFil = 4;
    ancho = int32(columnas/nCol);
    alto = int32(filas /nFil);
    cont =1;
    for cols=1:nCol
        for fil=1:nFil
            m{cont} = imcrop(imagen);
            imshow(m{cont});
            cont = cont+1;
        end
    end
end



