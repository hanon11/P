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
% Cepstrum real
rcepstrum = real(ifft(log(abs(fft(vocal2)))));
figure, plot(rcepstrum)
[pks, indices] = findpeaks(rcepstrum);

[~,index] = sort(pks, 'descend');
pitch = 1/(indices(index(1))/Fs);