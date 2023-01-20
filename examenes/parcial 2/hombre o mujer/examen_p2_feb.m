%% Antonio L�pez
clear;
close all;

%% tratamiendo de la primera vocal
load vocal01; % data - fs
fs1 = fs;

maxv = max(abs(data));
xd = find(abs(data) > 0.15*maxv);
xd1 = xd(1);
xd2 = xd(end);
data = data(xd1+300:xd2-300); % se elimina lo sobrante quedandonos solo con la vocal

%% tratamiendo de la segunda vocal
load vocal02; % senal - fs
fs2 = fs;

maxv = max(abs(senal));
xs = find(abs(senal) > 0.15*maxv);
xs1 = xs(1);
xs2 = xs(end);
senal = senal(xs1+300:xs2-300); % se elimina lo sobrante quedandonos solo con la vocal



%%
    % se han recortado cogiendo desde los extremos de la se�al sonora y
    % +-300 para coger la parte m�s cental de la se�al de manera autom�tica


%% Calculo el pitch de cada se�al
pitch_vocal01 = calcular_pitch(data, fs1);
pitch_vocal02 = calcular_pitch(senal, fs2);

%% Identifico el g�nero de la persona segun su pitch
genero(pitch_vocal01);
genero(pitch_vocal02);
