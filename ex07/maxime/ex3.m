clear all;
close all;
clc;

% Setup sift path
if exist('vl_version') == 0
    disp('loading sift implementation...');
    run('/Users/Pitou/Documents/München/DTCV/Exercises/Ex7/vlfeat-0.9.17/toolbox/vl_setup.m');
end

% Value
load('ex2_result');
load('ex1_result');

ra = 0; rb = 0; rc = 0;
t1 = 0; t2 = 0; t3 = 0;
RT = [ra,rb,rc,t1,t2,t3];

for i=1:44
    param = fminsearch(@(RT) energy(A,RT,M0,ft),RT);
    R = RT(1)*RT(2)*RT(3);
    T=[t1;t2;t3];
    camera(t+1, :) = (-R'*T)';
end

figure;
plot3(camera(:,1), camera(:,2), camera(:,3));
hold on;
text(camera(:,1), camera(:,2), camera(:,3), num2str((0:44)'));
plot3(0,0,0,'Xr');
plot3(camera(44,1), camera(44,2), camera(44,3), 'r+');
grid on;
xlabel('x');
ylabel('y');
zlabel('z');

