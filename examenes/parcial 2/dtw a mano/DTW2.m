function dtw = DTW2(p, t, n, m, w)
    w = max(w, abs(n-m));
        for i=1:n
            for j=1:m
                DTW(i, j) = Inf;
            end
        end
    DTW(1, 1) = 0;

    for i=2:n
        for j=max(1,i-w):min(m,i+w)
            %dist = "distancia entre los vect. características i y j"
            dist = dist(i, j);
            DTW(i, j) = dist + min(DTW(i-1, j), DTW(i , j-1), DTW(i-1, j-1));
        end
    end
end