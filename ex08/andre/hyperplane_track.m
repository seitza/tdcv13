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

%% run learning 
%only if A nonexistent
if ~exist('A','var')
    % set image
    Im = double(rgb2gray(imread(strcat('image_sequence/0000.png'))));
    % generate grid
    [x,y] = meshgrid(min(region(:,1)):GD:max(region(:,1)),min(region(:,2)):GD:max(region(:,2)));
    % sample image
    ind = sub2ind(size(Im),y(:),x(:));
    T = Im(ind);
    %normalize samples
    T = (T-mean(T))/std(T);
    T = T+rand(size(T));

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
            r=region+rand_rect;
            %r=region+reshape(rand_shift,4,2);
            W = warp(Im,region,r,GD);
            I(:,s) = W-T;
            P(:,s) = rand_rect(:);
        end

        A(ni-i+1,:,:) = (P*I')*inv(I*I');

    end
end

%% run tracking

%current parameter vector
Vcur = zeros(8,1);

%init and first patch
F = region;

% %load first reference
% I = double(rgb2gray(imread(strcat('image_sequence/0000.png'))));
% 
% %get template points
% [x,y] = meshgrid(min(patch_init(:,1)):GD:max(patch_init(:,1)),min(patch_init(:,2)):GD:max(patch_init(:,2)));
% ind = sub2ind(size(I),y(:),x(:));
% T = I(ind);
% T = (T-mean(T))/std(T);
% T = T+rand(size(T));
% 
% %visualize template
% figure;
% imagesc(I), colormap(gray);
% hold on;
% patch_plot = [patch_init;patch_init(1,:)];
% plot(patch_plot(:,1),patch_plot(:,2));
% title('template');

%applay all available images according to NUMPIC
for t = 1:NUMPIC
   
    %load image
    I = double(rgb2gray(imread(strcat('image_sequence/00',num2str(t,'%02d'),'.png'))));
    
    %DEBUG
    %close all;
    
    %apply all prealcualted matrices A per image
    for n = 1:size(A,1)
        
        %DEBUG
%          close all;
        
        %applay every A(n,:,:) m times, eg 5 times
        for m = 1:5
            disp([t n m]);
%             Vcur = Sample(Image,F,$\cal R$)
            Vcur = warp(I,region,F,GD);
            disp(F);
%             DI = Vcur-Vref
            DI = Vcur-T;
%             inv_Fmod = inv(A*DI)
            Fmod = reshape(A(n,:,:),size(A,2),size(A,3))*DI;
            disp(Fmod);
            %a) Extract the image values at the sample positions warped according to the current parameter vector.
            %b) Normalize the extracted image values as done in the learning stage.
%             patch = patch_init+reshape(p_vec,4,2);
%             W = warp(I,patch_init,patch,GD);

            %c) Substract the normalized image values of the reference template from the current normalized image values.
%             S = W-T;

            %d) Compute the parameter update by multiplying the update matrix with the obtained image value difference vector
            %p_up := parameter update
%             p_up = reshape(A(n,:,:),size(A,2),size(A,3))*S;
%             p_vec = p_up;
            
            %e) Update the parameter vector using the parameter update:
%             patch_new = patch_init+reshape(p_up,4,2); 
            %patch_new = patch+reshape(p_up,4,2); 
            
            
            %Compute the current homography Hc between the initial parameter vector and the current parameter vector.
            [Hc,~,~] = normalized_dlt(region, reshape(F,4,2));
            %Compute the update homography Hu which corresponds to the update only.
            [Hu,~,~] = normalized_dlt(reshape(F,4,2), region+reshape(Fmod,4,2));
            %Multiply the current homography by the update homography:
            Hn = inv(Hc)*inv(Hu);
            
            F = [region,ones(size(region,1),1)]*Hn';
            F = F./repmat(F(:,3),1,3);
            F = F(:,1:2);
            disp(F);
            
            
%             rf = F;
%             rf = [rf;rf(1,:)];
%             figure;
%             imagesc(I);
%             colormap gray;
%             hold on;
%             plot(rf(:,1),rf(:,2),'g');
%             plot(region(:,1),region(:,2),'xb');

            %Compute the new parameter vector based on the new homography.
%             patch_tmp = [patch_init,ones(size(patch_init,1),1)]*Hn';
%             patch_tmp = patch_tmp./repmat(patch_tmp(:,3),1,3);
%             patch_tmp = patch_tmp(:,1:2);
            
            %p_vec = patch_tmp(:)-patch_init(:);
            %p_vec = patch_init(:)-patch_tmp(:);
            
            %visualize
%             figure;
%             imagesc(I), colormap gray;
%             pi = [patch_init;patch_init(1,:)];
%             %po = [patch_old;patch_old(1,:)];
%             pc = [patch;patch(1,:)];
%             pn = [patch_new;patch_new(1,:)];
%             pt = [patch_tmp;patch_tmp(1,:)];
%             hold on;
%             plot(pi(:,1),pi(:,2),'b');
%             %plot(po(:,1),po(:,2),'r');
%             plot(pc(:,1),pc(:,2),'r');
%             plot(pn(:,1),pn(:,2),'g');
%             plot(pt(:,1),pt(:,2),'y');
            
%             disp([t n m]);
%             disp(p_vec);
        end
    end
    
    patch_plot = reshape(F,4,2);
    %visualize
    figure;
    imagesc(I), colormap(gray);
    hold on;
    patch_plot = [patch_plot;patch_plot(1,:)];
    plot(patch_plot(:,1),patch_plot(:,2));
    title(t);
    
end

