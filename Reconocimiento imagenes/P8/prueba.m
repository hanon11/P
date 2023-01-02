clear all, close all;
load templates;
% Iniciamos la webcam para detectar el rectángulo con las celdas
fuente_video = videoinput('winvideo');

% Configurar la fuente de video para que capture frames sin límite de tiempo
fuente_video.FramesPerTrigger = Inf;

% Configurar la fuente de video para que devuelva los frames en espacio de color RGB
fuente_video.ReturnedColorSpace = 'rgb';

% Establecer el intervalo de captura de frames en 5
fuente_video.FrameGrabInterval = 5;

% Establecemos el número de cuadrados que queremos encontrar
numCuadrados = 10;

% Iniciamos el bucle de adquisición de frames
start(fuente_video);
% Matriz para almacenar los objetos que cumplan con los criterios de búsqueda
objetos = zeros(numCuadrados, 7);
indexObj = 1;

encontrados = 0;

while (fuente_video.FramesAcquired <= 400 && encontrados ~= numCuadrados)
    % Obtenemos un frame de la webcam
    data = getsnapshot(fuente_video);
    objetos = zeros(numCuadrados, 7);
    encontrados = 0;
    indexObj = 1;
    % Convertimos la imagen a escala de grises y la filtramos
    umbral = graythresh(data);
    diff_im = rgb2gray(data);
    %diff_im = medfilt2(diff_im, [3 3]);
    diff_im = imbinarize(diff_im, umbral);

    % Etiquetamos los objetos en la imagen
    bw = bwlabel(diff_im, 8);

    % Obtenemos las propiedades de cada objeto
    s = regionprops(bw, 'BoundingBox', 'Centroid', 'Area');

    % Dibujamos los cuadrados en la imagen
    imshow(data);
    hold on;

    for i = 1:length(s)
        bb = s(i).BoundingBox; % Cuadrado del objeto
        bc = s(i).Centroid;
        % Si el área del objeto está dentro del rango esperado y su centroide está en la zona deseada de la imagen, lo almacenamos
        if s(i).Area > 5500 && s(i).Area < 9500 && bc(2) > 350 && bc(2) < 450
            rectangle('Position', bb, 'EdgeColor', 'r', 'LineWidth', 3);
            plot(bc(1), bc(2), 'r+');
            objetos(indexObj,:) = [bc bb s(i).Area];
            indexObj = indexObj + 1;
            encontrados = encontrados + 1;
        end

        % Si hemos encontrado todos los cuadrados, salimos del bucle
        if encontrados == numCuadrados
            imagen = data;
            break;
        end
    end
    hold off;
end

% Detenemos la adquisición de frames y liberamos la memoria
stop(fuente_video);
flushdata(fuente_video);
% Si no se han encontrado los 10 cuadrados paramos la ejecucion
if encontrados ~= numCuadrados
    return
end
%%
numeros = zeros(1,numCuadrados);
tamObjetos = size(objetos,2);
contN = 1;
i = 1;
blanco = false;

while(i <= size(objetos,1) && ~blanco)
    imagen_recortada = imcrop(imagen,objetos(i,3:tamObjetos-1));
    imagen_recortada = imagen_recortada - 50;
    umbral = graythresh(imagen_recortada);
    diff_im = rgb2gray(imagen_recortada);
    diff_im = imbinarize(diff_im,umbral);

    bw = bwlabel(diff_im,8);
    bw = bw(5:end-5,5:end-5);

    if(isempty(find(~bw,1)))
        blanco = true;
        cuadro_blanco = i;
    else

        if(isempty(find(~bw(:,round(size(bw,2)/2)),1))) % Indica que hay dos cifras
            bw1 = bw(:,1:round(size(bw,2)/2));
            bw2 = bw(:,round(size(bw,2)/2):end);
            bw1 = padarray(bw1, [15, 15], 1, 'both');
            bw2 = padarray(bw2, [15, 15], 1, 'both');
            bw1 = imresize(bw1, [53 54],'Antialiasing',true);
            bw2 = imresize(bw2, [53 54],'Antialiasing',true);
            num1 = obtenerNumero(templates, bw1);
            num2 = obtenerNumero(templates, bw2);
            numero = strcat(num1, num2);
        else
            bw = imresize(bw, [53 54],'Antialiasing',true);
            numero = obtenerNumero(templates,bw);
        end

        numeros(i) = str2double(numero);
    end
    i = i + 1;
end

% Calculamos la serie
prediccion = calcularSerie(numeros);

figure, imshow(imagen);
title("Predicción");
hold on;
for i = cuadro_blanco:length(objetos)
    a = text(objetos(i,1)- 20,objetos(i,2),string(prediccion(i)));
    set(a,'FontSize',34,'Color','black');
end

hold off;
