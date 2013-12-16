clear all;
close all;
clc;

% setup sift path
if exist('vl_version') == 0
    disp('loading sift implementation...');
    run('vlfeat-0.9.17/toolbox/vl_setup.m');
end

figure_path = strcat(pwd,filesep,'figures');
if ~exist(figure_path,'dir')
    disp('creating figure directory...');
    mkdir(figure_path);
    disp('figures for correct SIFT points will be generated...\n');
    create_figures_ex2 = 1;
else
    create_figures_ex2 = 0;
end

% load results from first exercise - needed
load('results_ex1.mat');

%% loading image sequence
fprintf('loading image sequence from .mat file\n');
load('img_sequence.mat', 'img_seq');

ref_img = img_seq(:,:,1);

nr_images = size(img_seq,3);
figure_handles = zeros(1,nr_images);

m_ti = cell(nr_images,1);
m_ti{1} = m_t0;

for i=2:nr_images
    fprintf('looking at image %d\n', i);
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

    % save the correct point correspondences
    fprintf('saving correctly matched SIFT points\n');
    m_ti{i} = m_ti_matches;
    
    % display all inliers
    if create_figures_ex2 == 1
        fprintf('creating figure for correct SIFT points in image %d\n', i);
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
        close(cur_fig);
    end
end
fprintf('saving correct point correspondences\n');
save('correct_point_correspondences.mat', 'm_ti');
