close all;
clear all;
clc;

%% constants
IMG_PATH = strcat(pwd, filesep, 'sequence');
IMG_SUFFIX = 'jpeg';
IMG_START_INDEX = 140;
IMG_PREFIX = '2043_%06d';
SEQ_FILE = 'img_seq.mat';
NR_IMAGES = length(140:190);
WAITING_TIME_TO_CLOSE_FIGURES = 0.8;

%% load img sequence
if ~exist(SEQ_FILE, 'file')
    fprintf('reading in image sequence from path %s\n', IMG_PATH);
    img_seq = load_img_sequence(IMG_PATH, IMG_PREFIX, IMG_SUFFIX, IMG_START_INDEX);
    save(SEQ_FILE, 'img_seq');
else    
    fprintf('loading img sequence from file\n');
    load(SEQ_FILE);
end

%% define region to track
ref_img = img_seq(:,:,:,1);
fprintf('Please define region of interest in first image...\n');
f_ref = figure('Name', 'Reference Image...please choose the region to track', 'NumberTitle', 'Off');
imshow(ref_img);
chosen_region = getrect();
chosen_region = round(chosen_region);
roi = [chosen_region(1) chosen_region(2) chosen_region(1)+chosen_region(3)-1 chosen_region(2)+chosen_region(4)-1];
% roi = [503   304   561   349];

figure(f_ref);
set(f_ref, 'Name', 'Reference Image with chosen region');
hold on;
plot_region(roi, 'r');

ref_region = ref_img(roi(2):roi(4), roi(1):roi(3), :);
color_hist(ref_region, 1);

%% calculate probability distributions
f = figure;
for i=2:NR_IMAGES
    cur_img = img_seq(:,:,:,i);
    cur_region = cur_img(roi(2):roi(4), roi(1):roi(3),:);

    H = color_hist(cur_region);
    pmap = prob_map(cur_region, H);

    figure(f);
    set(f, 'Name', sprintf('Probability distribution of chosen region in image %d\n', i), ...
        'NumberTitle', 'Off');
    imagesc(pmap);
    
    tic; while toc < WAITING_TIME_TO_CLOSE_FIGURES, end
end







