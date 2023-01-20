% funcion para grabar el audio de alguien diciendo un número y crear 37 
% vectores con una longitud máxima de 120 coeficientes.

function VC = grabarNumeroYCrearVector()

    % Parámetros 
    Fs = 8000;
    canales = 1;
    num_bits = 16;
    tiempo = 2;
    a = 0.95;
    tiempoTrama = 0.03;
    tiempoDesplTrama = 0.01;
    longTrama = round(Fs * tiempoTrama);
    longDespTrama = round (Fs * tiempoDesplTrama);
    ventana = 'hamming';
    numTramasRuido = 10;
    bancoFiltrosMel = generarBancoFiltros(Fs,longTrama);
    numCepstrum = 12;
    longVentanaDelta = 5;
    rowsVect = 37;
    colsVect = 120;

    % Grabación, se inicia pulsando cualquier tecla
    pause();
    recObj = audiorecorder (Fs, num_bits, canales);
    disp('Start speaking.');
    recordblocking(recObj, tiempo);
    disp('End of recording.');
    senal = getaudiodata(recObj);

    % Preprocesamiento
    senal = preenfasis(senal,a);
    % Segmentacion
    tramas = segmentacion (senal, longTrama, longDespTrama);
    % Deteccion inicio fin
    tramasPalabra = inicioFinv2 (tramas, numTramasRuido, ventana);

    % Extraccion de caracteristicas
    coefMel = MFCC (tramasPalabra, bancoFiltrosMel);
    coefMel = liftering (coefMel, numCepstrum);
    deltaCoefMel = MCCDelta (coefMel, longVentanaDelta);
    deltaDeltaCoefMel = MCCDelta (deltaCoefMel, longVentanaDelta);
    energia = logEnergia(tramasPalabra);

    % Crear vector de características
    VC = zeros(rowsVect, colsVect);
    C = [energia;coefMel';deltaCoefMel';deltaDeltaCoefMel'];
    if size(C,2) <= colsVect
        VC(:, 1:size(C,2)) = C;
    else
        VC = C(:,1:colsVect); % en caso de que el vector tenga más de 120 columnas
    end

end