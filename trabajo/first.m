clc, clear all, close all;

%% INICIO
repetir = 0;
while repetir ~= 2
    repetir = 0;
    fprintf("1. Activar webcam\n2. Escoger imagen\n");
    prompt = "";
    eleccion = 0;
    while eleccion < 1 || eleccion > 2
        eleccion = input(prompt);
    end

    %% CARGAR IMAGEN
    if eleccion == 1
        cam=webcam;
        preview(cam)
        pause(10);
        imagen=snapshot(cam);
        min = 3000;
        max = 8500;
        clear cam
        [fil,col,numColores] = size(imagen);
    else
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
        max = (fil/9)*(fil/9);
        min = max/2;
    end

    if numColores > 1
        imagen = rgb2gray(imagen);
    end
    umbral = graythresh(imagen);
    imagen = imbinarize(imagen, umbral);
    
    %% Obtenemos las propiedades de cada objeto
    imshow(imagen)
    bw = bwlabel(imagen, 8);
    s = regionprops(bw, 'BoundingBox', 'Centroid', 'Area');
    hold on;
    numCuadrados = 81;
    objetos = zeros(numCuadrados, 7);
    indexObj = 1;
    encontrados = 0;
    for i = 1:length(s)
        bb = s(i).BoundingBox; % Cuadrado del objeto
        bc = s(i).Centroid;
        % Si el área del objeto está dentro del rango esperado y su centroide está en la zona deseada de la imagen, lo almacenamos
        if s(i).Area > min && s(i).Area < max
            rectangle('Position', bb, 'EdgeColor', 'r', 'LineWidth', 3);
            plot(bc(1), bc(2), 'r+');
            objetos(indexObj,:) = [bc bb s(i).Area];
            indexObj = indexObj + 1;
            encontrados = encontrados + 1;
        end
    end
    %objetos = sortrows(objetos,[5 6]);
    hold off;
    fprintf("1. Cuadrados mal\n2. Cuadrados bien\n");
    prompt = "";
    while repetir < 1 || repetir > 2
     repetir = input(prompt);
    end
end

%% creamos matriz
sudoku = zeros(9,9);
fila = 1;
columna = 1;
tamObjetos = size(objetos,2);
cont = 1;
i = 1;
%figure
while(cont < 81)
    imagen_recortada = imcrop(imagen,objetos(cont,3:tamObjetos-1));
    %imshow(imagen_recortada)
    bw = bwlabel(imagen_recortada,8);
    bw = bw(5:end-5,5:end-5);

    if(~isempty(find(~bw,1)))
        bw = imresize(bw, [53 54],'Antialiasing',true);
        numero = obtenerNumero(bw);
        sudoku(columna, fila) = str2double(numero);
    end
    cont = cont + 1;
    columna = mod(columna,9)+1;
    if columna == 1
        fila = mod(fila,9)+1;
    end
end
disp(sudoku)