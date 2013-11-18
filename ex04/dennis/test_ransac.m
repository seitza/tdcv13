% tests ransac for 2d
close all;
clc;

% creates some data for n=30;
n = 100;
t = 0.3;

x_values = -5 + 15*rand(n,1);

% create y_values
y_values = x_values(:)*0.35 + 2.5 + 0.25*randn(n,1);

% create some outliers
outliers_index = randi(n, 5, 1);
y_values(outliers_index) = y_values(outliers_index) + (10 + 5*randn(1,1));
points = [x_values'; y_values'];

figure;
plot(points(1,:), points(2,:), 'xr');
hold on;

% try RANSAC algorithm with line-implementation
H = ransac_line(points, [], 2, 0.2, 30, 15);