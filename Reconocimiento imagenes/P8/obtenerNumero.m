function prediccion = obtenerNumero(templates, numero)
    result = ocr(numero, 'TextLayout', 'Block');
    prediccion = result.Text;
end