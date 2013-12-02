% take the dataset from the slides
% clear;
close all;
clc;

data = [1 3;
        1.5 1.5;
        2 0.5;
        2.25 1.7;
        2.4 2.5;
        3   2.75;
        3   1.8;
        3.5 2.6;
        4   2.8;
        4   1.5];
    
labels = [1 1 -1 -1 1 1 -1 1 -1 -1]';

%% initial weights
weights = ones(size(labels,1),1)/size(labels,1);

%% train classifier
wc = weakClassifier;
wc.train(data, labels, weights);

%% plot
data_set = horzcat(data,labels);

positive_set = data_set(data_set(:,3) == 1, :);
negative_set = data_set(data_set(:,3) == -1, :);

figure;
plot(positive_set(:,1), positive_set(:,2), 'b+', 'MarkerSize', 10);
hold on;
plot(negative_set(:,1), negative_set(:,2), 'ro', 'MarkerSize', 10);
xlim([0 5]);
ylim([0 3.5]);

if wc.dimension_threshold == 1
    line([wc.threshold wc.threshold], [0 3.5]);
elseif wc.dimension_threshold == 2
    line([0 5], [wc.threshold wc.threshold]);
end


    
