function esValido = esValidoSudoku(sudoku, fila, columna, numero)
    % sudoku: matriz de doubles con los valores del sudoku
    % fila y columna: posiciones en las que se va a colocar el cuarto
    % parametro
    % numero: double que se quiere colocar en la posicion [fila, columna]

    % Comprobamos si el número se repite en la misma fila
    esValido = all(sudoku(fila,:) ~= numero);
    % Si no se repite en la fila, comprobamos si se repite en la columna
    if esValido
        esValido = all(sudoku(:,columna) ~= numero);
    end
    % Si no se repite ni en la fila ni en la columna, comprobamos si se
    % repite en el cuadrante
    if esValido
        % Calculamos en qué cuadrante se encuentra la celda
        cuadranteFila = floor((fila-1) / 3) + 1;
        cuadranteColumna = floor((columna-1) / 3) + 1;
        % Extraemos el cuadrante en el que se encuentra la celda
        cuadrante = sudoku((cuadranteFila-1)*3+1:cuadranteFila*3, (cuadranteColumna-1)*3+1:cuadranteColumna*3);
        % Comprobamos si el número se repite en el cuadrante
        esValido = all(cuadrante(:) ~= numero);
    end
end