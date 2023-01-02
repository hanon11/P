function [] = obtenerCuadrado(I)
    edges = edge(I,'sobel');
    
    % Aplica una transformada de Hough a los bordes detectados
    [H,theta,rho] = hough(edges);
    peaks = houghpeaks(H,4);
    lines = houghlines(edges,theta,rho,peaks);
    figure;
    imshow(I);
    hold on;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       imline(gca,xy(:,1),xy(:,2));
    end
    hold off;
end