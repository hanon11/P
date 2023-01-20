function numero = imageToNum()
validar = 2;
numero = NaN;
while validar == 2 
    while isnan(numero) && validar == 2 
    figure
    numCuadrados = 1;
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
    encontrados = 0;
    
    while (encontrados ~= numCuadrados)
        objetos = zeros(numCuadrados, 7);
        encontrados = 0;
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
            bb = s(i).BoundingBox; % Cuadrado del objeto
            bc = s(i).Centroid;
            if s(i).Area > 26000 && s(i).Area < 30720 && bc(2) > 350 && bc(2) < 450
                rectangle('Position', bb, 'EdgeColor', 'r', 'LineWidth', 3);
                plot(bc(1), bc(2), 'r+');
                objetos(1,:) = [bc bb s(i).Area];
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
    close
    imagen_recortada = imcrop(imagen,objetos(1,3:7-1));
    [~,~,numColores] = size(imagen_recortada);
    if numColores > 1
        imagen_recortada = rgb2gray(imagen_recortada);
    end
    umbral = graythresh(imagen_recortada);
    imagen_recortada = imbinarize(imagen_recortada, umbral);
    bw = bwlabel(imagen_recortada,8);
    bw = bw(5:end-5,5:end-5);
    bw = imresize(bw, [53 54],'Antialiasing',true);
    numero = obtenerNumero(bw);
    numero = str2double(numero);
    end
    fprintf("El numero es " + numero + "\n");
    fprintf("Validar? 1. SI 2. NO\n")
    prompt = "";
    validar = input(prompt);
end
end