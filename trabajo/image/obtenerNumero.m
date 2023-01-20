function prediccion = obtenerNumero(numero)
% load templates.mat
%  max = -inf;
%  figure,imshow(numero);
%  
%     for i = 1:9
%         figure, imshow(templates{2,i});
%         sem = corr2(templates{2,i},numero);
%         if(sem > max)
%             max = sem;
%             v = i;
%         end
%     end
%     prediccion = num2str(v);
    result = ocr(numero, 'TextLayout', 'Block');
    prediccion = result.Text;
end