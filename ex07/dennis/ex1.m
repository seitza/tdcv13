clear all;
close all;
clc;

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
            [m,n] = size(first_img);
            img_seq = single(zeros(m,n,nr_imgs));
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

m = frames(1:2,frames(1,:) > min_x & frames(1,:) <= max_x & ...
             frames(2,:) > min_y & frames(2,:) <= max_y);
m_twiddle = vertcat(m,ones(1,size(m,2)));
inv_A = inv(A);   
M_twiddle = zeros(size(m_twiddle));

for i=1:size(m_twiddle,2)
    M_twiddle(:,i) = inv_A*m_twiddle(:,i);
end

% dbg
figure;         
imshow(ref_img);
hold on;
plot(boundary(:,1), boundary(:,2), 'rx', 'MarkerSize', 12);
plot(m_twiddle(1,:), m_twiddle(2,:), 'bo');
     