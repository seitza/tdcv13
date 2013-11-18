S1 = [[1,1];[1,3];[3,1];[3,3];[5,5];[9,4];[4,9]];
S2 = [[1,1];[1,2];[3,1];[2,2];[7,7];[10,3];[3,10]];

s=4;
t=3;
T=6;
N=20;

%% normal ransac
H_ransac = ransac(S1, S2, s, N, t, T);

%% adaptively ransac

H_adapt = ransac_adaptively(S1, S2, s, t);
%disp(H_adapt);

