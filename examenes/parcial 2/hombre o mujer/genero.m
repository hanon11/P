function genero(pitch)
    disp('-------------------------------------------------');

    if pitch > 195
        if pitch < 210
            disp('La persona que dijo la vocal POSIBLEMENTE sea MUJER.');
        else
            disp('La persona que dijo la vocal es MUJER.');
        end
    else
        if pitch > 160
            disp('La persona que dijo la vocal POSIBLEMENTE sea HOMBRE.');
        else
            disp('La persona que dijo la vocal es HOMBRE.');
        end 
    end
    disp(['Pitch de ' num2str(pitch)]);

end