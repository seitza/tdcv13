clc;
clear;
close all;
%% variables
PICTEMP = 140;
PICMIN = 141;
PICMAX = 190;

MAXITER = 20;


%% a)
% region defining the red car
rect = [507,310, 555,344];       % {(xmin, ymin), (xmax, ymax)}
% first image
I1 = imread(num2str(PICTEMP,'sequence/2043_000%03d.jpeg'));
% region in the first image defined by rect
region = I1(rect(2):rect(4), rect(1):rect(3),:);
% compute color histogram of the region
h = colorHist(region);

%% b)
% initialize the center of the rectangular region
xhalf = (rect(3)-rect(1))/2;
yhalf = (rect(4)-rect(2))/2;
centers = zeros(PICMAX-PICMIN+2, 2);
centers(1,:) = [rect(1) + xhalf, rect(2) + yhalf];

figure;
imagesc(I1);
hold on;
plot(centers(1,1), centers(1,2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
drawnow;

% run over the image sequence
for i = 2:PICMAX-PICMIN+2
    disp(i);
    disp(i+PICMIN-2);
    It = imread(num2str(i+PICMIN-2,'sequence/2043_000%03d.jpeg'));
    
    centers(i,:) = centers(i-1,:);
    
    for j = 1:MAXITER
        %disp(j);
        % get new region
        region = It(centers(i,2)-yhalf:centers(i,2)+yhalf, centers(i,1)-xhalf:centers(i,1)+xhalf,:);
        P = probMap(region, h);
        % update region:
        % centers
        [y,x] = meshgrid(centers(i,2)-yhalf:centers(i,2)+yhalf, centers(i,1)-xhalf:centers(i,1)+xhalf);
        xc_new = round(sum(sum(x'.*P)) / sum(sum(P)));
        yc_new = round(sum(sum(y'.*P)) / sum(sum(P)));
        
        % if there is only a small shift, update center and break
        if abs(centers(i,1)-xc_new) < 2 || abs(centers(i,2)-yc_new) < 2
            centers(i,:) = [xc_new, yc_new];
            break;
        end
        centers(i,:) = [xc_new, yc_new];
    end
    imagesc(It);
    plot(centers(1:i,1), centers(1:i,2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    drawnow;
    %waitforbuttonpress;
end


