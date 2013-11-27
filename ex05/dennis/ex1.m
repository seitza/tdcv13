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

%% parameters - taken from OzuysaFERNS09
nr_robust_harris_points = 250;
patch_size = [32; 32];
nr_training_samples = 1000;

% parameters for affine transformations

%% 