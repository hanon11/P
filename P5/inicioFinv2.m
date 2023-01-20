function [tramasPalabra, inicio, fin] = inicioFinv2 (tramas, numTramasRuido, ventana)
    % Calculo de las magnitudes.
    M = magnitud(tramas, ventana);
    Z = tasaCrucesxCero(tramas, ventana);

    % Obtención de los umbrales del inicio
    porcentaje = 0.2;
    UmbSupEnrg = porcentaje * max(M);
    UmbInfEnrgInicio = mean(M(1:numTramasRuido)) + 2*std(M(1:numTramasRuido));
    UmbCruCeroInicio = mean(Z(1:numTramasRuido)) + 2*std(Z(1:numTramasRuido));

    % Obtención de los umbrales del final
    UmbInfEnrgFinal = mean(M(end-numTramasRuido:end)) ...
                        + 2*std(M(end-numTramasRuido:end));
    UmbCruCeroFinal = mean(Z(end-numTramasRuido:end)) ...
                        + 2*std(Z(end-numTramasRuido:end));

    % Comparación de los valores
    UmbInfEnrg = max(UmbInfEnrgInicio,UmbInfEnrgFinal);
    UmbCruCero = max(UmbCruCeroInicio,UmbCruCeroFinal);
    
    inicio = obtencionPosInicio(M,Z,numTramasRuido,UmbSupEnrg,UmbInfEnrg,UmbCruCero);
    fin = obtencionPosInicio(fliplr(M),fliplr(Z),numTramasRuido,UmbSupEnrg,UmbInfEnrg,UmbCruCero);
    fin = length(M) - fin + 1;
    tramasPalabra = tramas(:,inicio:fin);
end

function inicio = obtencionPosInicio(M, Z, numTramasRuido, UmbSupEnrg, UmbInfEnrg, UmbCruCero)    
    % Búsqueda del inicio de la palabra
    % 1º. Busqueda de ln. Primer punto que cumple la condición
    ln = find(M(numTramasRuido+1:end) > UmbSupEnrg, 1) + numTramasRuido;
    inicio = ln;

    % Primer punto hacia la izquierda de ln que cumple la condición
    le = find(M(numTramasRuido+1:ln) < UmbInfEnrg, 1, 'last' ) + numTramasRuido;

    if ~isempty(le)
        inicio = le;
    end

    % Calculamos el límite hasta donde vamos a buscar
    limite = inicio - 25;
    if limite < numTramasRuido
        limite = numTramasRuido+1;
    end
    
    % Posiciones que superan el umbral de cruces por cero
    bol = Z(limite:inicio) > UmbCruCero;
    % Posición del último
    posUltimo0 = find(bol == 0, 1,'last');

    % Si el ultimo cero está al menos 3 posiciones a la izq. desde el final
    % del vector
    if length(bol) - posUltimo0 >= 3
        inicio = inicio - (length(bol) - posUltimo0);
    end
end