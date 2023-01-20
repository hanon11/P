close all
clear all
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
patrones = 'GRABACION01'; %Directorio con las señales que se usan de patrones

%% Lectura de las señales de audio de los patrones
numeros = ['cero  ';'uno   ';'dos   ';'tres  ';'cuatro';'cinco ';'seis  ';'siete ';'ocho  ';'nueve '];
% Creación del banco de filtros de Mel
bancoFiltrosMel = generarBancoFiltros(Fs,longTrama);
for i=1:size(numeros,1)
    fichero = ['.\',patrones,'\',strrep(numeros(i,:),' ','')];
    load (fichero);
    eval (['senal = ', numeros(i,:),';']);


    % Preénfasis
    senal = preenfasis(senal, a);
    % Extracción de características en el dominio del tiempo
    tramas = segmentacion(senal,longTrama, longDespTrama);
    [tramasPalabra, inicio, fin] = inicioFinv2 (tramas, numTramasRuido, ventana);
    palabra = invSegmentacion (tramas(:,inicio:fin), longDespTrama);
    figure, subplot(1,2,1), plot(senal);
    subplot(1,2,2),plot(palabra);
    obj_senal = audioplayer(palabra,Fs);
    play(obj_senal);
    pause (2);


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
    caracteristicas = [energia;coefMel;deltaCoefMel;deltaDeltaCoefMel];  
    VCN= normalizacion(caracteristicas);
    eval ([strrep(numeros(i,:),' ',''),'VCN = VCN;']);
    ficheroSal = ['.\',patrones,'\',strrep(numeros(i,:),' ',''),'VCN'];
    eval(['save (ficheroSal ,''',strrep(numeros(i,:),' ',''),'VCN'')']);
end