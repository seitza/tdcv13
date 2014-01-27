%%
clc;
clear;
close all;

%% ex1

SCORING = 'ssd';
SCALES = [2,4,8,16,32,64];
QUANTIL = 0.2;

%I = double(rgb2gray(imread('brunnen.jpg')))./255;
I = double(imread('brunnen.jpg'))./255;

figure;
imagesc(I), colormap gray;
[n,m,o] = size(I);

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

for s = no_scales:-1:1
        
    points = unique(new_points, 'rows');
    It = I_pyramid{s};
    T = T_pyramid{s};
    
    if numel(T) < 25
        continue;
    end
    
    % pad image randomly
    It = pad_rand(It, T);

    % compute scores for all points
    for p = 1:size(points,1)
        disp(points(p,1:2));
        points(p,3) = compute_score(points(p,1),points(p,2),It,T, SCORING);
    end
%     if strcmp(SCORING,'ssd')
%         for p = 1:size(points,1)
%             disp(points(p,1:2));
%             points(p,3) = ssd(points(p,1),points(p,2),It,T);
%         end
%     else
%         for p = 1:size(points,1)
%             disp(points(p,1:2));
%             points(p,3) = ncc(points(p,1),points(p,2),It,T);
%         end
%     end
    
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
%scores(scores(:,3)>=val,:)

figure;
imagesc(I), colormap gray;
hold on;
plot(points(:,1), points(:,2), 'xr');
t = [rect(2), rect(1); rect(2), rect(1)+rect(3); rect(2)+rect(4), rect(1)+rect(3); rect(2)+rect(4), rect(1);rect(2), rect(1)];
plot(t(:,2), t(:,1), 'g-');


