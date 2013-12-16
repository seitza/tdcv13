clc; clear; close all;

%% load 3D points from the first image (ex1)
load('ex1_result');

correspondences = cell(1, 44);
% run over image sequence
for t = 1:44 %44
    It = single(rgb2gray(imread(num2str(t,'img_sequence/%04d.png'))));
    [ft, dt] = vl_sift(It);
    
    % debugging
%     figure;
%     imagesc([I0,It]), colormap gray, axis equal tight off;
%     hold on;
%     scatter(f0(1,:), f0(2,:), 'Xg');
%     scatter(ft(1,:)+size(I0,2), ft(2,:), 'Xr');
    
    % compute matching points
    [matches, scores] = vl_ubcmatch(d0, dt);
    p0 = f0(1:2, matches(1,:));
    pt = ft(1:2, matches(2,:));
    % compute homography of inliers
    [H, inliers] = ransac(p0', pt', 4, 500, 2.5, 75);
%     gte = vision.GeometricTransformEstimator;
%     [tform, inlierIdx] = step(gte, p0', pt');
%     figure; imagesc([I0,It]), colormap gray, axis equal tight off;
%     hold on;
%     [in, col]= find(inlierIdx);
%     for i = 1:size(in)
%         line([p0(1,in(i)), pt(1, in(i))+size(I0,2)], [p0(2,in(i)), pt(2, in(i))]);
%     end
%     figure; showMatchedFeatures(I0,It,p0(:,inlierIdx)',pt(:,inlierIdx)');
%     title('Matching inliers'); legend('inliersIn', 'inliersOut');

    % debugging
%     figure;
%     imagesc([I0,It]), colormap gray, axis equal tight off;
%     hold on;
%     for i = 1:50
%         line([p0(1,i), pt(1, i)+size(I0,2)], [p0(2,i), pt(2, i)]);
%     end
    
    % visualize inliers
    h = figure;
    imagesc([I0,It]), colormap gray, axis equal tight off;
    hold on;
    for i = 1:size(inliers)
        line([p0(1,inliers(i)), pt(1, inliers(i))+size(I0,2)], [p0(2,inliers(i)), pt(2, inliers(i))]);
    end
    saveas(h, num2str(t, 'img_sequence/%04d_correspondences'), 'png');
    
    % correspondences: 1. row: x_coords t0, 2. row: y_coords t0, 3.row: x_coords t, 4. row:
    % y_coords t
    correspondences{1,t} = [p0(1, inliers); p0(2, inliers); pt(1, inliers); pt(2, inliers)];
end

save('ex2_results');




