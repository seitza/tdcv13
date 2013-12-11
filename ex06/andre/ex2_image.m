clear;
clc;
close all;

%%
s=19;
sigma = 1;

for f = {'face1.jpg','face2.jpg','face3.jpg'}
    
    figure;
    I = double(rgb2gray(imread(f{1})));
    
    load('Classifiers.mat');
    HF = HaarFeatures(classifiers(:,2:size(classifiers,2)));
    
    maxX = 0;
    
    It = I;
    while s <= min(size(It));
        %figure;
        %imagesc(It), hold on, colormap gray, axis equal tight;
        
        Ii = integral(It);
        tmp = zeros(size(Ii));
        for i = 1:size(Ii,1)-s+1
            for j = 1:size(Ii,2)-s+1
                x = HF.HaarFeaturesCompute(Ii(i:i+s-1,j:j+s-1),1);
                tmp(i,j) = x;
                if(x > maxX)
                    maxX = x;
                    close;
                    figure;
                    imagesc(It), colormap gray, axis equal tight, hold on;
                    plot([j; j; j+round(s); j+round(s); j],[i; i+round(s); i+round(s); i; i]);
                    %drawnow();
                elseif(x == maxX)
                    plot([j; j; j+round(s); j+round(s); j],[i; i+round(s); i+round(s); i; i]);
                end
                
            end
        end
        %figure;
        %imagesc(tmp);
        It = imfilter(It,fspecial('gaussian',floor(3.7*sigma),sigma));
        It = It(1:2:size(It,1),1:2:size(It,2));
    end
    
    %plot([maxJ; maxJ; maxJ+maxS; maxJ+maxS; maxJ],[maxI; maxI+maxS; maxI+maxS; maxI; maxI]);
    
    
end
    
    
