% Demo to find the number in a LCD or LED seven segment display.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;

%--------------------------------------------------------------------------------------------------------
%    READ IN IMAGE
grayImage = imread('Test1.jpg');

% Get the dimensions of the image.
% numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
[rows, columns, numberOfColorChannels] = size(grayImage)
if numberOfColorChannels > 1
	% It's not really gray scale like we expected - it's color.
	% Extract the red channel (so the magenta lines will be white).
	grayImage = grayImage(:, :, 1);
end

%--------------------------------------------------------------------------------------------------------
% Display the image.
hFig1 = figure;
subplot(2, 2, 1);
imshow(grayImage, []);
axis('on', 'image');
title('Original Image', 'FontSize', fontSize, 'Interpreter', 'None');
impixelinfo;
hFig1.WindowState = 'maximized'; % May not work in earlier versions of MATLAB.
drawnow;

% Binarize
mask = grayImage < 60;
% Connect nearby blobs with a closing.
mask = imclose(mask, true(9, 5));
% Display the image.
subplot(2, 2, 2);
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
subplot(2, 2, 3);
imshow(mask, []);
axis('on', 'image');
impixelinfo;

% Do ocr on it
txt = ocr(mask, 'TextLayout', 'line', 'CharacterSet', '0123456789')
% txt = ocr(grayImage, 'TextLayout', 'line', 'CharacterSet', '0123456789.')
number = str2double(txt.Text)/1000

% Report OCR's answer for the final mask over the middle image (which currently is showing the initial mask).
caption = sprintf('Final Mask.  OCR says number = %.3f', number);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

% OCR did badly.  So let's do our own OCR.  Let's try a different way,
% using masking to check presence of white or black at certain known locations in the 7 segment display.
msgboxw('So we can straighten the digits, draw a line along the right or left edge of any digit in the lower image.');
roi = drawline()
position = roi.Position
dx = position(2,1) - position(1,1);
dy = position(2,2) - position(1,2);
slope = dx / dy;

% Label the segments
[labeledImage, numDigits] = bwlabel(mask);
% Find bounding boxes.  We need to do this because the number 1 is the only digit that
% does not have the same bounding box width as the others so masking at predefined positions won't work
% with 1's and we need to detect 1's based on aspect ratio.
props = regionprops(mask, 'BoundingBox', 'Image');
allBB = vertcat(props.BoundingBox);
widths = allBB(:, 3)
heights = allBB(:, 4)
aspectRatios = widths ./ heights % Needed to detect 1's.

% Process each blob -- each segment location in the image.
number = nan(numDigits, 1);
hFigStraighten = figure('Name', 'Straightened and Masked Digits', 'NumberTitle', 'off');
hFigStraighten.WindowState = 'maximized';
for k = 1 : numDigits
	% Display the image in a new figure.
	figure(hFigStraighten);
	thisImage = props(k).Image;
	figureName = sprintf('Digit #%d, Straightening', k);
	hFigStraighten.Name = figureName;
	subplot(1, 3, 1);
	imshow(thisImage, []);
	axis('on', 'image');
	[rows, columns] = size(thisImage);
	
	% Straighten the image by shearing.
	tform = affine2d([1 0 0; -slope 1 0; 0 0 1])
	outputImage = imwarp(thisImage, tform);
	shiftx = -round(slope*(rows:-1:0));
% 	outputImage = false(size(thisImage));
% 	for row = 1 : size(outputImage, 1)
% 		x1 = shiftx(row) + 1;
% 		theLine = thisImage(row, x1:end);
% 		outputImage(row, 1 : length(theLine)) = theLine;
% 	end
	subplot(1, 3, 2);
	imshow(outputImage);
	thisImage = outputImage;
	
	% Crop it by indexing.
	[r, c] = find(thisImage);
	thisImage = thisImage(min(r):max(r), min(c):max(c));
	subplot(1, 3, 3);
	imshow(thisImage);
	
	% Draw bounding box over on the main window.
	thisBB = props(k).BoundingBox;
	figure(hFig1);
	hold on; % Don't let bounding boxes blow away image.
	rectangle('Position', thisBB, 'EdgeColor', 'r', 'LineWidth', 2);
	hold off;
	% Return back to this figure.
	figure(hFigStraighten);
	% Check if it's a 1 or some other digit.
	if aspectRatios(k) < 0.33
		% It's a 1.  1 is easy to detect because it's so narrow as compared to anything else.
		number(k) = 1;
		subplot(1, 3, 2);
		imshow(thisImage);
	else
		% It's a different digit -- not a 1.
		% Check the 7 locations to see which are lit.
		[abcdefg, decimalNumber] = GetLitSegments(thisImage, hFigStraighten);
		% Turn the pattern of lit segments into an actual number.
		number(k) = GetNumberFromSegments(decimalNumber);
	end
	message = sprintf('Digit #%d is a %d.\n', k, number(k));
	fprintf('%s\n', message);
	title(message);
	
	% Let user see results for this number and ask user if they want to continue.
	promptMessage = sprintf('%s\n\nDo you want to Continue processing,\nor Quit processing?', message);
	titleBarCaption = 'Continue?';
	buttonText = questdlg(promptMessage, titleBarCaption, 'Continue', 'Quit', 'Continue');
	if contains(buttonText, 'Quit', 'IgnoreCase', true)
		return; % or break or continue.
	end
end
txt = sprintf('%d', number);
% We know a priori that there is a decimal point between the 3rd and 4th number
% so divide the number by 1000.
number = str2double(txt)/1000 

