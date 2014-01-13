
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

%% learning A
number_update_matrices = 10;
A = zeros(8,size(grid,1), number_update_matrices);
for j = 1:number_update_matrices
    % create n warped samples
    max_shift = 3*j;
    n = size(grid,1);
    % first sample in original image
    intensities = Img(ind2sub(grid(:,1), grid(:,2)));
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
curr_grid = grid;
for i = 2:44
    It = rgb2gray(imread(num2str(t,'img_sequence/%04d.png')));
    
    for a = number_update_matrices:-1:1
        
        for j = 1:5
            % find intensities covered by the warped grid
            xmin = min(curr_grid(:,1));
            xmax = max(curr_grid(:,1));
            ymin = min(curr_grid(:,2));
            ymax = max(curr_grid(:,2));
            [m,n] = size(I);
            pad = max([1-xmin, 1-ymin, xmax-n, ymax-m]);
            I_padded = I;
            if pad > 0
                I_padded = padarray(I, [pad, pad]);
            end

            curr_intensities = I_padded(ind2sub(curr_grid(:,1)-pad, curr_grid(:,2)-pad));

            curr_normed_intensities = normIntensities(curr_intensities);

            % subtract intensities
            differences = curr_normed_intensities - normed_intensities;

            % compute movement
            move = A(:,:,a)*differences;

            % 


            % update grid
            [x, y] = meshgrid(min(move(1:4,1)):5:max(move(1:4,1)), min(move(5:8,2)):5:max(move(5:8,2)));
            curr_grid = [x(:), y(:)];
        end
    end
end

