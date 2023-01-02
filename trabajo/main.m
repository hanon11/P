
% Crea una ventana de GUI
f = figure;

% Carga una imagen
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
img = imbinarize(imagen, umbral);

% Muestra la imagen en la ventana de GUI
imshow(img, 'Parent', f);

% Agrega un botón "Modo 1" al lado derecho de la ventana de GUI
btn1 = uicontrol('Style', 'pushbutton', 'String', 'Modo 1', ...
    'Position', [370 10 100 30], 'Callback', @mode_1_callback);

% Agrega un botón "Modo 2" al lado derecho de la ventana de GUI
btn2 = uicontrol('Style', 'pushbutton', 'String', 'Modo 2', ...
    'Position', [480 10 100 30], 'Callback', @mode_2_callback);

