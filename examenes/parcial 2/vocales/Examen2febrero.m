clear all
close all
clc
%%
% VOCAL 1

%Recogemos la primera vocal
senal = load("vocal01.mat");

Fs = senal.fs;
senal = senal.data;

%sin automatizar
% figure, plot(senal);
% [x,y] = ginput(2);
% x = round(x);
% senal = senal(x(1):x(2));

%automatizado
figure, plot(senal);
x=1750;
y=3000;
senal = senal(x:y);

% Calculamos  pitch con AMDF
ventana = hamming(length(senal));

for k=1:floor(length(senal)/2)-1
STAMDF(k) = sum(abs(senal(floor(length(senal)/2):length(senal)).*ventana(floor(length(senal)/2):length(senal)) - senal(floor(length(senal)/2)-k:length(senal)-k).*ventana(floor(length(senal)/2)-k:length(senal)-k)));
end

figure, plot(((1:floor(length(senal)/2)-1)-1)/Fs,STAMDF);

% Calculo del pitch
[~,indices] = sort(STAMDF);
periodo_fundamental = indices(2)/Fs;
F1 = indices(3);
pitch1 = 1/periodo_fundamental

%%
% VOCAL 2
clear all

%Recogemos la segunda vocal
senal = load("vocal02.mat");

Fs = senal.fs;
senal = senal.senal;

%sin automatizar
% figure, plot(senal);
% [x,y] = ginput(2);
% x = round(x);
% senal = senal(x(1):x(2));

%automatizado
figure, plot(senal);
x=3200;
y=4000;
senal = senal(x:y);

% Calculamos de nuevo pitch con AMDF
ventana = hamming(length(senal));

for k=1:floor(length(senal)/2)-1
STAMDF(k) = sum(abs(senal(floor(length(senal)/2):length(senal)).*ventana(floor(length(senal)/2):length(senal)) - senal(floor(length(senal)/2)-k:length(senal)-k).*ventana(floor(length(senal)/2)-k:length(senal)-k)));
end

figure, plot(((1:floor(length(senal)/2)-1)-1)/Fs,STAMDF);

% Calculo del pitch
[~,indices] = sort(STAMDF);
periodo_fundamental = indices(2)/Fs;
pitch2 = 1/periodo_fundamental

