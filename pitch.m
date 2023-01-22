%%
Fs = 100;
n= 0:500;

A1 = 5;
F1 = 2;
Fase1 = 0;
A2 = 10;
F2 = 4;
Fase2 = 0;

porcentaje_clipping = 0.6;

y = A1 * sin(2*pi*F1/Fs*n + Fase1) + A2 * sin(2*pi*F2/Fs*n + Fase2);

subplot (3,1,1);
plot(n/Fs,y);
xlabel('Función');

%%
% Center Clipping
umbral = porcentaje_clipping * max(abs(y));
y = sign(y) .* max(0,(abs(y)-umbral));

subplot (3,1,2);
plot(n/Fs,y);
xlabel('Función tras el proceso de Center Clipping');

% Correlación
ventana = hamming(length(y));
[correlacion,intervalos] = ...
    xcorr(y .* ventana');
centro = round(length(correlacion)/2);
correlacion = correlacion(centro:end);
intervalos = intervalos(centro:end);
subplot(3,1,3);
plot(intervalos/Fs,correlacion);
xlabel('Correlación');
xlim([0 max(n/Fs)]);

%%
% Cálculo del pitch

% Cálculo de los máximos usando findpeaks
[picos, maximos] = findpeaks(correlacion);

%picos_ok = find (picos > 0.1); % Elimina los máximos igual a cero
%periodo_fundamental = (maximos(picos_ok(1))-1)/Fs

[~,ord] = sort(picos);
periodo_fundamental = (maximos(ord(end))-1)/Fs


pitch = 1/periodo



Basado en AMDF:

%%
Fs = 100;
n= 0:500;

%%
A1 = 5;
F1 = 2;
Fase1 = 0;
A2 = 10;
F2 = 4;
Fase2 = 0;

y = A1 * sin(2*pi*F1/Fs*n + Fase1) + A2 * sin(2*pi*F2/Fs*n + Fase2);

subplot (2,1,1);
plot(n/Fs,y);
xlabel('Función');
xlim([0 max(n/Fs/2)])

%%
% AMDF
ventana = hamming(length(y));
y = y .* ventana';

for k=1:floor(length(y)/2)-1
    STAMDF(k) = sum(abs(y(floor(length(y)/2):length(y))- y(floor(length(y)/2)-k:length(y)-k)));
end

subplot(2,1,2);
plot(((1:length(STAMDF))-1)/Fs,STAMDF);
xlabel('AMDF');
xlim([0 max(n/Fs/2)]);

%%
% Cálculo del pitch
[picos, maximos] = findpeaks(-STAMDF);
[~,ind] = sort (picos);
periodo_fundamental = (maximos(ind(end)))/Fs
pitch = 1/periodo_fundamental