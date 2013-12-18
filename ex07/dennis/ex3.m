% exercise 3
% clear all;
close all;
clc;

% internal calibration matrix
A = [472.3 0.64 329.0;
     0 471.0 268.3;
     0  0   1];
 
% load results from exercise 1 and 2
load('results_ex1.mat');
load('correct_point_correspondences.mat');

% this will contain the 3D-points
% nr_images = size(m_ti,1);
nr_images = 14;
M = cell(nr_images,1);
% make sure the points correspondences are in homogenous coordinates
for i=1:nr_images
    cur_m = m_ti{i,1};
    if size(cur_m,1) < 3
        m_ti{i,1} = vertcat(cur_m,ones(1,size(cur_m,2)));
    end
end

if size(M_twiddle_t0,1) < 4
    M_twiddle_t0 = vertcat(M_twiddle_t0,ones(1,size(M_twiddle_t0,2)));
end

M{1} = M_twiddle_t0;

% Rt = zeros(1,3,nr_images);
% % initial rotation is all zeros
% Rt(:,:,1) = [0, 0, 0];

% test rodrigues parametrization
Rt_rodrigues = zeros(1,4,nr_images);
Rt_rodrigues = [0, 0, 0, 0];

% initial translation is all zeros
Tt = zeros(1,3,nr_images);
Tt(:,:,1) = [0, 0, 0];

% camera in world coordinates
Ct = zeros(3,nr_images);
Ct(:,1) = zeros(3,1);

% estimate the pose parameters
for i=2:nr_images
    cur_RT = [Rt_rodrigues(:,:,i-1),Tt(:,:,i-1)];
%     cur_RT = [Rt(:,:,i-1),Tt(:,:,i-1)];
    
    cur_m = m_ti{i}';
    cur_m = vertcat(cur_m, ones(1,size(cur_m,2)));

    % we have to compute the correct 3D-points from the inliers
    % for this image in m_t0
    cur_m0 = m_t0_inliers{i}';
    cur_m0 = vertcat(cur_m0, ones(1,size(cur_m0,2)));
    cur_M = A\cur_m0;
    cur_M = vertcat(cur_M, ones(1,size(cur_M,2)));
    
    [estimatedRT, fval] = fminsearch(@(cur_RT) energy_function_rodrigues(A,cur_RT,cur_M,cur_m), cur_RT, ...
                                     optimset('MaxFunEvals', 50000000, ...
                                              'MaxIter', 500000));
%     [estimatedRT, fval] = fminsearch(@(cur_RT) energy_function(A,cur_RT,cur_M,cur_m), cur_RT, ...
%                                      optimset('MaxFunEvals', 50000000, ...
%                                               'MaxIter', 500000));
    disp(fval);
    estimated_r = estimatedRT(1:3);
    estimated_theta = estimatedRT(4);
    Rt_rodrigues(:,:,i) = [estimated_r, estimated_theta];
    estimatedR = create_rodrigues_rotation_matrix(estimated_r, estimated_theta);
%     estimated_Angles = estimatedRT(1:3);
%     Rt(:,:,i) = estimated_Angles;
%     estimatedR = create_rotation_matrix(estimated_Angles);    
    
    estimatedT = estimatedRT(5:end);
    Tt(:,:,i) = estimatedT;
    Ct(:,i) = -estimatedR'*estimatedT';
end

%% draw our estimated camera-positions
figure('Name', 'Estimated camera coordinates', 'NumberTitle', 'Off');
plot3(Ct(1,:), Ct(2,:), Ct(3,:), 'bx-');
hold on;
text(Ct(1,:),Ct(2,:),Ct(3,:),num2str((0:nr_images-1)'));
plot3(0,0,0,'or', 'MarkerSize', 12);
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');

