function caracteristicasNorm = normalizacion(caracteristicas)
    mu = 1/length(caracteristicas) * sum(caracteristicas);
    sigma = 1/(length(caracteristicas)-1) * sum(caracteristicas-mu).^2;
    caracteristicasNorm = (caracteristicas - mu)/ sigma;
end