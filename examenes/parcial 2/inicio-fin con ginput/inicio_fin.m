function segmentos = inicio_fin(segmentos, num_segmentos_ruido)
    M = magnitud(segmentos, 'hamming');
    Z = cruces_por_cero(segmentos, 'hamming');
   
    Ms = M(1:num_segmentos_ruido);
    medMs = mean(Ms);
    desvMs = std(Ms);

    Zs = Z(1:num_segmentos_ruido);
    medZs = mean(Zs);
    desvZs = std(Zs);

    UmbralSuperiorEnergia = 0.5 * max(M);
    UmbralInferiorEnergia = medMs + 2 * desvMs;
    UmbralCruces = medZs + 2 * desvZs;

    
    %--------- INICIO----------
    
    Ln = find(M(num_segmentos_ruido+1:end)>UmbralSuperiorEnergia);
    Ln = Ln(1)+num_segmentos_ruido+1;

    Le=find(M(1:Ln)<UmbralInferiorEnergia);
    Le=Le(end);

    inicio=Le;
    repeticiones=0;
    
    if Le > 25
        first=Le-25;
    else
        first=1;
    end
     
    for i=flip(first : Le)
        if i==num_segmentos_ruido+1
            inicio=num_segmentos_ruido+1;
            break
        end

        if Z(i)<UmbralCruces
            inicio=Le;
            repeticiones=0;
        else
            repeticiones=repeticiones+1;
            if repeticiones>=3
                inicio=i;
                break
            end    
        end 
    end
    
    
    %------FIN-------
    
    Ln=find(M(1:end-num_segmentos_ruido-1)>UmbralSuperiorEnergia);
    Ln=Ln(end);

    Le=find(M(Ln:end)<UmbralInferiorEnergia);
    Le=Le(1)+Ln;

    fin=Le;
    repeticiones=0;
    
    %for i=(Le : Le+25)
    for i=(Le : Le+9)
        if i==numel(segmentos)-num_segmentos_ruido-1
            fin=numel(segmentos)-num_segmentos_ruido-1;
            break
        end
        
        if Z(i)<UmbralCruces
            fin=Le;
            repeticiones=0;
        else
            repeticiones=repeticiones+1;
            if repeticiones>=3
                fin=i;
                break
            end    
        end 
    end
    
    inicio
    fin
    segmentos=segmentos(:,inicio:fin);
end