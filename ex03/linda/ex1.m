%% Exercise 1


I = imread('lena.gif');
I_double = double(I(:,:,1));

s0 = 1.5;
k = 1.2;
alpha = 0.04;
t = 1000000;

n = 0;
J0 = harris_detector(I_double, n, s0, k, alpha, t );

n = 5;
J5 = harris_detector(I_double, n, s0, k, alpha, t );

n = 17;
J17 = harris_detector(I_double, n, s0, k, alpha, t );

%% visualize
figure('Name', 'Harris Corner Detector', 'NumberTitle', 'off');
subplot(1,3,1);
%imagesc(imoverlay(I, J0, [1 0 0])), axis equal tight off;
imagesc(I), colormap gray, axis equal tight off;
hold on;
plot(J0(:,1), J0(:,2), 'r+');
title('n = 0');

subplot(1,3,2);
%imagesc(imoverlay(I, J5, [1 0 0])), axis equal tight off;
imagesc(I), colormap gray, axis equal tight off;
hold on;
plot(J5(:,1), J5(:,2), 'r+');
title('n = 5');

subplot(1,3,3);
%imagesc(imoverlay(I, J17, [1 0 0])), axis equal tight off;
imagesc(I), colormap gray, axis equal tight off;
hold on;
plot(J17(:,1), J17(:,2), 'r+');
title('n = 17');
