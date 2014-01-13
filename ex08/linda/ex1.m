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

[X_rect, Y_rect] = meshgrid(min(corners(:,1)):5:max(corners(:,1)), min(corners(:,2)):5:max(corners(:,2)));
grid = [X_rect(:), Y_rect(:)];

% % debugging
% rand_shift = [5,10,-4,6,1,-2,-10,8];
% max_shift = 0;
% [sample P] = randomTransformation(Img, corners, max_shift, grid, rand_shift);

%% learning A
disp('Start Learning');
number_update_matrices = 10;
A = zeros(8,size(grid,1), number_update_matrices);
for j = 1:number_update_matrices
    % create n warped samples
    max_shift = 3*j;
    n = size(grid,1);
    % first sample in original image
    intensities = Img(sub2ind(size(Img),grid(:,2), grid(:,1)));
    normed_intensities = normIntensities(intensities);
    samples = zeros(size(grid,1),3,n+1);
    samples(:,:,1) = [grid, normed_intensities];
    P = zeros(8,n);       % corner displacements
    for i = 2:n+1
        [samples(:,:,i), P(:,i-1)] = randomTransformation(Img, corners, max_shift, grid);
    end

    % compute I as the normalized intensity differences from each warped sample
    % to the original grid
    I = zeros(size(grid,1),n);
    for i = 1:n
        I(:,i) = samples(:,3,1) - samples(:,3,i+1);
    end

    A(:,:,j) = P*I'*inv(I*I');
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
% curr_grid = grid;
for i = 1:44
    
    disp(['image' num2str(i)]);
    
    It = double(rgb2gray(imread(num2str(i,'image_sequence/%04d.png'))));
    
    for a = number_update_matrices:-1:1
        disp(['a=' num2str(a)]);
        for j = 1:5
            disp(['j=' num2str(j)]);
            patch = corners + reshape(p, 4,2);
            
            H = normalized_dlt(corners, patch);
            
            % warp the grid
            grid_warped = (H*[grid, ones(size(grid,1),1)]')';
            grid_warped = round(grid_warped ./ repmat(grid_warped(:,3), 1,3));
            
            % find intensities covered by the warped grid
            xmin = min(grid_warped(:,1));
            xmax = max(grid_warped(:,1));
            ymin = min(grid_warped(:,2));
            ymax = max(grid_warped(:,2));
            [m,n] = size(It);
            pad = round(min([1+xmin, 1+ymin, n-xmax, m-ymax]))*-1;
            disp(['pad=' num2str(pad)]);
            I_padded = It;
            if pad > 0
                I_padded = padarray(I, [pad, pad]);
                curr_intensities = I_padded(sub2ind(size(I_padded), grid_warped(:,2)+pad, grid_warped(:,1)+pad));
            else
                curr_intensities = I_padded(sub2ind(size(I_padded), grid_warped(:,2), grid_warped(:,1)));
            end
            
            curr_normed_intensities = normIntensities(curr_intensities);

            % subtract intensities
            differences = curr_normed_intensities - normed_intensities;

            % compute movement
            move = A(:,:,a)*differences;

            % 
            patch_new = corners + reshape(move, 4,2);
            
            Hc = H;
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
    imagesc(It);
    hold on;
    colormap gray;
    plot_patch = corners + reshape(p,4,2);
    plot([plot_patch(:,1); plot_patch(1,1)],[plot_patch(:,2); plot_patch(1,2)]);
    drawnow();
end

