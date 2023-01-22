g = [1 2 3 2 1];
h = g;

c = conv(g,h);
C = fft(c);

g = [g 0 0 0 0];
h = [h 0 0 0 0];
Fg = fft(g);
Fh = fft(h);
F = Fg.*Fh;

plot(ifft(F), '*r'); hold on
plot(ifft(C), 'g');