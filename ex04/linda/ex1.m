coords_reference = [1,1;2,4;3,3;4,1;6,2];
coords_warped = [7,3;8,6;9,5;10,3;12,6];

n = size(coords_reference,1);

coords_reference_with1 = [coords_reference, ones(n,1)];
coords_warped_with1 = [coords_warped, ones(n,1)];

H = normalized_dlt(coords_reference, coords_warped);

trans = (H*(coords_reference_with1'))';

%% visualize result

figure;
scatter3(coords_reference_with1(:,1), coords_reference_with1(:,2), coords_reference_with1(:,3), 50, 'b', 'fill');
hold on;
scatter3(coords_warped_with1(:,1), coords_warped_with1(:,2), coords_warped_with1(:,3), 50, 'g', 'fill');
scatter3(trans(:,1), trans(:,2), trans(:,3), 50, 'r', 'fill');



