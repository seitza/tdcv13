clear;

I = rgb2gray(imread('../imagesequence/img1.ppm'));

patch_size = 31;

[patches, classes] = create_patches(I, patch_size);

number_ferns = 20;
depth = 10;
number_classes = size(patches, 3);

ferns = Ferns(number_ferns, depth, number_classes, patch_size);

ferns.train(patches, classes);

