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
nr_robust_harris_points = 300;
patch_size = [32; 32];
nr_training_samples = 1000;

% parameters for affine transformations
angle_range = [0; 2*pi];
lambda_range = [0.6; 1.5];

% iterations
iterations = 15;
%% find most robust harris points
fprintf('Computing most robust harris points...\n');
ref_img = imgs(:,:,1);
robust_pts = find_most_robust_harris_points(ref_img, nr_robust_harris_points, ...
                                            angle_range, lambda_range, iterations);
                                        
% dbg
figure();
imagesc(ref_img), axis equal tight off, colormap gray;
hold on;
plot(robust_pts(:,1), robust_pts(:,2), 'gx', 'MarkerSize', 10, 'LineWidth', 2);
hold off;

%% train
fprintf('Creating ferns...\n');


%% classify

%% end of story ;-)