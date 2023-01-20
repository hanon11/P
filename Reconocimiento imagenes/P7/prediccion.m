function moneda = prediccion(diam, templates, centro, imagen)
    vector = templates(1,:);
    diametros = cell2mat(vector);
    diferencias = abs(diametros - diam);
    [~, posicion] = min(diferencias);
    moneda = templates{2,posicion};
    [r, g, b] = impixel(imagen, centro(1), centro(2));
    rgb = [r g b(1)];
    brown_range = [80, 60, 40];
    yellow_range = [255, 255, 150];
    resta_marron = abs(brown_range - rgb);
    resta_amarillo = abs(yellow_range - rgb);
    if resta_amarillo < resta_marron
        color = 'amarillo';
    else
        color = 'marron';
    end
    if moneda == 2 || moneda == 10
        if strcmp(color, 'marron')
            moneda = 2;
        else 
            moneda = 10;
        end
    elseif moneda == 5 || moneda == 20
        if strcmp(color, 'marron')
            moneda = 5;
        else 
            moneda = 20;
        end
    end
end