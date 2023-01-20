function coefMel = liftering(coefMel, numCepstrum)
    coefMel = coefMel(:, 3:2 + numCepstrum);
end

