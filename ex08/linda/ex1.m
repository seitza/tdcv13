close all;
clc;
clear;
%%

Img = double(rgb2gray(imread('image_sequence/0000.png')));

% prepare sample
xUL = 250;
yUL = 100; 
xUR = 351;
yUR = yUL;
xDR = xUR;
yDR = 201;
xDL = xUL;
yDL = yDR;

corners = [xUL, yUL; xUR, yUR; xDR, yDR; xDL, yDL];
GD = 5;     % grid density
NUMPIC = 44;        % number images
number_update_matrices = 10;


[X_rect, Y_rect] = meshgrid(min(corners(:,1)):GD:max(corners(:,1)), min(corners(:,2)):GD:max(corners(:,2)));
grid = [X_rect(:), Y_rect(:)];

% % debugging
% rand_shift = [5,10,-4,6,1,-2,-10,8];
% max_shift = 0;
% [sample P] = randomTransformation(Img, corners, max_shift, grid, rand_shift);

%% learning A
disp('Start Learning');

% first sample in original image
% compute I as the normalized intensity differences from each warped sample
% to the original grid
intensities = Img(sub2ind(size(Img),grid(:,2), grid(:,1)));
normed_intensities = normIntensities(intensities);
sample = [grid, normed_intensities];
sample(:,3) = sample(:,3) + rand(size(sample(:,3)));

A = zeros(8,size(grid,1), number_update_matrices);
for j = 1:number_update_matrices
    % create n warped samples (n >= #grid points)
    max_shift = 3*j;
    disp(['#####################     ' num2str(max_shift) '    ############################']);
    n = 3*size(grid,1);

    P = zeros(8,n);       % corner displacements
    I = zeros(size(grid,1),n);  % differences
    for i = 1:n
        [rand_warped_sample, P(:,i)] = randomTransformation(Img, corners, max_shift, grid);
        I(:,i) = rand_warped_sample(:,3) - sample(:,3);
    end
    A(:,:,j) = (P*I')*inv(I*I');
end


%% Application of the tracking
disp('Start Testing!');
% visualize first image
figure;
imagesc(Img);
hold on;
colormap gray;
plot([corners(:,1); corners(1,1)],[corners(:,2); corners(1,2)]);
drawnow();

p = zeros(8,1);
prev_intensities = normed_intensities;
%curr_grid = grid;
for i = 1:NUMPIC
    
    disp(['image' num2str(i)]);
    
    It = double(rgb2gray(imread(num2str(i,'image_sequence/%04d.png'))));
    
    for a = number_update_matrices:-1:1
        disp(['a=' num2str(a)]);
        for j = 1:5
            disp(['j=' num2str(j)]);
            
            % visualize image
            figure;
            imagesc(It), colormap gray;
            hold on;
            plot([corners(:,1); corners(1,1)],[corners(:,2); corners(1,2)], 'c-');
            
            patch = corners + reshape(p, 4,2);
            % plot previous patch
            plot([patch(:,1); patch(1,1)],[patch(:,2); patch(1,2)], 'b-');
            
            warped_sample = warpSample( It, grid, corners, patch );

            % subtract intensities
%             differences = warped_sample(:,3) - sample(:,3);
            differences = warped_sample(:,3) - prev_intensities;

            % compute movement
            move = A(:,:,a)*differences;

            % 
            patch_new = corners + reshape(move, 4,2);
%             patch_new = patch + reshape(move, 4,2);

            % plot previous patch
            plot([patch_new(:,1); patch_new(1,1)],[patch_new(:,2); patch_new(1,2)], 'r-');
            
            Hc = normalized_dlt(corners, patch);
            Hu = normalized_dlt(patch, patch_new);
            Hn = Hc*Hu;

            % update patch / corners
            p = (Hn*[corners,ones(4,1)]')';
            p = p ./ repmat(p(:,3), 1,3);
            p = p(:,1:2)-corners;
            p = p(:);
        end
    end
    % visualize each image
    figure;
    imagesc(It), colormap gray;
    hold on;
    plot_patch = corners + reshape(p,4,2);
    plot([corners(:,1); corners(1,1)],[corners(:,2); corners(1,2)], 'b-');
    plot([plot_patch(:,1); plot_patch(1,1)],[plot_patch(:,2); plot_patch(1,2)], 'g-');
    drawnow();
    close all;
end

