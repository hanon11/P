function energia = logEnergia(tramas)
    energia = log(sum(abs(tramas).^2));
end

