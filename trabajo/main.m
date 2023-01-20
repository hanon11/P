clc, clear all, close all;

%% INICIO
repetir_cuadrados = 'n';
repetir = 'n';
% repetir mientras no haga bien el traslado de imagen a matriz
while repetir  ~= 's'
    repetir = 'n';
    repetir_cuadrados = 'n';
    % repetir si no detecta bien los 81 cuadrados
    while repetir_cuadrados ~= 's'
        clc
        repetir_cuadrados = 'n';
        fprintf("1. Activar webcam\n2. Escoger imagen\n");
        prompt = "";
        eleccion = 0;
        while eleccion < 1 || eleccion > 2
            eleccion = input(prompt);
        end
    
        %% ACTIVAR WEBCAM PARA OBTENER SUDOKU
        if eleccion == 1
            cam=webcam;
            preview(cam)
            pause(10);
            imagen=snapshot(cam);
            min = 2500;
            max = 6500;
            clear cam
            [fil,col,numColores] = size(imagen);
            % Si la imagen está a color la pasamos a blanco y negro
            if numColores > 1
                imagen = rgb2gray(imagen);
            end
            imagen = imadjust(imagen,[0 1]);
            umbral = graythresh(imagen);
            imagen = imbinarize(imagen, 'adaptive', 'ForegroundPolarity','dark','Sensitivity',0.4);
        %% OBTENER SUDOKU A TRAVÉS DE UNA IMAGEN EXISTENTE EN EL PC
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
            % Si la imagen está a color la pasamos a blanco y negro
            if numColores > 1
                imagen = rgb2gray(imagen);
            end
            imagen = imadjust(imagen);
            umbral = graythresh(imagen);
            imagen = imbinarize(imagen,umbral);
          end
        
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
        hold off;
        repetir_cuadrados = input("Cuadrados bien (s/n) ", 's');
        
    end
    %% creamos matriz
    sudoku = zeros(9,9);
    fila = 1;
    columna = 1;
    tamObjetos = size(objetos,2);
    cont = 1;
    i = 1;
    %figure
    while(cont <= 81)
        % recortamos la imagen del tamaño del cuadrado
        imagen_recortada = imcrop(imagen,objetos(cont,3:tamObjetos-1));
        %imshow(imagen_recortada)
        bw = bwlabel(imagen_recortada,8);
        bw = bw(5:end-5,5:end-5);
    
        % si no es un cuadrado vacío, obtenemos el número correspondiente y lo
        % almacenamos en la matriz 
        if(~isempty(find(~bw,1)))
            bw = imresize(bw, [53 54],'Antialiasing',true);
            numero = obtenerNumero(bw);
            sudoku(columna, fila) = str2double(numero);
        end
        cont = cont + 1;
    
        % esto para ir avanzando en el sudoku de izq y arriba a derecha abajo
        % sin pasarnos de los límites de la matriz
        columna = mod(columna,9)+1;
        if columna == 1
            fila = mod(fila,9)+1;
        end
    end
    disp(sudoku)
    repetir = input("Números bien (s/n) ", 's');
end
obj = modObjetos(objetos);
close
%%
opcion = 0;
fprintf("1. Escoger filas, columnas y números mediante habla\n2. Escoger filas, columnas y números mediante imágenes\n");
prompt = "";
opcion = input(prompt);
while opcion < 1 || opcion > 2
    fprintf("1. Escoger filas, columnas y números mediante habla\n2. Escoger filas, columnas y números mediante imágenes\n");
    opcion = input(prompt);
end
jugar(imagen, obj, sudoku, opcion);