% imagen = imread('sudoku 02.png');
% imagen = rgb2gray(imagen);
% imagen = imbinarize(imagen);
% cont = 1;
num = imcrop(imagen);
num = padarray(num, [15, 15], 1, 'both');
imshow(num)
num = imresize(num, [53 54],'Antialiasing',true);
templates{3,cont} = double(num);
cont = cont+1;
for i=1:9
    templates{2,i} = double(templates{2,i});
end