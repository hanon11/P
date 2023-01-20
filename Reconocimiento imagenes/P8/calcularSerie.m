function serie = calcularSerie(vector)
    % Encontrar los índices de los elementos no nulos en el vector
    indices_no_nulos = find(vector ~= 0);
    serie = vector;
    
    % Determinar si la serie es de Fibonacci o aritmética
    es_fibonacci = vector(1) == 1 && vector(2) == 1;
    if ~es_fibonacci
        % Si la serie es aritmética, calcular la razón
        razon = abs(vector(2) - vector(1));
        if isempty(razon)
            % Si no se puede encontrar una razón, calcularla para los elementos iniciales
            razon = zeros(1, indices_no_nulos(end));
            for i = 1:indices_no_nulos(end)
                razon(i) = vector(i + 1) - vector(i);
            end
        end
    
        % Calcular la serie aritmética para los elementos restantes
        if vector(1) < vector(2)
            % Utilizar un bucle while para seguir rellenando las posiciones vacías
            i = indices_no_nulos(end) + 1;
            while i <= length(vector)
                serie(i) = serie(i-1) + razon;
                i = i + 1;
            end
        else
            % Utilizar un bucle while para seguir rellenando las posiciones vacías
            i = indices_no_nulos(end) + 1;
            while i <= length(vector)
                serie(i) = serie(i-1) - razon;
                i = i + 1;
            end
        end
    else
        % Si la serie es de Fibonacci, calcular los elementos restantes
        i = indices_no_nulos(end) + 1;
        while i <= length(vector)
            serie(i) = serie(i-1) + serie(i-2);
            i = i + 1;
        end
    end
end
