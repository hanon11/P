function dtw = DTW1(p, t, n, m)
    dtw = zeros(n, m);

    for i=2:n
        dtw(i, 1) = Inf;
    end

    for j=2:m
        dtw(1, j) = Inf;
    end

    dtw(1, 1) = 0;

    for i=2:n
        for j=2:m
            %dist = "distancia entre los vect. Características i y j";
            dist = dist(i, j);
            dtw(i, j) = dist + min(dtw(i-1, j), dtw(i, j-1), dtw(i-1, j-1));
        end
    end
    dtw = dtw(n, m);
end