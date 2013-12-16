clear all;
close all;
clc;

% Setup sift path
if exist('vl_version') == 0
    disp('loading sift implementation...');
    run('/Users/Pitou/Documents/München/DTCV/Exercises/Ex7/vlfeat-0.9.17/toolbox/vl_setup.m');
end

% Value
load('ex1_result');

% SIFT
for t = 1:44
    It = strcat('img_sequence/00',num2str(t,'%02d'),'.png');
    It = single(rgb2gray(imread(It)));
    [ft, dt] = vl_sift(It);
    
    [matches, scores] = vl_ubcmatch(d0, dt);
    
    [tform, inliers0, inlierst] = estimateGeometricTransform(...
        d0(1:2,matches(1,:))',...
        dt(1:2,matches(2,:))',...
        'affine',...
        'MaxNumTrials',2000,...
        'MaxDistance',8);
    
    figure;
    imagesc([I0,It]), colormap gray, axis equal tight off;
    hold on;
    for i = 1:size(inliers0,1)
      plot([inliers0(i,1),inlierst(i,1)+size(I0,2)],[inliers0(i,2),inlierst(i,2)]);
      plot([inliers0(i,1),inlierst(i,1)+size(I0,2)],[inliers0(i,2),inlierst(i,2)],'g+');
   end
end
