function signalPre = preenfasis(signal, a)
	signalPre = filter([1 -a], 1, signal);
end
