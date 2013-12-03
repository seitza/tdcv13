clear;
close all;
clc;

for data = 1:3

    load(['data' num2str(data) '.mat']);

    %dat = [-3,1,-1; -2,-1,-1; 0,5,-1; 1,8,-1; 3,6,-1; -1,3,1 ; -1,-2,1; 1,1,1; 4,-1,1; 4,7,1];
    %dat = [-3,1,-1; 0,1,-1; -2,-1,1];
    %dat = [-2,1,-1; -2,0,-1; 1,0,1; 1,1,1];
    %dat = [1,1,-1;1,2,1];
    %dat = [-3,1,-1; -2,-1,-1; 0,5,-1; 1,8,-1; 3,6,-1; 1,2,-1; 3,4,1; -1,3,1 ; -1,-2,1; 1,1,1; 4,-1,1; 4,7,1];
    %dat = [1,1,-1; 1,2,-1; 1,3,-1; -1,1,1; -1,2,1; -1,3,1];

    figure;
    scatter(dat(dat(:,3) == -1, 1), dat(dat(:,3) == -1, 2),'+b'); % plot negative samples red
    hold on;
    scatter(dat(dat(:,3) == 1, 1), dat(dat(:,3) == 1, 2),'+r'); % plot positive samples blue

    labels = dat(:,3);
    
    adaboost = AdaboostClassifier(20);
    adaboost.train(dat(:,1:2), labels);
    predicted_labels = adaboost.test(dat(:,1:2));

    % plot rows
    minX = min(dat(:,1));
    maxX = max(dat(:,1));
    minY = min(dat(:,2));
    maxY = max(dat(:,2));

    for i = 1:size(adaboost.weakClassifier,2)
        if adaboost.weakClassifier(i).dimensionThreshold == 2
            line([minX, maxX],[adaboost.weakClassifier(i).threshold, adaboost.weakClassifier(i).threshold]);
        else
            line([adaboost.weakClassifier(i).threshold, adaboost.weakClassifier(i).threshold], [minY, maxY]);
        end
    end

    scatter(dat(predicted_labels == -1, 1), dat(predicted_labels == -1, 2),'b');
    scatter(dat(predicted_labels == 1, 1), dat(predicted_labels == 1, 2),'r');

    adaboost.dispAdaboost();
    
    %plot error
    number_steps = 20;
    error = zeros(1, number_steps);
    for n = 1:number_steps
        adaboost = AdaboostClassifier(n);
        adaboost.train(dat(:,1:2), labels);
        predicted_labels = adaboost.test(dat(:,1:2));

        error(n) = sum(labels ~= predicted_labels);
    end
    xrange = 1:1:number_steps;
    figure;
    plot(xrange, error);
    
    
end

