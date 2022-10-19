function [x,y] = sindiscreta_compuesta(N, Fs, A, F, Fase)
    nSenales = length(A);
    n = 0:N-1;
    y=zeros(1,N);
    x = n * 1/Fs;
    for i=1:nSenales
        f = F(i)/Fs;
        w = 2*pi*f; 
        y = y + A(i) * sin(w*n + Fase(i));
    end
end