function prediccion = obtenerNumero(numero)
    result = ocr(numero, 'TextLayout', 'Block');
    prediccion = result.Text;
end