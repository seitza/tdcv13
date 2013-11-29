close all;
clear;
clc;

%%

data = cell(3,1);
data{1} = 'data1.mat';
data{2} = 'data2.mat';
data{3} = 'data3.mat';

N = 10;

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
    
end