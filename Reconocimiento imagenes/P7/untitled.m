inpict = imread('IMG_20221201_102844.jpg');
figure, imshow(inpict);
hsvpict = rgb2hsv(inpict); % convert to hsv
mask = hsvpict(:,:,2) <= 0.1; % look for low-saturation regions
mask = bwareafilt(mask,1); % pick the largest object (the background)
outpict = inpict;
outpict(mask(:,:,[1 1 1])) = 0; % fill background with black
outpict = rgb2gray(outpict);
figure,imshow(outpict)

BW_filled = imfill(outpict,'holes');
boundaries = bwboundaries(BW_filled);
figure,imshow(inpict);
for k=1:10
    b = boundaries{k};
    plot(b(:,2),b(:,1),'g','LineWidth',3);
end