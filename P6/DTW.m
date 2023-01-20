function valor = DTW(p, t)
    n = length(p);
    m = length(t);
    dtw = zeros(n,m);
        
    dtw(:,1) = Inf; 
    dtw(1,:) = Inf; 
   
    dtw(1,1) = 0;

    for i=2:n
        for j=2:m
            dist = d_euclid(p(i),t(j));
            min1 = min(dtw(i-1,j),dtw(i,j-1));
            dtw(i,j)= dist + min(min1,dtw(i-1,j-1));
        end
    end
    valor = dtw(n,m);
end