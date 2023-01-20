Fs = 8000;
canales =1;
num_bits = 16;
tiempo = 3;
recObj = audiorecorder(Fs,num_bits,canales);
disp("Start speaking");
recordblocking(recObj, tiempo);
disp("End of recording");

play(recObj);
senal = getaudiodata(recObj);


N = length(senal);
n = 0:N-1;
t = 1/Fs*n;
figure, plot(t,senal);

% preenfasis
tf=abs(fft(senal));
y=senal;
A=0.95;
y_desp=filter([1 -a], 1, y);
subplot(3,1,2); plot(abs(fft(y_desp)));
ylim([0 max(tf)]);
title("Despues del filtro de preenfasis");
subplot(3,1,3);
for i=2:length(y)
    y_desp2(i)=y(i)-a*y(i-1);
end
plot(abs(fft(y_desp2)));
ylim([0 max(tf)]);
title("Despues del filtro de preenfasis");