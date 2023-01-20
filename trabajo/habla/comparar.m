function numeroDetectado = comparar(VC, patrones, num, numPatrones)
    % dimensiones de los vectores
    filasVect = 37;
    colsVect = 120;
    numCar = 13; % número de características consideradas

    % comparar vector con patrones
    confusion = zeros(num, numPatrones); % Matriz de confusion
    for m = 1:numPatrones % repetir para cada patrón diferente del mismo número
        for n = 1:num % repetir para cada número
                
                % determinar en qué parte de la matriz se compara y 
                % establecer las últimas columnas en la última columna 
                % antes de los ceros
                inNPfila = (n-1)*filasVect + 1;
                finNPfila = (n-1)*filasVect + numCar;
                inNPcol = (m-1)*colsVect +1;
                finNPcol = find(sum(patrones(inNPfila:finNPfila, inNPcol:m*colsVect))==0, 1, 'first') + inNPcol;                  
                finVCN = find(sum(patrones(1:filasVect, 1:m*colsVect))==0, 1, 'first');
                confusion(n, m) = DTW(VC(1:numCar,1:finVCN), patrones(inNPfila:finNPfila,inNPcol:finNPcol));
        end 
    end

    % determinar el número encontrando la confusión mínima
    [minConf, Ind] = min(confusion, [], 'all'); 
    numeroDetectado = mod(Ind, 9);
    if mod(Ind, 9) == 0
        numeroDetectado = 9;
    end

    % compruebe si se ha detectado correctamente, si es erróneo, pruebe con 
    % el número con la segunda confusión más baja, y si éste también es 
    % erróneo, repita la grabación del número y compare de nuevo
    disp(numeroDetectado);
    x = input("¿Es correcto el número detectado? (s/n) ",'s');
    if x ~= "s"
        disp('Número con la segunda probabilidad más alta: ')
        confusion([numeroDetectado, numeroDetectado+9]) = Inf; 
        [minConf, Ind] = min(confusion,[],'all');
        numeroDetectado = mod(Ind, 9);
        if mod(Ind, 9) == 0
            numeroDetectado = 9;
        end
        disp(numeroDetectado);
        x = input("¿Es correcto el número detectado? (s/n) ",'s');
        if x ~= "s"
            disp('Por favor, repita su número. Empieza la grabación pulsando cualquier tecla');
            VC = grabarNumeroYCrearVector();
            numeroDetectado = comparar(VC, patrones, num, numPatrones);
        end
    end
    
end