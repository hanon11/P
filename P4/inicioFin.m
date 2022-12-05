function [inicio, fin]= inicioFin(tramas, numTramasRuido, ventana)
    % Calculo de las magnitudes.
    Mag = magnitud(tramas, ventana);
    CrucesCeros = tasaCrucesxCero(tramas, ventana);

    % Obtención de los umbrales del inicio
    porcentaje = 0.3; %!!!!!!!! era 0.3
    UmbSupEnrg = porcentaje * max(Mag);
    UmbInfEnrg = mean(Mag(1:numTramasRuido)) + 2*std(Mag(1:numTramasRuido));
    UmbCruCero = mean(CrucesCeros(1:numTramasRuido)) + 2*std(CrucesCeros(1:numTramasRuido));
    
    inicio = obtencionPosInicio(Mag,CrucesCeros,numTramasRuido,UmbSupEnrg,UmbInfEnrg,UmbCruCero);
    fin = obtencionPosInicio(fliplr(Mag),fliplr(CrucesCeros),numTramasRuido,UmbSupEnrg,UmbInfEnrg,UmbCruCero);
    fin = length(Mag) - fin + 1;
end

function inicio = obtencionPosInicio(Mag, CrucesCeros, numTramasRuido, UmbSupEnrg, UmbInfEnrg, UmbCruCero)    
    % Búsqueda del inicio de la palabra
    % En este punto se garantiza la presencia de señal
    ln = find(Mag(numTramasRuido+1:end) > UmbSupEnrg, 1) + numTramasRuido;
    inicio = ln;

    % Primer punto hacia la izquierda de ln que cumple la condición
    le = find(Mag(numTramasRuido+1:ln) < UmbInfEnrg, 1, 'last' ) + numTramasRuido;

    if ~isempty(le)
        inicio = le;
    end

    % Calculamos el límite hasta donde vamos a buscar
    limite = inicio - 25;
    if limite < numTramasRuido
        limite = numTramasRuido+1;
    end
    
    % Posiciones que superan el umbral de cruces por cero
    bol = CrucesCeros(limite:inicio) > UmbCruCero;
    % Posición del último
    posUltimo0 = find(bol == 0, 1,'last');

    % Si el ultimo cero está al menos 3 posiciones a la izq. desde el final
    % del vector
    if length(bol) - posUltimo0 >= 3
        inicio = inicio - (length(bol) - posUltimo0);
    end
end