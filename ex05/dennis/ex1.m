% structure of this file:
% 1) calculate the most robust harris points (n ~ 300)
% 2) train the ferns with randomly warped versions of our initial
%    patches
% 3) normalize the ferns
% 4) do for every image in the image sequence:
%     - classification of the extracted patches
%     - after we got a classification, e.g. all points in the
%       reference image have a correspondence, estimate a 
%       homography and then warp the reference image accordingly
%       and draw the rectangle into the current image

%% init
% clear all;
close all;
clc;

% load images
fprintf('Loading images...\n');
nr_images = 6;
seq_dir = 'imagesequence';
imgs = [];
for i=1:nr_images
    img = double(rgb2gray(imread(strcat(seq_dir, filesep, 'img',int2str(i), '.ppm'))));
    if i==1
        imgs = zeros(size(img,1), size(img,2), nr_images);
    end
    imgs(:,:,i) = img;
    
    % dbg
%     figure;
%     imagesc(imgs(:,:,i)), axis equal tight off, colormap gray;
end
clear img;

%% parameters - taken from OzuysaFERNS09
nr_robust_harris_points = 3;
patch_size = [32; 32];

nr_training_samples = 50;

% parameters for affine transformations
angle_range = [0; 2*pi];
lambda_range = [0.6; 1.5];

% fern parameters
number_ferns = 2;
depth_single_fern = 3;

% iterations
iterations = 15;
%% find most robust harris points
fprintf('Computing most robust harris points...\n');
ref_img = imgs(:,:,1);
robust_keypoints = find_most_robust_harris_points(ref_img, nr_robust_harris_points, ...
                                            angle_range, lambda_range, iterations);

% every keypoint is a single class
nr_classes = size(robust_keypoints,1);

% % dbg
% figure();
% imagesc(ref_img), axis equal tight off, colormap gray;
% hold on;
% plot(robust_keypoints(:,1), robust_keypoints(:,2), 'gx', 'MarkerSize', 10, 'LineWidth', 2);
% hold off;

%% train
fprintf('Creating ferns...\n');
fs = ferns(number_ferns, depth_single_fern, patch_size, nr_classes);

for i=1:nr_training_samples
    fprintf('Training fern with sample %d...\n', i);
    % create patches for training
    [train_patches, train_class_labels] = create_training_patches(ref_img, robust_keypoints, ...
        patch_size, angle_range, lambda_range); 
    % use them to train the ferns
    fs.train(train_patches, train_class_labels);
end

% do not forget to normalize the ferns
fs.normalize();

%% classify

%% end of story ;-)