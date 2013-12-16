clc; clear; close all;

%% ex3

load('ex2_results');

parameters = zeros(num_images,6);
camera_coord = zeros(num_images,3);

for t = 1:num_images-1
    % compute parameters of R and T
    mt = [correspondences{1,t}(:, 3:4), ones(size(correspondences{1,t}, 1),1)]';
    m0 = [correspondences{1,t}(:, 1:2), ones(size(correspondences{1,t}, 1),1)]';
    M0 = A\m0;
    M0 = [M0; ones(1, size(M0, 2))];
    parameters(t+1, :) = fminsearch(@(rt) energy_function(A, rt, M0, mt), parameters(t,:));
    % compute camera coordinates
    % create R using the Euler representation
    ra = parameters(t+1,1); rb = parameters(t+1,2); rg = parameters(t+1,3);
    t1 = parameters(t+1,4); t2 = parameters(t+1,5); t3 = parameters(t+1,6);
    Ra = [cos(ra), -sin(ra), 0; sin(ra), cos(ra), 0; 0,0,1];
    Rb = [cos(rb), 0, sin(rb); 0,1,0; -sin(rb), 0, cos(rb)];
    Rg = [1,0,0; 0, cos(rg), -sin(rg); 0, sin(rg), cos(rg)];
    
    R = Ra*Rb*Rg;
    T = [t1;t2;t3];

    camera_coord(t+1, :) = (-R'*T)';
end

% plot camera coordinates
figure;
plot3(camera_coord(:,1), camera_coord(:,2), camera_coord(:,3));
hold on;
text(camera_coord(:,1), camera_coord(:,2), camera_coord(:,3), num2str((0:44)'));
plot3(0,0,0,'Xr');
plot3(camera_coord(num_images,1), camera_coord(num_images,2), camera_coord(num_images,3), 'Xg');
grid on;
