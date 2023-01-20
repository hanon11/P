function [] = jugar(imagen, objetos, sudoku, opcion)
if opcion == 1
    fprintf("Si es la primera vez que ejecuta este código, recomendamos crear patrones\n");
    fprintf("1. Crear patrones\n2. Usar patrones ya guardados\n");
    prompt = "";
    eleccion = 0;
    while eleccion < 1 || eleccion > 2
        eleccion = input(prompt);
    end
    if eleccion == 1
    % crear matriz con (num * numPatrones) patrones
        patrones = crearPatrones(num, numPatrones);
    else
        % ALTERNATIVO: si ya tiene patrones guardados localmente en una matriz
        load('patrones.mat');
    end
end
clc
%% Mostrar imagen de sudoku para comenzar a jugar
figure, imshow(imagen);
hold on;
%% Escoger fila y columna valida
while any(sudoku(:) == 0)
    if opcion == 1 % habla
        [fila, columna, numero, color] = escogeNumHabla(sudoku, patrones);
    else %imagen
        [fila, columna, numero, color] = escogeFilaColNum(sudoku);
    end
    
    mensaje = sprintf('La fila es %d, la columna es %d y el número es %d', fila, columna, numero);
    disp(mensaje);
    fprintf("\n");
    if strcmp(color, 'green')
        fprintf('Posicion correcta para ese numero\n');
    else
        fprintf('Posicion INCORRECTA para ese numero\n');
    end
    validar = input("¿Validar? (s/n) ", 's');
    
    if validar == 's'
        %% Pintar la fila y columna seleccionada
        if ~strcmp(color, 'red') % si a pesar de saber que era incorrecto, valida, no hacemos caso 
            % y no almacenamos nada
            objeto = objetos{fila, columna};
            a = text(objeto(1)- 10,objeto(2)-3,num2str(numero));
            set(a,'FontSize',20,'Color',color);
            sudoku(fila, columna) = numero;
        else
            fprintf("Posición no válida, no se añadirá a la solución\n");
        end
    end
end
hold off;
end