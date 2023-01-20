function prediccion = obtenerNumero(templates, numero)
    max = -inf;
    nums = length(templates);
    for i = 1:nums
        sem = corr2(templates{1,i},numero);
        if(sem > max)
            max = sem;
            v = i;
        end
    end
    prediccion = num2str(v-1);
%     result = ocr(numero, 'TextLayout', 'Block');
%     prediccion = result.Text;
end