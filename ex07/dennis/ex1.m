clear all;
close all;
clc;

% setup sift path
if exist('vl_version') == 0
    disp('loading sift implementation...');
    run('vlfeat-0.9.17/toolbox/vl_setup.m');
end

%% loading image sequence
img_seq_file = 'img_sequence.mat';

if exist(img_seq_file, 'file') == 0
    fprintf('loading image files...\n');
    img_path = strcat('img_sequence', filesep);
    nr_imgs = numel(dir(strcat(img_path,'*.png')));

    for i=1:nr_imgs
        file_name = strcat(img_path, num2str(i-1, '%04d.png'));
        if i==1
            first_img = single(rgb2gray(imread(file_name)))/255.0;
            [m_t0,n] = size(first_img);
            img_seq = single(zeros(m_t0,n,nr_imgs));
            img_seq(:,:,i) = first_img;
        else
            img_seq(:,:,i) = single(rgb2gray(imread(file_name)))/255.0;
        end
    end
    save('img_sequence.mat', 'img_seq');
else
    fprintf('loading image sequence from .mat file\n');
    load('img_sequence.mat', 'img_seq');
end

%% setup default parameters
R0 = eye(3,3);
T0 = zeros(3,1);
A = [472.3 0.64 329.0;
     0 471.0 268.3;
     0  0   1];
 
 %% ex1
 ref_img = img_seq(:,:,1);
 % corners of the image figure
 boundary = [103, 75;
             550, 75;
             105, 385;
             553, 385];
         
min_x = min(boundary(:,1));
max_x = max(boundary(:,1));
min_y = min(boundary(:,2));
max_y = max(boundary(:,2));

% compute all sift keypoints
[frames, descriptors] = vl_sift(ref_img);

valid_frames = frames(1,:) > min_x & frames(1,:) <= max_x & ...
             frames(2,:) > min_y & frames(2,:) <= max_y;
         
m_t0 = frames(1:2,valid_frames);
m_t0_frames = frames(:,valid_frames);
m_t0_descriptors = descriptors(:,valid_frames);

m_twiddle_t0 = vertcat(m_t0,ones(1,size(m_t0,2)));
M_twiddle_t0 = A\m_twiddle_t0;
   
%% ex2
nr_images = size(img_seq,3)-1;
figure_handles = zeros(1,nr_images);
figure_path = strcat(pwd,filesep,'figures');

if ~exist(figure_path,'dir')
    disp('creating figure directory...');
    mkdir(figure_path);
end

for i=2:nr_images
    cur_img = img_seq(:,:,i);

    % compute all sift points
    [f_ti, d_ti]  = vl_sift(cur_img);
    [matches, scores] = vl_ubcmatch(m_t0_descriptors, d_ti);

    % now estimate homography and get all inliers from 
    % the corresponding sift points
    m_t0_matches = m_t0(:,matches(1,:));
    m_ti_matches = f_ti(1:2,matches(2,:));
    
    [tform, inliers_m_t0, inliers_m_t1] = estimateGeometricTransform(...
        m_t0_matches', ...
        m_ti_matches', 'affine', ...
        'MaxNumTrials', 2000, ...
        'MaxDistance', 8);
    
    % display all inliers
    [h,w] = size(ref_img);
    inliers_m_t1 = inliers_m_t1 + repmat([w,0], size(inliers_m_t1,1),1);
    
    cur_fig = figure('Name', sprintf('Displaying found matching points in image %d', i));
    imagesc([ref_img cur_img]), axis equal tight off, colormap gray;
    hold on;
    plot(inliers_m_t0(:,1), inliers_m_t0(:,2), 'rx');
    plot(inliers_m_t1(:,1), inliers_m_t1(:,2), 'gx');
    for in=1:size(inliers_m_t0,1)
        line([inliers_m_t0(in,1), inliers_m_t1(in,1)], [inliers_m_t0(in,2), inliers_m_t1(in,2)]);
    end
    savefig(cur_fig,...
        strcat(figure_path, filesep, sprintf('inliers_img_%d',i)));
end
