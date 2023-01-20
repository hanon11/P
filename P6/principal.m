clear all, close all

load P.mat
load R.mat

[numClasesP, numPatronesP] = size(P);
[numClasesR, numPatronesR] = size(R);

%% Parámetros
Fs = 8000;
tiempoTrama = 0.03;
tiempoDesplTrama = 0.01;
a = 0.95;
ventana = 'hamming';
numTramasRuido = 10;
longTrama = round(Fs * tiempoTrama);
longDespTrama = round (Fs * tiempoDesplTrama);
longVentanaDelta = 5; %Nº de tramas utilizadas para calcular los coeficientes delta y delta-delta
numCepstrum = 12;
bancoFiltrosMel = generarBancoFiltros(Fs,longTrama);

%% normalizacion
for fil = 1:size(P,1)
    for col =1:size(P,2)
        % Preénfasis
        senal = preenfasis(P{fil,col}, a);
        % Extracción de características en el dominio del tiempo
        tramas = segmentacion(senal,longTrama, longDespTrama);
        [tramasPalabra, inicio, fin] = inicioFinv2 (tramas, numTramasRuido, ventana);
        palabra = invSegmentacion (tramas(:,inicio:fin), longDespTrama);
    
    
        % Obtención de los coeficientes cepstrales en la escala de Mel
        coefMel = MFCC (tramasPalabra,bancoFiltrosMel);
        % Liftering
        coefMel = liftering (coefMel, numCepstrum);
    
        % Obtención de los coeficientes delta cepstrum
        deltaCoefMel = MCCDelta (coefMel,longVentanaDelta);
    
        % Obtención de los coeficientes delta-delta cepstrum
        deltaDeltaCoefMel = MCCDelta (deltaCoefMel,longVentanaDelta);
    
        % Obtención del logaritmo de la Energía de cada trama
        energia = logEnergia(tramasPalabra, ventana);
    
        % Crear vectores de características
%         caracteristicas = [energia;coefMel];  
%         caracteristicas = [energia;coefMel;deltaCoefMel];  
        caracteristicas = [energia;coefMel;deltaCoefMel;deltaDeltaCoefMel];  
        VCN= normalizacion(caracteristicas);
        P{fil,col} = VCN;
    end
end
for fil = 1:size(R,1)
    for col =1:size(R,2)
        % Preénfasis
        senal = preenfasis(R{fil,col}, a);
        % Extracción de características en el dominio del tiempo
        tramas = segmentacion(senal,longTrama, longDespTrama);
        [tramasPalabra, inicio, fin] = inicioFinv2 (tramas, numTramasRuido, ventana);
        palabra = invSegmentacion (tramas(:,inicio:fin), longDespTrama);
    
    
        % Obtención de los coeficientes cepstrales en la escala de Mel
        coefMel = MFCC (tramasPalabra,bancoFiltrosMel);
        % Liftering
        coefMel = liftering (coefMel, numCepstrum);
    
        % Obtención de los coeficientes delta cepstrum
        deltaCoefMel = MCCDelta (coefMel,longVentanaDelta);
    
        % Obtención de los coeficientes delta-delta cepstrum
        deltaDeltaCoefMel = MCCDelta (deltaCoefMel,longVentanaDelta);
    
        % Obtención del logaritmo de la Energía de cada trama
        energia = logEnergia(tramasPalabra, ventana);
    
        % Crear vectores de características
%         caracteristicas = [energia;coefMel];  
%         caracteristicas = [energia;coefMel;deltaCoefMel];  
        caracteristicas = [energia;coefMel;deltaCoefMel;deltaDeltaCoefMel];   
        VCN= normalizacion(caracteristicas);
        R{fil,col} = VCN;
    end
end

%% estimacion de R apartado a)
claseReal = zeros(size(R));
claseEst = zeros(size(R));

% la estimación será el mínimo
valoresDTW = zeros(numClasesP,numPatronesP);
for clase=1:numClasesR
    for patron=1:numPatronesR
        valoresDTW = zeros(numClasesP,numPatronesP);
        for claseP=1:numClasesP
            for patronP=1:numPatronesP
                valoresDTW(claseP,patronP) = DTW(P{claseP, patronP}, R{clase, patron});
            end
        end

        %nos quedamos con el valor minimo
        [valoresDTW, ~] = min(valoresDTW,[],2);
        [~,pred] = min(valoresDTW);
        claseEst(clase, patron) = pred-1;
    end
    claseReal(clase,:) = clase-1;
end

%% matconf
for col = 1:width(claseEst)
    mConf = confusionmat(claseReal(:,col),claseEst(:,col));
    label = {'0','1','2','3','4','5','6','7','8','9'};
    confusionchart(mConf, label);
    pause
end


