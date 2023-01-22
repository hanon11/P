clear all, close all, clc
load nombre01.mat
%%
tiempoTrama = 0.03;
tiempoDesplTrama = 0.01;
a = 0.95;
longTrama = round(Fs * tiempoTrama);
longDespTrama = round (Fs * tiempoDesplTrama);
figure, plot(senal)
%%
vocal1 = senal(1500:1500+longTrama-1);
vocal2 = senal(2700:2700+longTrama-1);
vocal1 = hamming(length(vocal1)).*vocal1;
vocal2 = hamming(length(vocal2)).*vocal2;

%% pitch
umbral = 0.3 * max(abs(vocal1));
y = sign(vocal1) .* max(0,(abs(vocal1)-umbral));
figure, plot(y)

% correlación
y = hamming(length(y)).* y;
[correlacion,intervalos] =  xcorr(y);
centro = round(length(correlacion)/2);
correlacion = correlacion(centro:end);
[pks, maximos] = findpeaks(correlacion);

[~,ord] = sort(pks, 'descend');
periodo_fundamental = (maximos(ord(1))-1)/Fs;

pitch = 1/periodo_fundamental;
if pitch > 190
    fprintf("El audio es de una mujer, pitch = " + pitch+"\n");
else
    fprintf("El audio es de un hombre, pitch = " + pitch + "\n");
end
%% Reconocimiento de las vocales
[F1, F2] = envolvente(vocal1, Fs);
fprintf("F1 = " + F1 + " " + "F2 = " + F2 + "\n");
[F1, F2] = envolvente(vocal2, Fs);
fprintf("F1 = " + F1 + " " + "F2 = " + F2 + "\n");


function [F1, F2] = envolvente(trama, Fs)
    orden = 10;
    y = hamming(length(trama)).* trama;
    [correlacion,intervalos] =  xcorr(y);
    coeficientes = lpc(correlacion,orden);

    estimacion = filter([0 -coeficientes], 1, [trama; zeros(orden, 1)]);
    error = [trama; zeros(orden, 1)] - estimacion;
    G = sqrt(sumsqr(error));
    H = freqz(G, coeficientes, round(length(trama)/2));

    f = linspace(1, Fs, length(trama)+1);
    f = f(1:floor(length(trama)/2));

    [~, max] = findpeaks(real(H));
    F1 = f(max(1));
    F2 = f(max(2));
end

