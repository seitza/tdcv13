% load our precomputed data
load('correct_point_correspondences');
load('img_sequence.mat');
load('results_ex1.mat');

% init parameters
R0 = [0, 0, 0];
T0 = [0, 0, 0];

A = [472.3 0.64 329.0;
     0 471.0 268.3;
     0  0   1];

nr_images = size(img_seq,3);

%% my solution
Rt = zeros(1,3, nr_images);
Tt = zeros(1,3, nr_images);
Rt(:,:,1) =  R0;
Tt(:,:,1) = T0;

Ct_dennis = zeros(3,nr_images);
Ct_dennis(:,1) = zeros(3,1);

for i=2:nr_images
    cur_RT = [Rt(:,:,i-1),Tt(:,:,i-1)];
    
    cur_m = m_ti{i}';
    cur_m = vertcat(cur_m, ones(1,size(cur_m,2)));

    % we have to compute the correct 3D-points from the inliers
    % for this image in m_t0
    cur_m0 = m_t0_inliers{i}';
    cur_m0 = vertcat(cur_m0, ones(1,size(cur_m0,2)));
    cur_M = A\cur_m0;
    cur_M = vertcat(cur_M, ones(1,size(cur_M,2)));
    
    estimatedRT = fminsearch(@(cur_RT) energy_function(A,cur_RT,cur_M,cur_m), cur_RT);
    
    estimatedAngles = estimatedRT(1:3);
    Rt(:,:,i) = estimatedAngles;
    estimatedR = create_rotation_matrix(estimatedAngles);
    
    estimatedT = estimatedRT(4:end);
    Tt(:,:,i) = estimatedT;
    Ct_dennis(:,i) = -estimatedR'*estimatedT';
end


%% andres solution
NUM_PIC = nr_images-1;
ra = 0; rb = 0; rc = 0;
t1 = 0; t2 = 0; t3 = 0;
RT = [ra,rb,rc,t1,t2,t3];

pose = zeros(NUM_PIC+1,6);
pose(1,:) = RT;
pos = zeros(NUM_PIC+1,3);
for i = 1:NUM_PIC
    mt = m_ti{i}';
    mt = [mt((1:2),:);ones(1,size(mt,2))];
    template = m_t0_inliers{i}';
    template = [template((1:2),:);ones(1,size(template,2))];
    templ = A\template;
    templ = [templ;ones(1,size(templ,2))];
    RT = fminsearch(@(RT) energy(A,RT,templ,mt),RT);
    pose(i+1,:) = RT;
    
    R = rotation(RT(1),RT(2),RT(3));
    P = -R'*[RT(4);RT(5);RT(6)];
    pos(i+1,:) = P';
end