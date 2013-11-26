clear;
close all;

I = rgb2gray(imread('../imagesequence/img1.ppm'));

number_sample = 1000;
patch_size = 31;
number_ferns = 20;
depth = 10;

% find robust harris points which are a basis for computing the patches
robust_keypoints = robust_harris(I, 10, 10);

number_classes = size(robust_keypoints, 1);

% create ferns
ferns = Ferns(number_ferns, depth, number_classes, patch_size);

%% TRAINING
% compute patches for several warped image
% and train the ferns with them
for sample = 1:number_sample
    [patches, classes] = create_patches(I, robust_keypoints, patch_size);
    ferns.train(patches, classes);
end
%%
ferns.normalize();

%% TRACKING
% run over all images
for image = 2:6
    J = rgb2gray(imread(['../imagesequence/img' num2str(image) '.ppm']));
    % smooth the image with gaussian filter
    gauss = fspecial('gaussian', [5 5], 1.5);
    J = imfilter(J, gauss);
    % identify harris points and create patches
    patches = create_classify_patches(J, patch_size);
    % run over patches and classify them
    classes = zeros(1,size(patches, 3));
    for patch = 1:size(patches, 3)
        classes(patch) = ferns.classify(patches(:,:,patch));
    end
    
    % use RANSAC to test which points fit
    
end


