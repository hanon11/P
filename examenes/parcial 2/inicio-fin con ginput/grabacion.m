function senal = grabacion(t, Fs, Ch, num_bits)

    recObj = audiorecorder(Fs, num_bits, Ch);
    disp("Start speaking.")
    recordblocking(recObj, t);
    disp("End of recording.")
    
    senal = getaudiodata(recObj);

end