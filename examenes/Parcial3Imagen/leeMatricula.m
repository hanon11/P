%% Parcial 3 - Francisco Chanivet Sánchez
function [caracteres] = leeMatricula(fichMatricula,dirCaracteres)
    imagen = imread(fichMatricula);

    umbral = graythresh(imagen);
    imgn_mod = rgb2gray(imagen);

    imgn_mod = imbinarize(imgn_mod,umbral);
    
    % Vamos a empezar a reconocer las letras
    bw = bwlabel(imgn_mod,8);
    bw1 = bw(:,10:round(size(bw,2)/4)+40);
    bw2 = bw(:,round(size(bw,2)/4):end); 

    
   %% Detectamos las letras

   l1 = bw1(30:end-30,20:round(size(bw1,2)/2)+3);
   l1 = imresize(l1, [86 126], 'Antialiasing',true);
   l2 = bw2(30:end-30,round(size(bw1,2)/2)+3:end);
   l2 = imresize(l2, [86 126], 'Antialiasing',true);
    directorio = dirCaracteres + "/*.png";
    list = dir(directorio);
    
    max1 = -inf;
    max2 = -inf;

    for i = 1:length(list)
        name = dirCaracteres + "/" + list(i).name;
        img = imread(name);
        umbral = graythresh(img);
        img_mod = rgb2gray(img);

        img_mod = imbinarize(img_mod,umbral);
        
        img_mod = imresize(img_mod, [86 126], 'Antialiasing',true);

        comp1 = corr2(img_mod,l1);
        comp2 = corr2(img_mod,l2);
        if(comp1 > max1)
            max1 = comp1;
            i1 = strsplit(list(i).name,".");
        end

        if(comp2 > max2)
            max2 = comp2;
            i2 = strsplit(list(i).name,".");
        end
    end

    caracteres = i1{1,1} + " " + i2{1,1};
end