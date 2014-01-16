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


%% ex09/1/A
% load first image
template_rgb = imread(sprintf(PATH,TEMPLATE_NR));
template_hue = extractHue(template_rgb);

% define region
imagesc(template_rgb);
rect = getrect; %xmin ymin width height
rect = round(rect);

%% ex09/1/B
% create grid
[x,y] = meshgrid(rect(1):rect(1)+rect(3),rect(2):rect(2)+rect(4));
grid = [x(:),y(:)];

% generate histogram on region and maybe plot
H = colorHist(template_hue, grid, true);

%% ex09/1/C

%visualize template
probDist = probMap( template_hue, grid, H );
probDist = reshape(probDist,rect(4)+1,rect(3)+1);

figure;
imagesc(probDist);
axis equal tight;
drawnow();

for NR = FIRST_SEQ:LAST_SEQ
    pause(0.2);
    
    %load image
    I_rgb = imread(sprintf(PATH,NR));
    I_hue = extractHue(I_rgb);
    
    probDist = probMap( I_hue, grid, H );
    probDist = reshape(probDist,rect(4)+1,rect(3)+1);

    imagesc(probDist);
    drawnow();    
end