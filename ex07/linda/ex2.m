clc; clear; close all;

%% load 3D points from the first image (ex1)
load('ex1_result');

% setup sift path
if exist('vl_version') == 0
    disp('loading sift implementation...');
    run('/Users/Linda/Documents/MATLAB/vlfeat-0.9.17/toolbox/vl_setup.m');
end

correspondences = cell(1, 44);
% run over image sequence
for t = 1:44 %44
    It = single(rgb2gray(imread(num2str(t,'img_sequence/%04d.png'))))./255;
    [ft, dt] = vl_sift(It);

    % compute matching points
    [matches, scores] = vl_ubcmatch(d0_rect, dt);
    p0 = f0_rect(1:2, matches(1,:));
    pt = ft(1:2, matches(2,:));
    
    % compute homography of inliers
%     [H, inliers] = ransac(p0', pt', 4, 2000, 8, 75);

    [tform, inliers_t0, inliers_ti] = estimateGeometricTransform(...
        p0', ...
        pt', 'affine', ...
        'MaxNumTrials', 2000, ...
        'MaxDistance', 8);

    %visualize inliers
    h = figure;
    imagesc([I0,It]), colormap gray, axis equal tight off;
    hold on;
    for i = 1:size(inliers_t0, 1)
        line([inliers_t0(i,1), inliers_ti(i,1)+size(I0,2)], [inliers_t0(i,2), inliers_ti(i,2)]);
    end
    saveas(h, num2str(t, 'img_sequence/%04d_correspondences'), 'png');


    correspondences{1,t} = [inliers_t0, inliers_ti];
end

save('ex2_results');




