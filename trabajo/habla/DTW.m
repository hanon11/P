function dtw = DTW(p, t)
    n = size(p,2)+1;
    m = size(t,2)+1;

    dtw = zeros(n, m);
    dtw(1,:) = inf;
    dtw(:,1) = inf;
    dtw(1,1) = 0;

    for i=2:n
        for j=2:m
            %dist = "distancia entre los vect. Características i y j";
            dist = d_euclid(p(:,i-1),t(:,j-1));
            dtw(i, j) = dist + min([dtw(i-1,j) dtw(i,j-1) dtw(i-1,j-1)]);
        end
    end
    dtw = dtw(end, end);
end
