clear;
clc;
close all;

%%
s=19;

I = double(rgb2gray(imread('face2.jpg')));
Ii = integral(I);

load('Classifiers.mat');
HF = HaarFeatures(classifiers(:,2:size(classifiers,2)));


scale_factor = 1.25;
scale_counter = 0;
maxX = 0;

figure;
%imagesc(I), hold on, colormap gray, axis equal tight;

while round(s) <= min(size(I));
    tmp = zeros(size(Ii));
    for i = 1:size(Ii,1)-round(s)+1
        for j = 1:size(Ii,2)-round(s)+1
           x = HF.HaarFeaturesCompute(Ii(i:i+round(s)-1,j:j+round(s)-1),scale_factor^scale_counter);
           tmp(i,j) = x;
           if(x > maxX)
              maxX = x;
              %close;
              %imagesc(I), colormap gray, axis equal tight, hold on;
              %plot([j; j; j+round(s); j+round(s); j],[i; i+round(s); i+round(s); i; i]);
              %drawnow();
           elseif(x == maxX)
              %plot([j; j; j+round(s); j+round(s); j],[i; i+round(s); i+round(s); i; i]);
           end

        end
    end
    figure;
    imagesc(tmp);
    s = s*scale_factor;
    scale_counter = scale_counter+1;
end

%plot([maxJ; maxJ; maxJ+maxS; maxJ+maxS; maxJ],[maxI; maxI+maxS; maxI+maxS; maxI; maxI]);

    



