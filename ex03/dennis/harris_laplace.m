clear all;
close all;
clc;

I = double(imread('lena.gif'));
% I = double(rgb2gray(imread('door.jpg')));

% resolution levels4
n = 5;
k = 1.2;
s0 = 1.5;
alpha = 0.06;

th = 1000000;

% compute sigmas for different scale levels
sigmas = zeros([1,n]);

candidate_points = zeros(0,3);
for i=1:n
    sigmas(i) = s0*k^i;
    fprintf('Computing interest points for sigma %.4f', sigmas(i));
    
    % compute all the candidate points
    [row, column] = harris_corner_detector(I, i, s0, k, alpha, th);
    
    m = size(row,1);
    % save candidate points in matrix
    candidate_points(end+1:end+m, :) = [row, column, ones(m,1)*i];
    fprintf('\t\tdone!\n');
end

%% now compute all laplacian filters
tl = 50;
Dy = -fspecial('prewitt');
Dx = Dy';

laplacians = zeros(size(I,1), size(I,2), n);
fprintf('Computing laplacians...');
for i=1:n
    G = fspecial('gaussian', [round(3*sigmas(i)), round(3*sigmas(i))], sigmas(i));
    I_smooth = conv2(I, G, 'same');
    
    Lxx = conv2(conv2(I_smooth,Dx,'same'), Dx, 'same');
    Lyy = conv2(conv2(I_smooth,Dy,'same'), Dy, 'same');
    
    laplace_i = abs((Lxx + Lyy)*sigmas(i)^2);
    % threshold laplace
    laplace_i(laplace_i < tl) = 0;
    
    laplacians(:,:,i) = laplace_i;
end
fprintf('\t\tdone!\n')

% now check for ever candidate point if it forms a maximum in scale direction
fprintf('Checking every candidate point for maximum in characteristic scale...\n');
points = zeros(0,3);

for i=1:size(candidate_points,1)
    row_index = candidate_points(i,1);
    col_index = candidate_points(i,2);
    sigma_index = candidate_points(i,3);
    
    resp = laplacians(row_index, col_index, sigma_index);
    
    % check extreme cases
    if sigma_index > 1 && sigma_index < n
        % add point, if it forms a maximum in scale direction
        if resp > laplacians(row_index, col_index, sigma_index-1) && ...
                resp < laplacians(row_index, col_index, sigma_index+1)
            points(end+1,:) = [row_index, col_index, sigma_index];
        end
    elseif sigma_index == n
        if resp > laplacians(row_index, col_index, sigma_index-1)
            points(end+1,:) = [row_index, col_index, sigma_index];
        end
    elseif sigma_index == 1
        if resp < laplacians(row_index, col_index, sigma_index+1)
            points(end+1,:) = [row_index, col_index, sigma_index];
        end
    end
end

%% plotting stuff
figure('Name', 'Harris-Laplace Detector', 'NumberTitle', 'Off');
imagesc(I), axis equal tight off, colormap gray
hold on;
% draw all points
for i=1:size(points,1)
    plot(points(i,2), points(i,1), 'ro', 'MarkerSize', points(i,3)*6);
end

