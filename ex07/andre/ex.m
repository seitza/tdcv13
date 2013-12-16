%% include sift stuff
run('../../../vlfeat-0.9.17/toolbox/vl_setup.m');

%% clean workspace
close all;
clear;
clc;

%% init param
NUM_PIC = 44;

%% initialize tracking EX01
R = diag([1,1,1]);
T = 0;
A = [[472.3,0.64,329.0];[0,471.0,268.3];[0,0,1]];

I0 = single(rgb2gray(imread('img_sequence/0000.png')));

%calc sift
%f: y,x,scale,orientation
%d: descriptors
[f0,d0] = vl_sift(I0);

%get region of interest
% imagesc(I0), colormap(gray), axis equal tight off;
% h = impoly;
% pos = wait(h);
% pos = pos';
% in = inpolygon(f0(1,:),f0(2,:),[pos(1,:),pos(1,1)],[pos(2,:),pos(2,1)]);
% m0 = f0(:,in);


%BEGIN LINDA from linda
% corners of the image figure
 boundary = [103, 75;
             550, 75;
             105, 385;
             553, 385];
         
min_x = min(boundary(:,1));
max_x = max(boundary(:,1));
min_y = min(boundary(:,2));
max_y = max(boundary(:,2));

% discard features that are not within the area of the object
in = f0(1,:) > min_x & f0(1,:) <= max_x & ...
             f0(2,:) > min_y & f0(2,:) <= max_y;

m0 = f0(:, in);
%END LINDA

imagesc(I0), colormap gray, axis equal tight off;
hold on;
plot(m0(1,:),m0(2,:),'Xg')
drawnow();

%calculate in 3D
m0 = [m0((1:2),:);ones(1,size(m0,2))];
M0 = A\m0;
M0 = [M0;ones(1,size(M0,2))];

%% tracking SIFT points EX02
target_in = cell(NUM_PIC,1);
template_in = cell(NUM_PIC,1);

for t = 1:NUM_PIC
   It = single(rgb2gray(imread(strcat('img_sequence/00',num2str(t,'%02d'),'.png'))));
   [mt,dt] = vl_sift(It);
   
   %match descriptors
   matches = vl_ubcmatch(d0(:,in),dt);
   
   [tform,in0,int] = estimateGeometricTransform(m0(1:2,matches(1,:))',mt(1:2,matches(2,:))','affine',...
      'MaxNumTrials',2000,...
      'MaxDistance',8);
   
   template_in{t} = in0;
   target_in{t} = int;
  
   pair = [I0,It];
   figure;
   imagesc(pair), colormap gray, axis equal tight off;
   hold on;
   offset = size(I0,2);
   for i = 1:size(in0,1)
      plot([in0(i,1),offset+int(i,1)],[in0(i,2),int(i,2)]);
      plot([in0(i,1),offset+int(i,1)],[in0(i,2),int(i,2)],'Xg');
   end
   
end

%% EX03
%M0 already given
%m0 already given

%camera pose for t=0 initialized by r = 0, t = 0
ra = 0; rb = 0; rc = 0;
t1 = 0; t2 = 0; t3 = 0;
RT = [ra,rb,rc,t1,t2,t3];

pose = zeros(NUM_PIC+1,6);
pose(1,:) = RT;
pos = zeros(NUM_PIC+1,3);
for i = 1:NUM_PIC
    mt = target_in{i}';
    mt = [mt((1:2),:);ones(1,size(mt,2))];
    template = template_in{i}';
    template = [template((1:2),:);ones(1,size(template,2))];
    templ = A\template;
    templ = [templ;ones(1,size(templ,2))];
    RT = fminsearch(@(RT) energy(A,RT,templ,mt),RT);
    pose(i+1,:) = RT;
    
    R = rotation(RT(1),RT(2),RT(3));
    P = -R'*[RT(4);RT(5);RT(6)];
    pos(i+1,:) = P';
end

figure;
plot3(pos(:,1),pos(:,2),pos(:,3));
hold on;
text(pos(:,1),pos(:,2),pos(:,3),num2str((0:44)'));
plot3(0,0,0,'Xr');
grid on;