% Give results back on main figure window.
figure(hFig1);
% Display the image.
subplot(2, 2, 4);
imshow(mask, []);
axis('on', 'image');
impixelinfo;
caption = sprintf('Final Mask.  Masking says number = %.3f', number);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

%======================================================================================================
% Function to see which segments are lit.
% Digits are labeled like this
%       a
%    f     b
%       g
%    e     c
%       d
% decimalNumber is the number converted into a decimal number that you can check.
% For example, if segments lit are 1001001
% then the decimalNumber is 73.  And if it's 73, then that means it must be a 2.
function [abcdefg, decimalNumber] = GetLitSegments(subImage, hFigStraighten)
% Initialize
abcdefg = -1 * ones(1, 7);
[imageRows, imageColumns] = size(subImage);
% Define top and bottom for each little box we're going to look into for each of the 7 segments.
pct1 = 0.125;
pct2 = 0.250;
height1 = imageRows * pct1;
height2 = imageRows * pct2;
rows(1, 1) = 1;	% a
rows(1, 2) = height1;	% a
rows(2, 1) = imageRows/4 - height2/2;	% b
rows(2, 2) = imageRows/4 + height2/2;	% b
rows(3, 1) = 3 * imageRows/4 - height2/2;	% c
rows(3, 2) = 3 * imageRows/4 + height2/2;	% c
rows(4, 1) = imageRows - height1;	% d
rows(4, 2) = imageRows;	% d
rows(5, 1) = 3 * imageRows/4 - height2/2;	% e
rows(5, 2) = 3 * imageRows/4 + height2/2;	% e
rows(6, 1) = imageRows/4 - height2/2;	% f
rows(6, 2) = imageRows/4 + height2/2;	% f
rows(7, 1) = imageRows/2 - height1/2;	% g
rows(7, 2) = imageRows/2 + height1/2;	% g
% Now define columns for where we'll look
pct1 = 0.2;
pct2 = 0.50;
width1 = imageColumns * pct1;
width2 = imageColumns * pct2;
columns(1, 1) = imageColumns/2 - width2/2;	% a
columns(1, 2) = imageColumns/2 + width2/2;	% a
columns(2, 1) = imageColumns - width1;	% b
columns(2, 2) = imageColumns;	% b
columns(3, 1) = imageColumns - width1;	% c
columns(3, 2) = imageColumns;	% c
columns(4, 1) = imageColumns/2 - width2/2;	% d
columns(4, 2) = imageColumns/2 + width2/2;	% d
columns(5, 1) = 1;	% e
columns(5, 2) = width1;	% e
columns(6, 1) = 1;	% f
columns(6, 2) = width1;	% f
columns(7, 1) = imageColumns/2 - width2/2;	% g
columns(7, 2) = imageColumns/2 + width2/2;	% g
% Need to round to integers since these will be used as indexes.
rows = round(rows);
columns = round(columns);
figure(hFigStraighten);
subplot(1, 3, 2);
imshow(subImage);
axis('on', 'image');
hold on;
% Check if each segment is lit.
for segment = 1 : 7
	row1 = rows(segment, 1);
	row2 = rows(segment, 2);
	col1 = columns(segment, 1);
	col2 = columns(segment, 2);
	thisBB = [col1, row1, col2-col1, row2-row1];
	hRect = rectangle('Position', thisBB, 'EdgeColor', 'r', 'LineWidth', 2);
	% Determine if the majority of the box is filled, meaning the segment is "lit".
	thisBox = subImage(row1 : row2, col1 : col2);
	theMode = mode(thisBox(:));
	if theMode == 1
		abcdefg(segment) = 1; % Lit.
		litOrNot = 'Lit';
	else
		abcdefg(segment) = 0; % Not lit.
		litOrNot = 'Not Lit';
	end
	xt = mean([col1, col2]);
	yt = mean([row1, row2]);
	text(xt, yt, litOrNot, 'Color', 'r', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end % Of for loop.
hold off;
str = sprintf('%d', abcdefg);
decimalNumber = bin2dec(str);
message = sprintf('%s = decimal %d.\n', str, decimalNumber);
fprintf('%s\n', message);
title(message, 'FontSize', 15);
end % Of function GetLitSegments().

%======================================================================================================
function number = GetNumberFromSegments(decimalNumber)
number = -1; % Initialize to null.
if decimalNumber == 126
	% Segments a, b, c, d, e, and f are lit. 1111110 = 126
	number = 0;
elseif decimalNumber == 48
	% Segments b and c are lit. 0110000 = 48
	number = 1;
elseif decimalNumber == 109
	% Segments a, b, d, e, and g are lit.  1101101 = 109
	number = 2;
elseif decimalNumber == 121
	% Segments a,b,c,d, and g are lit.  1111001 = 121
	number = 3;
elseif decimalNumber == 51
	% Segments b, c, f, and g are lit.  0110011 = 51
	number = 4;
elseif decimalNumber == 91
	% Segments a, c, d, f, and g are lit.  1011011 = 91
	number = 5;
elseif decimalNumber == 95
	% Segments a, c, d, e, f, and g are lit.  1011111 = 95
	number = 6;
elseif decimalNumber == 112
	% Segments a, b, and c are lit.  1110000 = 112
	number = 7;
elseif decimalNumber == 127
	% Segments a, b, c, d, e, f, and g are lit.  1111111 = 127
	number = 8;
elseif decimalNumber == 123
	% Segments a, b, c, d, f, and g are lit.  1111011 = 123.  9 style 1
	number = 9;
elseif decimalNumber == 115
	% Segments a, b, c, f, and g are lit.  1110011 = 115.  9 style 2
	number = 9;
end
end % of function GetNumberFromSegments