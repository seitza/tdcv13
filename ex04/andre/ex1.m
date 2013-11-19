close all;

%p2 = [[1,8];[2,5];[4,4];[8,7];[9,2]];
%p1 = [[5,5];[4,1];[2,2];[8,4];[9,8]];

p1 = [[1,1];[5,5];[1,5];[5,1]];
p2 = [[1,1];[5,4];[1,5];[5,2]];

figure;
scatter(p1(:,1),p1(:,2),'Xr');
xlim([-10 10]);
ylim([-10 10]);
hold on;
scatter(p2(:,1),p2(:,2),'Og');

[H,pe1,pe2] = normalized_dlt(p1,p2);
hp = (H*pe1')';

hpn = hp./repmat(hp(:,3),1,3)
scatter(hpn(:,1),hpn(:,2),'Ob','filled');

