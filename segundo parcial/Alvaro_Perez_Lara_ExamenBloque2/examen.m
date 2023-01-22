clc, clear all, close all

load nombre01.mat

figure, plot(senal);

tiempoTrama = 0.03;
tiempodespl = 0.01;

lontrama =round(tiempoTrama * Fs);
desplazamiento = round(tiempodespl * Fs);

tramas = buffer(senal,lontrama, lontrama-desplazamiento, "nodelay");

% Viendo la señal tiene pinta que en esta trama hay vocal al tener mayor
% amplitud
figure, plot(tramas(:, 15));

figure, plot(tramas(:, 45));

segmento = tramas(:,18);

segmento = hamming(length(segmento)) .* segmento;

segmento2 = tramas(:, 50);
segmento2 = hamming(length(segmento2)) .* segmento2;

figure, plot(segmento);

%% Pitch

rcepstrum = real(ifft(log(abs(fft(segmento)))));

figure, plot(rcepstrum);

rcepstrum = rcepstrum(1:round(length(rcepstrum)/2));
[picos,maximos] = findpeaks(rcepstrum);
[~,ind] = sort(picos);
T = (maximos(ind(end-1))-1)/Fs;
pitch = 1/T

if pitch < 196
    disp("es hombre");
else
    disp("es mujer");
end

disp("vocal 1")
[f1,f2] = formantes(segmento, Fs);

disp("vocal2")
[f1,f2] = formantes(segmento2, Fs);


%% Formantes
function [f1,f2] = formantes(segmento, Fs)

tf = fft(segmento);

numpuntos = round(length(segmento)/2);
orden = 10;
tf = tf(1:numpuntos);

lpcoefs = lpc(segmento,orden);

senalest = filter([0 -lpcoefs(2:end)],1,[segmento; zeros(orden,1)]);
error = [segmento; zeros(orden,1)] -senalest;
G = sqrt(sum(error.^2));
H = freqz(G, lpcoefs, numpuntos);

frecuencias = linspace(1, Fs, length(segmento)+1);
frecuencias = frecuencias(1:end-1);
frecuencias = frecuencias(1:numpuntos);

[~,ind] = findpeaks(abs(H));

f1 = frecuencias(ind(1))
f2 = frecuencias(ind(2))

figure,plot(frecuencias, 20*log10(abs(H) + eps), 'r'); hold on
plot(frecuencias, 20*log10(abs(tf) + eps), 'b');hold off;

end




