%% clean workspace
clc;
close all;
clear;

%% settings
SCORE = 'SSD';
SCORE = 'NCC';

GRAY=false;
TIME=true;

DEPTH = 8;
MINAREA = 50;
if(SCORE=='SSD')
    QUANTILE = 0.2;
elseif(SCORE=='NCC')
    QUANTILE = 0.8; 
end

image = 'enten.jpg';
image = 'bmw.jpg';
image = 'brunnen.jpg';

%% load image and define template
%load image
I = imread(image);
if(GRAY)
   if(size(I,3)==3)
      I = rgb2gray(I); 
   end
end
I = double(I)./255.0;
s = size(I);

%display image
figure;
imagesc(I), axis equal tight off;
if(size(I,3)==1)
   colormap(gray);
end
title('Image');

%define template
rect = getrect();
rect = round(rect);

%display template
T = I(rect(2):(rect(2)+rect(4)),rect(1):(rect(1)+rect(3)),:);
figure;
imagesc(T), axis equal tight off;
if(size(T,3)==1)
   colormap(gray);
end
title('Template');
drawnow();

%%create downsamplings aka scale space
%adaptive DEPTH
D = floor(log2(rect(3)*rect(4)/MINAREA));
if(D<DEPTH)
   DEPTH = D; 
end
%preallocate
Is = cell(DEPTH,1);
Ts = cell(DEPTH,1);
Cs = cell(DEPTH,1);

for s = 0:DEPTH-1
   d=2^s;
   Is{s+1} = I(1:d:size(I,1),1:d:size(I,2),:);
   Ts{s+1} = T(1:d:size(T,1),1:d:size(T,2),:);
end

%%use scale space for detection
if(TIME)
   tic;
end
pt = zeros(size(I,3),1);
for s = DEPTH-1:-1:0
    i = Is{s+1};
    %I = i-repmat(mean(mean(i)),size(i,1),size(i,2));
    I = i;
    t = Ts{s+1};
    %T = t-repmat(mean(mean(t)),size(t,1),size(t,2));
    T = t;
    
    %init max coordinates list
    if(exist('coord','var')==0)
        [ix,iy] = meshgrid(1:size(I,2),1:size(I,1));
        coord = [ix(:),iy(:)];
    end
    
    coord = coord(coord(:,1)<=size(I,2) & coord(:,2)<=size(I,1),:);
    
%     figure;
%     imagesc(I);
%     hold on;
%     plot(coord(:,1),coord(:,2),'xr');
    
    %pad image with randoms
    pad = [size(T,1)+1,size(T,2)+1];
    I = padarray(I,pad,-1,'post');
    R = rand(size(I));
    I(I==-1) = R(I==-1);
   
    res = zeros(size(coord,1),1);
    for p = 1:size(coord,1)
       for z = 1:size(I,3)
           if(SCORE=='SSD')
               pt(z) = SSD(coord(p,1),coord(p,2),I(:,:,z),T(:,:,z));
           elseif(SCORE=='NCC')
               pt(z) = NCC(coord(p,1),coord(p,2),I(:,:,z),T(:,:,z));
           end
       end
       res(p) = mean(pt);
    end
    
    %quantile based
    q = quantile(res,QUANTILE);
    %q = QUANTILE;
    if(SCORE=='SSD')
        coord = coord(res<=q,:);
        res = res(res<=q);
    elseif(SCORE=='NCC')
        coord = coord(res>=q,:);
        res = res(res>=q);    
    end
    %fixed number
%     [~,i] = sort(res,1,'descend');
%     if(size(i,1)>10)
%         coord = coord(i(1:10),:);
%     end
 
    Cs{s+1} = coord;
    coord = (coord).*2;
    coord = [coord;...
        coord-repmat([1,0],size(coord,1),1);...
        coord-repmat([0,1],size(coord,1),1);...
        coord-repmat([1,1],size(coord,1),1);];
    coord = unique(coord,'rows');
end

if(TIME)
    toc
end

%%get ONE absolute minimum/maximum in the last image
if(SCORE=='SSD')
    res_coord = Cs{1}(res==min(res),:);
elseif(SCORE=='NCC')
    res_coord = Cs{1}(res==max(res),:);   
end

%% visualize
for s = DEPTH:-1:1
    figure;
   imagesc(Is{s});
   if(GRAY)
      colormap gray; 
   end
   axis equal tight;
   hold on;
   plot(Cs{s}(:,1),Cs{s}(:,2),'Xr');
   title(s);
end

res_rect = [res_coord;...
    res_coord+[rect(3)-1,0];...
    res_coord+[rect(3)-1,rect(4)-1];...
    res_coord+[0,rect(4)-1];...
    res_coord];

plot(res_rect(:,1),res_rect(:,2),'g');