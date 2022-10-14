function [x,y] = sindiscreta(N, Fs, A, F, Fase)
    f = F/Fs;
    n = 0:N-1;
    x = n * 1/Fs;
    w = 2*pi*f; 
    y = A * sin(w*n + Fase);
end