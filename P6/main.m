clear all, close all

load conjuntoP.mat
load conjuntoR.mat

numClasesP = size(P,1);
numPatronesP = size(P,2);

numClasesR = size(R,1);
numPatronesR = size(R,2);

real = zeros(numClasesR,numPatronesR);
estimada = zeros(numClasesR,numPatronesR);

% Valores devueltos por el algoritmo DTW. Se deberá sacar el mínimo de cada
% fila y después el mínimo de esos resultantes para saber la clase.
valoresDTW = zeros(numClasesP,numPatronesP);

for i = 1:numClasesR
    real(i,:) = i-1;

    for j = 1:numPatronesR
        % Reiniciamos los valores DTW para el nuevo patron de R
        valoresDTW = zeros(numClasesP,numPatronesP);
        for k = 1:numClasesP
            for l = 1:numPatronesP
                valoresDTW(k,l) = DTW(P{k,l},R{i,j});
            end
        end
        % Cada columna es una clase
        valoresDTW = valoresDTW';

        % Si hay más de un elemento por clase
        if size(valoresDTW,1) > 1
            [valoresDTW, ~] = min(valoresDTW);
        end

        % Obtenemos la clase a la que pertenece
        [~, clase] = min(valoresDTW);

        % Reajuste de la clase: 1:10 -> 0:9
        clase = clase - 1;

        estimada(i,j) = clase;
    end
end

for col = 1:width(estimada)
    mConf = confusionmat(real(:,col)',estimada(:,col));
    confusionchart(mConf);
    pause
end