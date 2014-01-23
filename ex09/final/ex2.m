close all;
clear all;
clc;

% constants
IMG_SEQ = 'img_seq.mat';
MAX_ITERATIONS = 20;
MIN_MOVEMENT = 2;

% load img sequence
load(IMG_SEQ);
NR_IMGS = size(img_seq, 4);

% get rectangular region from user
ref_img = img_seq(:,:,:,1);
figure('Name', 'Please choose the region to track!', 'NumberTitle', 'Off');
imshow(ref_img);
defined_region = getrect();
defined_region = round(defined_region);

roi = [defined_region(1) defined_region(2) defined_region(1)+defined_region(3)-1 defined_region(2) + defined_region(4) - 1];
first_roi = ref_img(roi(2):roi(4), roi(1):roi(3), :);
H = color_hist(first_roi);

center_location = zeros(2,NR_IMGS);
w_half = round((roi(3)-roi(1))/2);
h_half = round((roi(4)-roi(2))/2);
center_location(:,1) = [roi(1) + w_half; roi(2) + h_half];

% plot selected region into image
hold on;
plot_region(roi, 'r');
plot(center_location(1,1),center_location(2,1),'rx');

% do the tracking
for i=2:NR_IMGS
    cur_img = img_seq(:,:,:,i);
    center_location(:,i) = center_location(:,i-1);   
    
    for it=1:MAX_ITERATIONS
        xc = center_location(1,i);
        yc = center_location(2,i);
        
        cur_roi = cur_img(yc-h_half:yc+h_half,xc-w_half:xc+w_half,:);
        pmap = prob_map(cur_roi, H);

        normalization = sum(sum(pmap));
    
        [xg, yg] = meshgrid(xc-w_half:xc+w_half, yc-h_half:yc+h_half);
        xc_new = round(sum(sum(xg.*pmap)) / normalization);
        yc_new= round(sum(sum(yg.*pmap)) / normalization);
        
        if abs(xc - xc_new) < MIN_MOVEMENT || abs(yc - yc_new) < MIN_MOVEMENT
            center_location(:,i) = [xc_new; yc_new];
            break;
        else
            center_location(:,i) = [xc_new; yc_new];
        end
    end
    
    imshow(cur_img);
    plot(center_location(1,1:i), center_location(2,1:i),'bx', 'MarkerSize', 10);
    drawnow;
end

