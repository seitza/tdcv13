%% include sift stuff
run('../../../vlfeat-0.9.17/toolbox/vl_setup.m');

%% clean workspace
close all;
clear;
clc;

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
imagesc(I0), colormap(gray), axis equal tight off;
h = impoly;
pos = wait(h);
pos = pos';
in = inpolygon(f0(1,:),f0(2,:),[pos(1,:),pos(1,1)],[pos(2,:),pos(2,1)]);
m0 = f0(:,in);

imagesc(I0), colormap gray, axis equal tight off;
hold on;
plot(m0(1,:),m0(2,:),'Xg')
drawnow();

%calculate in 3D
m0 = [m0((1:2),:);ones(1,size(m0,2))];
M0 = A\m0;

%% tracking SIFT points EX02
for t = 1:44
   It = single(rgb2gray(imread(strcat('img_sequence/00',num2str(t,'%02d'),'.png'))));
   [mt,dt] = vl_sift(It);
   
   %match descriptors
   matches = vl_ubcmatch(d0(:,in),dt);
   
   [tform,in0,int] = estimateGeometricTransform(m0(1:2,matches(1,:))',mt(1:2,matches(2,:))','affine',...
      'MaxNumTrials',2000,...
      'MaxDistance',8);
   
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

%%