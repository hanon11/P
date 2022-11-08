close all, clear all
N = 200;
Fs = 100;
A = [3 1 2 0.5];
F = [1 2 4 18];
Fase = [pi/4 0 pi/2 pi/2];

%% EJERCICIO 3
[x,y] = sindiscreta_compuesta(N,Fs,A,F,Fase);

%% EJERCICIO 4
F = fft(y);

%% EJERCICIO 5
figure
bar(abs(F));
title("Ej5 - Modulo de la transformada");
% Podemos observar 8 barras correspondientes al especto de fourier.
% Realmente son solo 4, ya que las otras 4 que se encuentran a la derecha
% del gráfico son las simétricas y conjugadas. Salen las 8 en la misma
% direccion por el hecho de haber aplicado el modulo

%% EJERCICIO 6
figure
frecuencias = linspace(0,100,N+1);
bar(frecuencias(1:end-1), abs(F));
axis([0 inf 0 inf])
title("Ej6 - Con valores de frecuencia de estudio");
% ¿Qué relación hay entre las posiciones que ocupan las barras y la señal de
% entrada?¿Es siempre así?
% coincide con los valores de las frecuencias [1 2 4 18]

% ¿Qué relación hay entre los valores de la longitud de las barras y las
% amplitudes de la señal (ver paso 3)?
% los valores de longitud de las barras coincide con las amplitudes de la
% señal multiplicado por la frecuencia de muestreo

% ¿Aparece la componente continua?
% No aparece porque es nula

% ¿Cual es el valor de la frecuencia fundamental?
% 1


%% EJERCICIO 7
yPrima = y+5;
F = fft(yPrima);
figure
bar(frecuencias(1:end-1), abs(F));
title("Ej7");

%Qué diferencia observas con respecto a la gráfica obtenida en el paso 6?¿Qué
%relación tiene con el valor que acabamos de sumar?¿Qué ha modificado en la
%señal esta suma?
% Ahora aparece una barra en el valor 0 debido a que hemos añadido
% componente continua, la suma de todos los valores. por lo tanto será más
% grande en relacion con los valores y la cantidad de estos

%% EJERCICIO 8
figure
bar(frecuencias(1:end-1), angle(F));
title("Ej8");

% ¿Qué observas?¿Son los valores que esperabas?. Si no es así, cómo podemos
% obtenerlos
% hay dos espectros: el del modulo y el del argumento. El del modulo 
% es el de los complejos. Lo que debo hacer es escoger uno del modulo y 
% buscarlo en el del argumento (y obtenemos la fase). Sin embargo no son
% los valores que esperabamos

%% EJERCICIO 9
figure
bar(frecuencias(1:end-1), real(F));
title("Ej9 - Parte real");
figure
bar(frecuencias(1:end-1), imag(F));
title("Ej9 - Parte imaginaria");
% Qué observas?¿Por qué obtenemos este resultado?
% En la parte real se muestra la componente continua. Podemos ver que para
% frecuencias 1, 4 y 18 tenemos parte real. En la parte imaginaria solo
% aparecen las frecuencias 1 y 2. Por lo tanto 4 y 18 solo tienen parte
% real (tiene sentido porque tienen frecuencia pi/2), 2 solo parte imaginaria y 1 ambas


%% EJERCICIO 10
n = length(yPrima);
yPrima(n/2)=0;
yPrima(n/2+1)=0;
F = fft(yPrima);
invF = ifft(F);
figure
plot(x,yPrima, 'r'); hold on; plot(x,invF,'b');
legend ('original','fourier');
title("Ej10");
% Compárala con la función original(paso 7). ¿Qué ha ocurrido?
% son la misma señal