function [fila, columna, numero, color] = escogeNumHabla(sudoku, patrones)

num = 9; % cuántos números se utilizan, para un sudoku 1-9
numPatrones = 2; % cuántos Patrones quiere tener de cada número

% detectar la fila, la columna y el numero para insertar
disp('Empieza a grabar el número de tu fila pulsando cualquier tecla.');
VC = grabarNumeroYCrearVector();
fila = comparar(VC, patrones, num, numPatrones);

disp('Empieza a grabar el número de tu columna pulsando cualquier tecla.');
VC = grabarNumeroYCrearVector();
columna = comparar(VC, patrones, num, numPatrones);

disp('Empieza a grabar el número que quieres insertar pulsando cualquier tecla.');
VC = grabarNumeroYCrearVector();
numero = comparar(VC, patrones, num, numPatrones);

% comprobar si es valido y preguntar si quiere continuar
if esValidoSudoku(sudoku, fila, columna, numero)
    color = 'green';
else
    color = 'red';
end

end