close all;

S1 = [[1,1];[1,3];[3,1];[3,3];[5,5];[9,4];[4,9]];
S2 = [[1,1];[1,2];[3,1];[2,2];[7,7];[10,3];[3,10]];

t=3;
T=6;

[S1i,S2i,H] = ransac(S1,S2,t,T); %adaptively selected s and N
S1t = S1i*H';
S1n = S1t./repmat(S1t(:,3),1,3);
figure;
scatter(S2i(:,1),S2i(:,2),'Or');
hold on
scatter(S1n(:,1),S1n(:,2),'Xg');

s=4;
N=20;
[S1i,S2i,H] = ransac(S1,S2,t,T,s,N); %fixed s and N
S1t = S1i*H';
S1n = S1t./repmat(S1t(:,3),1,3);
figure;
scatter(S2i(:,1),S2i(:,2),'Or');
hold on
scatter(S1n(:,1),S1n(:,2),'Xg');
