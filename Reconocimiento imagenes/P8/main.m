clear all, close all;
load templates;
% Establecemos el número de cuadrados que queremos encontrar
numCuadrados = 10;
fprintf("1. Escoger imagen\n2. Activar webcam\n");
prompt = "";
eleccion = 0;
while eleccion < 1 || eleccion > 2
    eleccion = input(prompt);
end
if eleccion == 1
    %% INI IMAGEN
    % Abrir el cuadro de diálogo para seleccionar un archivo
    [nombreArchivo, rutaArchivo] = uigetfile('*.jpg;*.png;*.bmp', 'Selecciona una imagen');

    % Comprobar si se ha seleccionado un archivo
    if isequal(nombreArchivo,0)
        disp('No se ha seleccionado ningún archivo');
    else
        % Cargar la imagen en una variable
        imagen = imread(fullfile(rutaArchivo, nombreArchivo));
    end
    [fil,col,numColores] = size(imagen);


    if numColores > 1
        imagen = rgb2gray(imagen);
    end
    umbral = graythresh(imagen);
    imagen = imbinarize(imagen, umbral);
    imshow(imagen)
    bw = bwlabel(imagen, 8);
    s = regionprops(bw, 'BoundingBox', 'Centroid', 'Area');
    hold on;
    objetos = zeros(numCuadrados, 7);
    indexObj = 1;
    encontrados = 0;
    for i = 1:length(s)
        bb = s(i).BoundingBox;
        bc = s(i).Centroid;
        % Si el área del objeto está dentro del rango esperado
        if s(i).Area > 4500 && s(i).Area < 6000
            rectangle('Position', bb, 'EdgeColor', 'r', 'LineWidth', 3);
            plot(bc(1), bc(2), 'r+');
            objetos(indexObj,:) = [bc bb s(i).Area];
            indexObj = indexObj + 1;
            encontrados = encontrados + 1;
        end
    end


else
    %% INI WEBCAM
    % Iniciamos la webcam para detectar el rectángulo con las celdas
    fuente_video = videoinput('winvideo');

    % Configurar la fuente de video para que capture frames sin límite de tiempo
    fuente_video.FramesPerTrigger = Inf;

    % Configurar la fuente de video para que devuelva los frames en espacio de color RGB
    fuente_video.ReturnedColorSpace = 'rgb';

    % Establecer el intervalo de captura de frames en 5
    fuente_video.FrameGrabInterval = 5;

    % Iniciamos el bucle de adquisición de frames
    start(fuente_video);

    objetos = zeros(numCuadrados, 7);
    indexObj = 1;
    encontrados = 0;

    while (encontrados ~= numCuadrados)
        objetos = zeros(numCuadrados, 7);
        encontrados = 0;
        indexObj = 1;
        % Obtenemos un frame de la webcam
        data = getsnapshot(fuente_video);

        % Convertimos la imagen a escala de grises y la filtramos
        umbral = graythresh(data);
        diff_im = rgb2gray(data);
        diff_im = imbinarize(diff_im, umbral);

        % Etiquetamos los objetos en la imagen
        bw = bwlabel(diff_im, 8);

        % Obtenemos las propiedades de cada objeto
        s = regionprops(bw, 'BoundingBox', 'Centroid', 'Area');

        % Dibujamos los cuadrados en la imagen
        imshow(data);
        hold on;

        for i = 1:length(s)
            bb = s(i).BoundingBox;
            bc = s(i).Centroid;
            if s(i).Area > 5500 && s(i).Area < 9500
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
    umbral = graythresh(data);
    imagen = rgb2gray(data);
    edges = edge(imagen, 'canny');
    [H,theta,rho] = hough(edges);
    peaks = houghpeaks(H,5);
    lines = houghlines(edges,theta,rho,peaks);
    angles = zeros(length(lines),1);
    for k = 1:length(lines)
        angles(k) = atan2(lines(k).point1(2)-lines(k).point2(2), lines(k).point1(1)-lines(k).point2(1));
    end
    angle = mean(angles);
    angle = rad2deg(angle);
    imagen = imrotate(imagen, angle+180, 'crop');
    imagen = imbinarize(imagen, umbral);
    figure, imshow(imagen);
    bw = bwlabel(imagen, 8);
    indexObj = 1;
    % Obtenemos las propiedades de cada objeto
    s = regionprops(bw, 'BoundingBox', 'Centroid', 'Area');

    % Dibujamos los cuadrados en la imagen
    hold on;

    for i = 1:length(s)
        bb = s(i).BoundingBox;
        bc = s(i).Centroid;
        if s(i).Area > 5500 && s(i).Area < 9500
            rectangle('Position', bb, 'EdgeColor', 'r', 'LineWidth', 3);
            plot(bc(1), bc(2), 'r+');
            objetos(indexObj,:) = [bc bb s(i).Area];
            indexObj = indexObj + 1;
        end
    end
    end

    numeros = zeros(1,numCuadrados);
    tamObjetos = size(objetos,2);
    contN = 1;
    i = 1;
    blanco = false;

    while(i <= size(objetos,1) && ~blanco)
        imagen_recortada = imcrop(imagen,objetos(i,3:tamObjetos-1));

        bw = bwlabel(imagen_recortada,8);
        bw = bw(5:end-5,5:end-5);

        if(isempty(find(~bw,1)))
            blanco = true;
            cuadro_blanco = i;
            % si encuentro algún tramo de color negro significa que hay numero
            % de dos cifras
        elseif (~isempty(find(~bw(:,1:round(size(bw,2)/4)),1)))
            bw1 = bw(:,1:round(size(bw,2)/2));
            bw2 = bw(:,round(size(bw,2)/2):end);
            bw1 = imresize(bw1, [53 54],'Antialiasing',true);
            bw2 = imresize(bw2, [53 54],'Antialiasing',true);
            num1 = obtenerNumero(templates,bw1);
            num2 = obtenerNumero(templates,bw2);
            numero = strcat(num1,num2);
            numeros(i) = str2double(numero);
        else
            % una sola cifra
            bw = imresize(bw, [53 54],'Antialiasing',true);
            numero = obtenerNumero(templates,bw);
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
        set(a,'FontWeight','bold','FontSize',30,'Color','blue');
    end
    hold off;
