%% Realizado por Francisco Chanivet Sanchez

clear all;
close all;

% 1 - Vamos a leer los archivos que hay dentro del directorio
% matriculas que esten en formato png.

list_enun = dir("matriculas\*.png");

for i = 1:length(list_enun)
    file_name = "matriculas\"+list_enun(i).name;
    img = imread(file_name);
    img_mod = rgb2gray(img); % Pasamos la imagen a escala de grises
    umbral = graythresh(img); % Obtenemos el umbral
    img_mod = imbinarize(img_mod,umbral); %Pasamos la imagen a binaria para poder hacer regionprops para poder detectar el angulo en el que estan
    img_mod = edge(img_mod,'canny');
    
    s = regionprops(img_mod,'BoundingBox','Area','Orientation');

    if((s(1).Orientation < 89 && s(1).Orientation > 13) || s(1).Orientation < 0)
        angulo = (180 - s(1).Orientation) + 90 + 90; 
    
        img = imrotate(img,angulo); % Rotamos la imagen con el angulo obtenido

    end
    % En el caso de que este recta la imagen, se guarda tal y como esta
    file_write = "matriculas_sol\"+list_enun(i).name;
    imwrite(img,file_write); %Guardamos el archivo en el directorio matriculas_sol
end