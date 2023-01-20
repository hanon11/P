%% PRINCIPAL.m
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

% Nº de tramas utilizadas para calcular los coeficientes delta y delta-delta
longVentanaDelta = 5; 
numCepstrum = 12;

% Directorio con las señales que se usan de patrones
patrones = 'GRABACION01';

numero = 'cero';

%%
% Creación del banco de filtros de Mel
bancoFiltrosMel = generarBancoFiltros(Fs,longTrama);

%%

fichero = [patrones,'\',strrep(numero,' ','')];
    
load (fichero);
eval (['senal = ', numero,';']);

% Preénfasis
senal = preenfasis(senal, a);

% Extracción de características en el dominio del tiempo
tramas = segmentacion(senal,longTrama, longDespTrama);
[tramasPalabras, inicio, fin] = inicioFinv2 (tramas, numTramasRuido,ventana);
palabra = invSegmentacion (tramas(:,inicio:fin), longDespTrama);

% figure, subplot(1,2,1), plot(senal);
% subplot(1,2,2),plot(palabra);
% 
% obj_senal = audioplayer(palabra,Fs);
% play(obj_senal);
% pause (2);

%%
%Obtención de los coeficientes cepstrales en la escala de Mel
coefMel = MFCC(tramasPalabras,bancoFiltrosMel);

%%
coefMel = liftering(coefMel, numCepstrum);

%%
deltaCoefMel = MCCDelta(coefMel,longVentanaDelta);
deltaDeltaCoefMel = MCCDelta(deltaCoefMel,longVentanaDelta);

%%
energia = logEnergia(tramasPalabras,ventana);

%%
caracteristicas = [energia;coefMel;deltaCoefMel;deltaDeltaCoefMel];

%% 
VCN = normalizacion(caracteristicas);


%%
VCN - ceroVCN(:,1:size(VCN,2))