clear all, close all, clc
Fs = 8000;
%% vocal1
load vocal02.mat

[F1,F2]=envolvente(senal,Fs);



function [F1,F2] = envolvente(trama, Fs)
    orden = 10;
    %enventanado y correlacion
    y = hamming(length(trama)).*trama;
    y = xcorr(y);
    coefs = lpc(y, 10);

    estimacion = filter([0 -coefs(2:end)],1,[trama;zeros(orden,1)]);
    error = [trama;zeros(orden,1)] - estimacion;
    G = sqrt(sumsqr(error));
    H = freqz(G, coefs, round(length(trama)/2));


    f = linspace(0, Fs, length(trama)+1);
    f = f(1:floor(length(trama)/2));

    [~, max] = findpeaks(real(H));
    F1 = f(max(1));
    F2 = f(max(2));
end