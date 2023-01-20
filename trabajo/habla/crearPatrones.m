% función para crear una matriz (num x numPatrones) que incluye en este 
% caso 2 patrones de los números 1-9. Estos patrones son 37 vectores con 
% hasta 120 coeficientes

function patrones = crearPatrones(num, numPatrones)
    filasVect = 37;
    colsVect = 120;
    patrones = zeros(filasVect*num, colsVect*numPatrones);
    fprintf("Para crear los patrones, di los números del uno al nueve y " + ...
        "despues de nuevo del uno al nueve.\nEmpieza a grabar el número de" + ...
        " tu fila pulsando cualquier tecla.\n");
    for m = 1:numPatrones
        for i = 1:num
            patrones(1+(i-1)*filasVect:i*filasVect, 1+(m-1)*colsVect:m*colsVect) = grabarNumeroYCrearVector();
        end
    end
    save("patrones.mat", "patrones");
end