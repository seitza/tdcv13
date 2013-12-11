clear;
close all;
clc;

for data = 1:3

    load(['data' num2str(data) '.mat']);


    figure;
    scatter(dat(dat(:,3) == -1, 1), dat(dat(:,3) == -1, 2),'+b'); % plot negative samples red
    hold on;
    scatter(dat(dat(:,3) == 1, 1), dat(dat(:,3) == 1, 2),'+r'); % plot positive samples blue

    labels = dat(:,3);
    
    adaboost = AdaboostClassifier(300);
    adaboost.train(dat(:,1:2), labels);
    predicted_labels = adaboost.test(dat(:,1:2));

    % plot rows
    minX = min(dat(:,1));
    maxX = max(dat(:,1));
    minY = min(dat(:,2));
    maxY = max(dat(:,2));

    scatter(dat(predicted_labels == -1, 1), dat(predicted_labels == -1, 2),'b');
    scatter(dat(predicted_labels == 1, 1), dat(predicted_labels == 1, 2),'r');


    
end
