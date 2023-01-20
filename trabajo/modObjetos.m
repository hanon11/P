% funcion que modifica los objetos (cuadrados) obtenidos.
% Recibe un vector de 81 objetos con 7 caracteristicas. Devuelve una matriz
% de 9x9 para facilitar accesos a la hora de pintar el sudoku
function obj = modObjetos(objetos)
    index = 1;
    for i=1:9
        for j=1:9
            obj{j,i}=objetos(index,:);
            index = index+1;
        end
    end
end