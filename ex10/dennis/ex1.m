clear all;
close all;
clc;

%% init
img = double(imread('lena.jpg'))/255.0;
img_gray = rgb2gray(img);

% let user define region
% roi = round(getrect);
roi = [120   121    29    23];

% extract patch
x = roi(1);
y = roi(2);
w = roi(3);
h = roi(4);

template = img_gray(y:y+h-1, x:x+w-1);
template_color = img(y:y+h-1, x:x+w-1,:);

w_half = floor(w/2);
h_half = floor(h/2);

xc = x + w_half;
yc = y + h_half;

%% try tracking
tic;
figure('Name', 'Tracking with SSD', 'NumberTitle', 'Off');
imagesc(img_gray), axis equal tight off, colormap gray
hold on;
plot_region([x, y, x+w-1, y+h-1], 'g');
plot(xc, yc, 'go');
[P_SSD,R_SSD] = track_template(img_gray, template, 'SSD');
plot(P_SSD(1), P_SSD(2), 'rx', 'MarkerSize', 10);
toc;

tic;
figure('Name', 'Tracking with NCC', 'NumberTitle', 'Off');
imagesc(img_gray), axis equal tight off, colormap gray
hold on;
plot_region([x, y, x+w-1, y+h-1], 'g');
plot(xc, yc, 'go');
[P_NCC,R_NCC] = track_template(img_gray, template, 'NCC');
plot(P_NCC(1), P_NCC(2), 'rx', 'MarkerSize', 12);
toc;

%% try color tracking
tic;
figure('Name', 'Tracking with SSD', 'NumberTitle', 'Off');
imagesc(img), axis equal tight off
hold on;
plot_region([x, y, x+w-1, y+h-1], 'g');
plot(xc, yc, 'go');
[P_SSD,R_SSD] = track_template_color(img, template_color, 'SSD');
plot(P_SSD(1), P_SSD(2), 'rx', 'MarkerSize', 10);
toc;

tic;
figure('Name', 'Tracking with NCC', 'NumberTitle', 'Off');
imagesc(img), axis equal tight off
hold on;
plot_region([x, y, x+w-1, y+h-1], 'g');
plot(xc, yc, 'go');
[P_NCC,R_NCC] = track_template_color(img, template_color, 'NCC');
plot(P_NCC(1), P_NCC(2), 'rx', 'MarkerSize', 12);
toc;



