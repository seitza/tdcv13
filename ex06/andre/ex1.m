close all;
clear;
clc;

%%

%dat = [-3,1,-1; -2,-1,-1; 0,5,-1; 1,8,-1; 3,6,-1; -1,3,1 ; -1,-2,1; 1,1,1; 4,-1,1; 4,7,1];

data = cell(3,1);
data{1} = 'data1.mat';
data{2} = 'data2.mat';
data{3} = 'data3.mat';

N = 300;

for d = 1:size(data,1);
    %laod
    load(data{d}); %generates dat
   
    %visualize
    figure;
    scatter(dat(dat(:,3)==-1,1),dat(dat(:,3)==-1,2),'Xr');
    hold on;
    scatter(dat(dat(:,3)==1,1),dat(dat(:,3)==1,2),'Xg');
    
    ada = AdaboostClassifier(N);
    ada.train(dat(:,[1,2]),dat(:,3));
    labels = ada.test(dat(:,[1,2]));
    %ada.dispClassifiers();
    
    scatter(dat(labels(:,1)==-1,1),dat(labels(:,1)==-1,2),'Or');
    scatter(dat(labels(:,1)==1,1),dat(labels(:,1)==1,2),'Og');
    
    for i = 1:size(ada.weakClassifier,1)
        if ada.weakClassifier{i}.dimensionThreshold == 1
            plot([ada.weakClassifier{i}.threshold ada.weakClassifier{i}.threshold],[100 -100])
        else
            plot([100 -100],[ada.weakClassifier{i}.threshold ada.weakClassifier{i}.threshold])
        end
    end
    
%     errorN = 10;
%     errors = zeros(errorN,2);
%     for n = 1:errorN
%         ada = AdaboostClassifier(N);
%         ada.train(dat(:,[1,2]),dat(:,3));
%         labels = ada.test(dat(:,[1,2]));
%         error = sum(dat(:,3)~=labels)/size(dat(:,3),1);
%         errors(n,:) = [n,error];
%     end
%     figure;
%     bar(errors(:,1),errors(:,2));
    
end