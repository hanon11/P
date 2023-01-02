clear all, close all
coins = rgb2gray(imread('IMG_20221201_102648.jpg'));
coins = imrotate(coins, 90,"bilinear");
imshow(coins);