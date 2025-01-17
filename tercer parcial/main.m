clc,clear all, close all
imagenes = ['matriculas01.jpg';'matriculas02.jpg';'matriculas03.jpg';'matriculas04.jpg';...
    'matriculas05.jpg';'matriculas06.jpg';'matriculas07.jpg';'matriculas08.jpg';'matriculas09.jpg';];

A = imbinarize(rgb2gray(imread("A.jpg")));
E = imbinarize(rgb2gray(imread("E.jpg")));
I = imbinarize(rgb2gray(imread("I.jpg")));
O = imbinarize(rgb2gray(imread("O.jpg")));
U = imbinarize(rgb2gray(imread("U.jpg")));


for i=1:size(imagenes,1)
    imagen = imread(imagenes(i,:));
    [filas, columnas, nColores] = size(imagen);
    imagen = rgb2gray(imagen);
    imagen = imadjust(imagen);
    umbral = graythresh(imagen);
    imagen = imbinarize(imagen, 'adaptive', 'ForegroundPolarity','dark','Sensitivity',0.65);
    imagen = imcomplement(imagen);
    bw = bwlabel(imagen, 8);
    s = regionprops(bw, 'BoundingBox', 'Centroid', 'Area');
    max = (filas/4)*(columnas/2);
    min = (filas/4)*20;
    %figure, imshow(imagen);
    %hold on;
    indexObj = 1;
    objetos = zeros(8, 7);
    for j = 1:length(s)
        bb = s(j).BoundingBox;
        bc = s(j).Centroid;
        if s(j).Area < max && s(j).Area > min
            %rectangle('Position', bb, 'EdgeColor', 'r', 'LineWidth', 3);
            %plot(bc(1), bc(2), 'r+');
            objetos(indexObj,:) = [bc bb s(j).Area];
            indexObj = indexObj + 1;
        end
    end
    %hold off; 
    for j=1:8
        imagen_recortada = imcrop(imagen,objetos(j,3:7-1));
        imagen_recortada = imcomplement(imagen_recortada);

        figure, imshow(imagen_recortada);
        flag = obtiene_vocal(imagen_recortada, A);
        if flag
            fprintf("Tiene A\n");
        end
        flag =obtiene_vocal(imagen_recortada, E);
        if flag
            fprintf("Tiene E\n");
        end
        flag =obtiene_vocal(imagen_recortada, O);
        if flag
            fprintf("Tiene O\n");
        end
        flag =obtiene_vocal(imagen_recortada, U);
        if flag
            fprintf("Tiene U\n");
        end
        flag =obtiene_vocal(imagen_recortada, I);
        if flag
            fprintf("Tiene I\n");
        end
        pause;
        close all;
        clc;
    end
end


function vocales = obtiene_vocal(imagen, vocal)
    vocales = false;
    sol = normxcorr2(vocal, imagen);
    % Obtiene el índice donde la correlación es máxima (1)
    [max_cc, imax] = max(abs(sol(:)));
    if(max_cc > 0.8)
        % Convierte el índice a coordenas y,x
        [fils, cols] = ind2sub(size(sol),imax(1));
        comprobacion=imagen(fils-height(vocal):fils-1,cols-width(vocal):cols-1);
        h = fspecial('average', [3 3]); %crear máscara de promedio
        comprobacion = imfilter(comprobacion, h); %aplicar filtro
        cc = corr2(vocal, comprobacion);
        if cc > 0.7
            %figure, imshow(comprobacion);
            vocales = true;
        end
    end
end
