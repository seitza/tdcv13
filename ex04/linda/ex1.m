coords_reference = [1,1;2,4;3,3;4,1;6,2];
coords_warped = [7,3;8,6;9,5;10,3;12,6];

%coords_reference = [ 139   434   599   332    22   340     4    42   438   596   336   421;
%               23   326   185   400    25   323   183   202   282   405    43   200]';

          
%coords_warped = [ 365   501   606   435    30   457    92   177   516   540   559   533;
%   322   347   454   280    80   307    23    92   365   374   449   391]';

n = size(coords_reference,1);

coords_reference_with1 = [coords_reference, ones(n,1)];
coords_warped_with1 = [coords_warped, ones(n,1)];

H = normalized_dlt(coords_reference, coords_warped);

trans = (H*(coords_reference_with1'))';
trans_2d = trans./ repmat( trans(:,3), 1, 3 );

%% visualize result

figure;
scatter3(coords_reference_with1(:,1), coords_reference_with1(:,2), coords_reference_with1(:,3), 50, 'b', 'fill');
hold on;
scatter3(coords_warped_with1(:,1), coords_warped_with1(:,2), coords_warped_with1(:,3), 50, 'g', 'fill');
scatter3(trans_2d(:,1), trans_2d(:,2), trans_2d(:,3), 50, 'r', 'fill');



