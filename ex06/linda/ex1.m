load data3.mat

figure;
scatter(dat(dat(:,3) == -1, 1), dat(dat(:,3) == -1, 2),'+r'); % plot negative samples red
hold on;
scatter(dat(dat(:,3) == 1, 1), dat(dat(:,3) == 1, 2),'+b'); % plot positive samples blue

adaboost = AdaboostClassifier(10);
adaboost.train(dat(:,1:2), dat(:,3));
labels = adaboost.test(dat(:,1:2));

scatter(dat(labels == -1, 1), dat(labels == -1, 2),'r');
scatter(dat(labels == 1, 1), dat(labels == 1, 2),'b');

