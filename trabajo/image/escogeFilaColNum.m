function [fila, columna, numero, color] = escogeFilaColNum(sudoku)
clc
    numCuadrados = 1;
    fprintf("Fila:");
    fila = imageToNum();
    fprintf("Columna:");
    columna = imageToNum();
    fprintf("Numero:");
    numero = imageToNum();
    % Valido que se pueda colocar el numero
    while sudoku(fila, columna) ~= 0
        fprintf("CELDA YA OCUPADA\n");
        fprintf("Fila:");
        fila = imageToNum();
        fprintf("Columna:");
        columna = imageToNum();
        fprintf("Numero:");
        numero = imageToNum();
    end
    valido = esValidoSudoku(sudoku, fila, columna, numero);
    if valido
        color = 'green';
    else
        color = 'red';
    end
end