function tramasPalabra = inicioFinv2(tramas, numTramasRuido, ventana)

    % Calculo de las magnitudes y la tasa de cruces por cero
    M = magnitud(tramas, ventana);
    Z = tasaCrucesxCero(tramas, ventana);

    Min = M(1:numTramasRuido);
    Zin = Z(1:numTramasRuido);
    Mend = M(end-numTramasRuido+1:end);
    Zend = Z(end-numTramasRuido+1:end);

    % Obtención de los umbrales
    umbSupEnrg = 0.3 * max(M);
    umbInfEnrg = max([mean(Min) + 4 * std(Min) mean(Mend) + 4 * std(Mend)]);
    umbCruCero = max([mean(Zin) + 4 * std(Zin) mean(Zend) + 4 * std(Zend)]);

    % Encontrar el inicio de la palabra
    ln = find(M(numTramasRuido+1:end) > umbSupEnrg, 1) + numTramasRuido;
    le = find(M(numTramasRuido+1:ln) < umbInfEnrg, 1, 'last') + numTramasRuido;

    inicio = le;
    repeticiones = 0;
    
    if (le-25 < numTramasRuido)
        i = numTramasRuido;
    else 
        i = le - 25;
    end

     
    for first = (le:-1:i)
        if Z(first) < umbCruCero
            inicio = le;
            repeticiones = 0;
        else
            repeticiones = repeticiones + 1;
            if repeticiones >= 3
                inicio = first;
                break
            end    
        end 
    end

    % encontrar el fin de la palabra
    fn = find(M(ln:end-numTramasRuido-1) > umbSupEnrg, 1, 'last')+ ln - 1;
    fe = fn + find(M(fn:end) < umbInfEnrg, 1, 'first') - 1;


    fin = fe;
    repeticiones = 0;

    if (fe + 25 > length(Z) - numTramasRuido)
        i = length(Z) - numTramasRuido;
    else 
        i = fe + 25;
    end
    
    for last = (fe : i)
        if Z(i) < umbCruCero
            fin = fe;
            repeticiones = 0;
        else
            repeticiones = repeticiones + 1;
            if repeticiones >= 3
                fin = i;
                break
            end    
        end 
    end

    tramasPalabra = tramas(:, inicio:fin);
end
