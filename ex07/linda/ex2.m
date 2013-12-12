clc; clear; close all;

%% load 3D points from the first image (ex1)
load('ex1_result');

% run over image sequence
for t = 1:1 %44
    It = single(rgb2gray(imread(['img_sequence/' form_digits(t,4) '.png'])));
    [ft, dt] = vl_sift(It);
    
    % debugging
    figure;
    imagesc([I0,It]), colormap gray, axis equal tight off;
    hold on;
    scatter(f0(1,:), f0(2,:), 'Xg');
    scatter(ft(1,:)+size(I0,2), ft(2,:), 'Xr');
    
    % compute matching points
    [matches, scores] = vl_ubcmatch(d0, dt);
    p0 = f0(1:2, matches(1,:));
    pt = ft(1:2, matches(2,:));
    % compute homography of inliers
    [H, inliers] = ransac(p0', pt', 4, 1000, 0.5, 50);
    
    % debugging
    figure;
    imagesc([I0,It]), colormap gray, axis equal tight off;
    hold on;
    for i = 1:50
        line([p0(1,i), pt(1, i)+size(I0,2)], [p0(2,i), pt(2, i)]);
    end
    
    % visualize inliers
    figure;
    imagesc([I0,It]), colormap gray, axis equal tight off;
    hold on;
    for i = 1:size(inliers)
        line([p0(1,inliers(i)), pt(1, inliers(i))+size(I0,2)], [p0(2,inliers(i)), pt(2, inliers(i))]);
    end
end


