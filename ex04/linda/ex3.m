
im1 = imread('tum_mi_1.JPG');
im1_gray = single(rgb2gray(im1));
im2 = imread('tum_mi_2.JPG');
im2_gray = single(rgb2gray(im2));

stitched_image = stiching(im1_gray, im2_gray);
imagesc(stitched_image);

