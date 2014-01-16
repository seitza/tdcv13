clear;
close all;
clc;

%% PARAMETERS
%image path
PATH = 'sequence/2043_%06d.jpeg';
%template image
TEMPLATE_NR = 140;
%sequence image numbers; first - last
FIRST_SEQ = 141;
LAST_SEQ = 190;
%max number of iterations in tracking
MAX_ITER = 20;
%break criteria for lower movement
LOWER_MOVEMENT = 2;

%% ex09/2/A
% load first image
template_rgb = imread(sprintf(PATH,TEMPLATE_NR));
template_hue = extractHue(template_rgb);

% define region
imagesc(template_rgb);
hold on;
rect = getrect; %xmin ymin width height
rect = round(rect);
rectangle('Position',rect,'EdgeColor','b');

% create grid
[x,y] = meshgrid(rect(1):rect(1)+rect(3),rect(2):rect(2)+rect(4));
grid = [x(:),y(:)];
center = mean(grid);
plot(center(1),center(2),'Xr');

% generate histogram on region and maybe plot
H = colorHist(template_hue, grid, false);

%% ex09/2/B
centers = zeros(LAST_SEQ-FIRST_SEQ+2,2);
centers(1,:) = center;

figure;
for NR = FIRST_SEQ:LAST_SEQ

    %load image
    I_rgb = imread(sprintf(PATH,NR));
    I_hue = extractHue(I_rgb);
    
    for i = 1:MAX_ITER
    
        %calculate probability denisty over region
        probDist = probMap( I_hue, grid, H );
        
        %calculate center
        xc = sum(sum(probDist.*grid(:,1)'))/sum(sum(probDist));
        yc = sum(sum(probDist.*grid(:,2)'))/sum(sum(probDist));
        old_center = center;
        center = [xc,yc];
        center_diff = center-old_center;
        
        %update grid
        grid = round(grid+repmat(center_diff,size(grid,1),1));
        
        %break criteria if movement lower than LOWER_MOVEMENT
        if(sqrt(sum(center_diff.^2)) < LOWER_MOVEMENT)
           break; 
        end
    end
    centers(NR-FIRST_SEQ+2,:) = center;
    
    %plot new image and centers
    imagesc(I_rgb);
    hold on;
    plot(centers(:,1),centers(:,2),'Xr');
    drawnow();
end