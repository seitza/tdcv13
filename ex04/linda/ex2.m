S1 = [[1,1];[1,3];[3,1];[3,3];[5,5];[9,4];[4,9]];
S2 = [[1,1];[1,2];[3,1];[2,2];[7,7];[10,3];[3,10]];

S1_dennis = [S1'; ones(1,7)];
S2_dennis = [S2'; ones(1,7)];

% S1 = [[1,1];[1,3];[3,1];[3,3]];
% S2 = [[1,1];[1,2];[3,1];[2,2]];
% 
% S1_dennis = [S1'; ones(1,4)];
% S2_dennis = [S2'; ones(1,4)];

s=4;
t=3;
T=6;
N=20;

%% normal ransac dennis
% H_ransac = ransac_dennis(S1_dennis, S2_dennis, s, N, t, T);
% disp(H_ransac);

%% normal ransac
H_ransac = ransac(S1, S2, s, N, t, T);
disp(H_ransac);

%% adaptively ransac
H_adapt = ransac_adaptively(S1, S2, s, t);
disp(H_adapt);

