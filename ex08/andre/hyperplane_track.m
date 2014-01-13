%% clean workspace

clc;
close all;
clear;

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
n = 1000;
%number of updates
ni = 10;
%number if available images
NUMPIC = 44;

%% run learning 

% set image
Im = double(rgb2gray(imread(strcat('image_sequence/0000.png'))));
% generate grid
[x,y] = meshgrid(min(region(:,1)):GD:max(region(:,1)),min(region(:,2)):GD:max(region(:,2)));
% sample image
ind = sub2ind(size(Im),y(:),x(:));
S = Im(ind);
%normalize samples
S = (S-mean(S))/std(S);
S = S+rand(size(S));

%init A
A = zeros(ni,8,size(S,1));

for i = ni:-1:1
    MD = 3*i;
    
    I = zeros(size(S,1),n);
    P = zeros(8,n);
    for s = 1:n
        %disp([i s]);
        rand_rect = randi((2*MD)+1,4,2)-MD;
        %DEBUG VON LINDA
        r=region+rand_rect;
        %r=region+reshape(rand_shift,4,2);
        W = warp(Im,region,r,GD);
        I(:,s) = W-S;
        P(:,s) = rand_rect(:);
    end

    A(ni-i+1,:,:) = (P*I')*inv(I*I');

end

%% run tracking

%current parameter vector
init_vec = zeros(8,1);
p_vec = init_vec;
patch_init = region+reshape(p_vec,4,2);
%load first reference
I = double(rgb2gray(imread(strcat('image_sequence/0001.png'))));
%get template points
[x,y] = meshgrid(min(region(:,1)):GD:max(region(:,1)),min(region(:,2)):GD:max(region(:,2)));
ind = sub2ind(size(I),y(:),x(:));
T = I(ind);
T = (T-mean(T))/std(T);
T = T+rand(size(T));

%visualize
figure;
imagesc(I), colormap(gray);
hold on;
patch_plot = [patch_init;patch_init(1,:)];
plot(patch_plot(:,1),patch_plot(:,2));
title('template');

%applay all available images according to NUMPIC
for t = 1:NUMPIC
   
    %load image
    I = double(rgb2gray(imread(strcat('image_sequence/00',num2str(t,'%02d'),'.png'))));
    
    %apply all prealcualted matrices A per image
    for n = 1:size(A,1)
        
        %DEBUG
        close all;
        %applay every A(n,:,:) m times, eg 5 times
        for m = 1:10

            %a) Extract the image values at the sample positions warped according to the current parameter vector.
            %b) Normalize the extracted image values as done in the learning stage.
            patch = region+reshape(p_vec,4,2);
            W = warp(I,region,patch,GD);

            %c) Substract the normalized image values of the reference template from the current normalized image values.
            S = W-T;

            %d) Compute the parameter update by multiplying the update matrix with the obtained image value difference vector
            p = reshape(A(n,:,:),size(A,2),size(A,3))*S;
            
            %e) Update the parameter vector using the parameter update:
            patch_new = region+reshape(p,4,2); 
            
            %visualize
            figure;
            imagesc(I), colormap gray;
            pi = [patch_init;patch_init(1,:)];
            pc = [patch;patch(1,:)];
            pn = [patch_new;patch_new(1,:)];
            hold on;
            plot(pi(:,1),pi(:,2),'g');
            plot(pc(:,1),pc(:,2),'b');
            plot(pn(:,1),pn(:,2),'r');
            
            %Compute the current homography Hc between the initial parameter vector and the current parameter vector.
            [Hc,~,~] = normalized_dlt(patch_init, patch);
            %Compute the update homography Hu which corresponds to the update only.
            [Hu,~,~] = normalized_dlt(patch, patch_new);
            %Multiply the current homography by the update homography:
            Hn = Hc*Hu;
            %Compute the new parameter vector based on the new homography.
            patch_tmp = [patch_init,ones(size(patch_init,1),1)]*Hn';
            patch_tmp = patch_tmp./repmat(patch_tmp(:,3),1,3);
            patch_tmp = patch_tmp(:,1:2);
            
            p_vec = patch_tmp(:)-patch_init(:);
        end
    end
    disp(p_vec);
    patch_plot = region+reshape(p_vec,4,2);
    %visualize
    figure;
    imagesc(I), colormap(gray);
    hold on;
    patch_plot = [patch_plot;patch_plot(1,:)];
    plot(patch_plot(:,1),patch_plot(:,2));
    title(t);
    
end

