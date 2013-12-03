%% init
clear all;
close all;
clc;

%% load datasets
nr_datasets = 3;
nr_weak_classifiers = 10;

datasets = cell(nr_datasets,1);
classifiers = cell(nr_datasets, 1);

for i=1:nr_datasets
    datasets{i} = load(strcat('data',int2str(i), '.mat'));
    datasets{i} = datasets{i}.dat;
end

%% visualize datasets
for i=1:nr_datasets
    figure('Name', strcat('Dataset nr. ', int2str(i)), 'NumberTitle', 'Off');
    positive_samples = datasets{i}(datasets{i}(:,3) == 1, :);
    negative_samples = datasets{i}(datasets{i}(:,3) == -1, :);

    % plot all positive samples in blue
    plot(positive_samples(:,1), positive_samples(:,2), 'b+', 'MarkerSize', 10);
    hold on;
    plot(negative_samples(:,1), negative_samples(:,2), 'ro', 'MarkerSize', 10);
end

%% train classifiers
for i=1:nr_datasets
    cur_dataset = datasets{i};
    classifiers{i} = AdaboostClassifier(nr_weak_classifiers);
    classifiers{i}.train(cur_dataset(:,1:2), cur_dataset(:,3));
end

%% show me what you got
for i=1:nr_datasets
    cur_dataset = datasets{i};
    cur_classifier = classifiers{i};
    classification = cur_classifier.test(cur_dataset(:,1:2));
    
    prediction = horzcat(cur_dataset(:,1:2), classification);
    
    positive_samples = prediction(prediction(:,3) == 1, :);
    negative_samples = prediction(prediction(:,3) == -1, :);
    
    figure('Name', strcat('Prediction of Dataset nr. ', int2str(i)), 'NumberTitle', 'Off');
    % plot all positive samples in blue
    plot(positive_samples(:,1), positive_samples(:,2), 'b+', 'MarkerSize', 10);
    hold on;
    plot(negative_samples(:,1), negative_samples(:,2), 'ro', 'MarkerSize', 10);
end