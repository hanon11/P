clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
img = imread('Test1.jpg');
[rows, columns, numberOfColorChannels] = size(img);
if numberOfColorChannels > 1
	% It's not really gray scale like we expected - it's color.
	% Extract the red channel (so the magenta lines will be white).
	img=rgb2gray(img);
end
subplot(3, 1, 1);
imshow(img, []);
axis('on', 'image');
title('Original Image', 'FontSize', fontSize, 'Interpreter', 'None');
impixelinfo;
hFig = gcf;
hFig.WindowState = 'maximized'; % May not work in earlier versions of MATLAB.
drawnow;
mask = img < 60;
% Connect nearby blobs with a closing.
mask = imclose(mask, true(9, 5));
% Display the image.
subplot(3, 1, 2);
imshow(mask, []);
axis('on', 'image');
title('Initial Mask', 'FontSize', fontSize, 'Interpreter', 'None');
impixelinfo;
% Get rid of blobs touching border
mask = imclearborder(mask);
% Take the 7 largest blobs.
mask = bwareafilt(mask, 6);
mask = imrotate(mask, 2);
% Smooth out the numbers by blurring and thresholding.
windowSize = 15;
mask = conv2(double(mask), ones(windowSize)/windowSize^2, 'same') > 0.5;
% Display the image.
subplot(3, 1, 3);
imshow(mask, []);
axis('on', 'image');
title('Final Mask', 'FontSize', fontSize, 'Interpreter', 'None');
impixelinfo;
% Do ocr on it
txt = ocr(mask, 'TextLayout', 'line', 'CharacterSet', '0123456789')
% txt = ocr(img, 'TextLayout', 'line', 'CharacterSet', '0123456789.')
number = str2double(txt.Text)/1000
caption = sprintf('Final Mask.  %.3f', number);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');