function senalfilt = preenfasis(senal, a)
	senalfilt = filter([1-a], 1, senal);
end