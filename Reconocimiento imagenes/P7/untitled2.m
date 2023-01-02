clear all, close all;
I = imread('IMG_20221201_102654.jpg');
I = rgb2gray(I);
BW = im2bw(I);
threshold = 128;
background = I < threshold;

% Replace the pixels in the background regions with black pixels
image_dark = imcomplement(I);
image_dark(background) = 0;

% Display the resulting image
imshow(image_dark);
BW_filled = imfill(BW,'holes');
boundaries = bwboundaries(BW_filled);
imshow(I)
hold on;
for k=1:10
   b = boundaries{k};
   plot(b(:,2),b(:,1),'g','LineWidth',3);
end
