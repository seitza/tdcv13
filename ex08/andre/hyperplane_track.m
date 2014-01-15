%% clean workspace

clc;
close all;
if ~exist('A','var')
clear;
end

%% param
%just a test image;
%testI = randi(255,600,800);
%region to be tracked
region = [[350;450;450;350],[150;150;250;250]]; %100x100

%DEBUG VON LINDA
% xUL = 250;
% yUL = 100; 
% xUR = 351;
% yUR = yUL;
% xDR = xUR;
% yDR = 201;
% xDL = xUL;
% yDL = yDR;
% corners = [xUL, yUL; xUR, yUR; xDR, yDR; xDL, yDL];
% region = corners;
% rand_shift = [5,10,-4,6,1,-2,-10,8];
%ENDE DEBUG VON LINDA

%maximum divergence for random warps
%MD = 30; % will be set during iteration over A
%grid density
GD = 5;
%number of samples n> NumberOfGridPoints (400)
n = 2000;
%number of updates
ni = 10;
%number if available images
NUMPIC = 44;

% set image
Im = double(rgb2gray(imread(strcat('image_sequence/0000.png'))));
% generate grid
[x,y] = meshgrid(min(region(:,1)):GD:max(region(:,1)),min(region(:,2)):GD:max(region(:,2)));
regionGrid = [x(:),y(:)];
% sample image
T = sample(Im,regionGrid);

%% run learning 
%only if A nonexistent
if ~exist('A','var')

    %init A
    A = zeros(ni,8,size(T,1));

    for i = ni:-1:1
        MD = 3*i;

        I = zeros(size(T,1),n);
        P = zeros(8,n);
        for s = 1:n
            %disp([i s]);
            rand_rect = randi((2*MD)+1,4,2)-MD;
            %DEBUG VON LINDA
            warpedRegion = region+rand_rect;
            %r=region+reshape(rand_shift,4,2);
            [H,warpedRegionGrid] = warp(region,warpedRegion,regionGrid);
            backwarpedRegionGrid = useHomography(regionGrid,inv(H));
            S = sample(Im,backwarpedRegionGrid);
            I(:,s) = S-T;
            P(:,s) = rand_rect(:);
        end
        
        A(ni-i+1,:,:) = (P*I')*inv(I*I');

    end
end

%% run tracking

%current parameter vector
pCur = zeros(8,1);

%applay all available images according to NUMPIC
for t = 1:NUMPIC
   
    %load image
    I = double(rgb2gray(imread(strcat('image_sequence/00',num2str(t,'%02d'),'.png'))));
    
    figure;
    imagesc(I);
    hold on;
    colormap gray;
    axis equal tight;
    
    region_plot = [region;region(1,:)];
    plot(region_plot(:,1),region_plot(:,2),'b');
    drawnow();
    
    %DEBUG
    %close all;
    
    %apply all prealcualted matrices A per image
    for n = 1:size(A,1)
        
        %DEBUG
        %close all;
        
        %applay every A(n,:,:) m times, eg 5 times
        for m = 1:5

            %a) Extract the image values at the sample positions warped according to the current parameter vector.
            %b) Normalize the extracted image values as done in the learning stage.

            [~,warpedRegionGrid] = warp(region,region+reshape(pCur,4,2),regionGrid);
            S = sample(I,warpedRegionGrid);

            %c) Substract the normalized image values of the reference template from the current normalized image values.
            D = S-T;
     
%             imagesc([reshape(S,21,21),reshape(T,21,21),reshape(D,21,21)]), colormap gray;
%             drawnow();
%             pause(0.2);
%             
            %d) Compute the parameter update by multiplying the update matrix with the obtained image value difference vector
            pUp = reshape(A(n,:,:),size(A,2),size(A,3))*D;
            
%             %e) Update the parameter vector using the parameter update:
% 
%             pTmp = pUp;
%             %Compute the current homography Hc between the initial parameter vector and the current parameter vector.
%             [Hc,~,~] = normalized_dlt(region, region+reshape(pCur,4,2));
%             %Compute the update homography Hu which corresponds to the update only.
%             [Hu,~,~] = normalized_dlt(region+reshape(pCur,4,2), region+reshape(pTmp,4,2));
%             %Multiply the current homography by the update homography:
%             Hn = Hc*Hu;
%             
%             pTmp = useHomography(region,Hn);
%             pCur = pTmp(:)-region(:)+pCur(:);
            
            pCur = pCur+pUp;
            
            
%             imagesc(I);
%             hold on;
%             colormap gray;
% 
%             region_plot = [region;region(1,:)];
%             plot(region_plot(:,1),region_plot(:,2),'b');
%     
            pCur_plot = reshape(pCur,4,2);
            pCur_plot = [region+pCur_plot;region(1,:)+pCur_plot(1,:)];
            plot(pCur_plot(:,1),pCur_plot(:,2),'g');
            drawnow();
%             pause(0.1);
            
        end
    end
    
            pCur_plot = reshape(pCur,4,2);
            pCur_plot = [region+pCur_plot;region(1,:)+pCur_plot(1,:)];
            plot(pCur_plot(:,1),pCur_plot(:,2),'r');
            drawnow();
    
end

