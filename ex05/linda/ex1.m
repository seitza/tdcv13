clear;

I = rgb2gray(imread('../imagesequence/img1.ppm'));

% find robust harris points which are a basis for computing the patches
robust_keypoints = robust_harris(I, 10, 10);

% compute patches
patch_size = 31;
[patches, classes] = create_patches(I, robust_keypoints, patch_size);

number_ferns = 20;
depth = 10;
number_classes = size(patches, 3);

ferns = Ferns(number_ferns, depth, number_classes, patch_size);

ferns.train(patches, classes);

