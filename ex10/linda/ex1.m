%%
clc;
clear;
close all;

%% ex1
% profile on;
SCORING = 'ssd';
SCALES = [2,4,8,16,32,64, 128,2^8];
QUANTIL = 0.2;
MAXT = 25;

%I = double(rgb2gray(imread('brunnen.jpg')))./255;
I = double(imread('brunnen.jpg'))./255;
%I = double(imread('lena.jpg'))./255;
%I = double(rgb2gray(imread('lena.jpg')))./255;
[n,m,o] = size(I);

% % normalize image
% for i = 1:o
%     t = I(:,:,i);
%     I(:,:,i) = (I(:,:,i)-mean(t(:)))./std(t(:));
% end

figure;
imagesc(I), colormap gray;

rect = round(getrect());
T = I(rect(2):rect(2)+rect(4), rect(1):rect(1)+rect(3), :);
[k,l,z] = size(T);

%build subsampled images
%max_scale = floor()
no_scales = numel(SCALES)+1;
I_pyramid = cell(no_scales, 1);
I_pyramid{1} = I;
T_pyramid = cell(no_scales, 1);
T_pyramid{1} = T;
c = 2;
for i = SCALES
    I_pyramid{c} = I(1:i:n, 1:i:m, :);
    T_pyramid{c} = T(1:i:k, 1:i:l, :);
    c = c+1;
end

% initialize x and y
[x,y] = meshgrid(1:size(I_pyramid{end}, 2), 1:size(I_pyramid{end}, 1));
points = [x(:),y(:), zeros(numel(x),1)];
new_points = points;

small = 0;

all_scores = zeros(o,1);

for s = no_scales:-1:1
        
    It = I_pyramid{s};
    T = T_pyramid{s};
    
    if numel(T(:,:,1)) < MAXT
        small = small +1;
        [x,y] = meshgrid(1:size(I_pyramid{end-small}, 2), 1:size(I_pyramid{end-small}, 1));
        points = [x(:),y(:), zeros(numel(x),1)];
        new_points = points;
        continue;
    end
    
    points = unique(new_points, 'rows');
    
    [k,l, z] = size(T);

    % pad image randomly
    It = pad_rand(It, T);

    % compute scores for all points
    %if strcmp(SCORING, 'ssd')
    switch(SCORING)
        case 'ssd'
            for p = 1:size(points,1)
%                 disp(points(p,1:2));
                for i = 1:o
                    all_scores(i) = sum(sum((T(:,:,i) - It(points(p,2):points(p,2)+k-1, points(p,1):points(p,1)+l-1,i)).^2));
                end
                points(p,3) = mean(all_scores);
            end
 %   else
        case 'ncc'
            for p = 1:size(points,1)
%                 disp(points(p,1:2));
                for i = 1:o
                        I_rect = It(points(p,2):points(p,2)+k-1, points(p,1):points(p,1)+l-1,i);
                        Tc = T(:,:,i);
                        e = sum(sum(Tc .* I_rect));
                        n = sqrt(sum(sum(Tc.^2))) * sqrt(sum(sum(I_rect.^2)));
                        all_scores(i) = e/n;
%                     I_rect = It(points(p,2):points(p,2)+k-1, points(p,1):points(p,1)+l-1,i);
%                     e = sum(sum(T .* I_rect));
%                     n = sqrt(sum(sum(T.^2))) * sqrt(sum(sum(I_rect.^2)));
%                     all_scores(i) = sum(sum(T(:,:,i) .* I_rect))/sqrt(sum(sum(T(:,:,i).^2))) * sqrt(sum(sum(I_rect.^2)));
%                     all_scores(i) = ncc(points(p,1),points(p,2),It(:,:,i),T(:,:,i));
                end
                points(p,3) = mean(all_scores);
            end
    end
        %points(p,3) = compute_score(points(p,1),points(p,2),It,T, SCORING);
    
    % find minima
    points = find_opt(points, QUANTIL, SCORING);
    
    % update points
    new_points = zeros(size(points,1).*4, 3);
    n = 1;
    for p = 1:size(points,1)
        new_points(n:n+3,1:2) = repmat(points(p,1:2).*2, 4, 1);
        new_points(n+1,1) = new_points(n+1,1)-1;
        new_points(n+2,2) = new_points(n+2,2)-1;
        new_points(n+3,1) = new_points(n+3,1)-1;
        new_points(n+3,2) = new_points(n+3,2)-1;
        n = n+4;
    end
end

%points = find_opt(points, 0.1, SCORING);
points = points((points(:,3)==max(points(:,3))),:);

figure;
imagesc(I), colormap gray;
hold on;
plot(points(:,1), points(:,2), 'xr');
t = [rect(2), rect(1); rect(2), rect(1)+rect(3); rect(2)+rect(4), rect(1)+rect(3); rect(2)+rect(4), rect(1);rect(2), rect(1)];
plot(t(:,2), t(:,1), 'g-');

% profile off;
