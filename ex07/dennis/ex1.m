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

% save results
save('results_ex1.mat', 'm_twiddle_t0', 'M_twiddle_t0', 'm_t0', 'm_t0_frames', 'm_t0_descriptors');
