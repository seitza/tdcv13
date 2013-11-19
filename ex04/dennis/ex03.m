clear all;
close all;
clc;

%% loading images and computing SIFT
I1 = double(rgb2gray(imread('tum_mi_1.JPG')))/256;
[frames1, descriptors1] = sift(I1);

I2 = double(rgb2gray(imread('tum_mi_2.JPG')))/256;
[frames2, descriptors2] = sift(I2);

%% compute matches between the two images
matches = siftmatch(descriptors1, descriptors2);
plotmatches(I1,I2,frames1,frames2,matches);

% get matching pixels
count_matches = size(matches,2);
pixels_img1 = zeros(3,count_matches);
pixels_img2 = zeros(3,count_matches);

% extract pixel values from frames
% every column in matches corresponds to a matching index_pair into the
% frames
for i=1:count_matches
    index_first_img = matches(1,i);
    index_snd_img = matches(2,i);
    
    pixels_img1(1:2,i) = frames1(1:2,index_first_img);
    pixels_img2(1:2,i) = frames2(1:2,index_snd_img);
end
 
% make homogenous pixels
pixels_img1(3,:) = ones(1,count_matches);
pixels_img2(3,:) = ones(1,count_matches);

% make one big picture
img_size1 = size(I1);
img_size2 = size(I2);

bigI = zeros(img_size1(1), img_size1(2) + img_size2(2));
bigI(:,1:img_size1(2)) = I1;
bigI(:,img_size1(2)+1:end) = I2;

%% compute homograpyh
s = 4;
t = 0.5;
T = 100;
N = 1000;

H = ransac(pixels_img1, pixels_img2, s, t, T, N);
% apply transform onto image
[warped_image, offset_l] = warpImg(I1,H);

figure;
imshow(I2);

figure;
imshow(warped_image);

panorama = blendImages(warped_image, I2, offset_l);
figure;
imshow(panorama);
