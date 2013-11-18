% This file tests the normalized_dlt function
clear all
clc;
close all;

ref_points = [ 139   434   599   332    22   340     4    42   438   596   336   421;
               23   326   185   400    25   323   183   202   282   405    43   200;
               1     1     1     1     1     1     1     1     1     1     1     1];

          
warped_points = [ 365   501   606   435    30   457    92   177   516   540   559   533;
   322   347   454   280    80   307    23    92   365   374   449   391;
     1     1     1     1     1     1     1     1     1     1     1     1];
              
H = normalized_dlt(ref_points, warped_points);
disp(H);
predicted_warped_points = H*ref_points;
predicted_warped_points = predicted_warped_points ./ repmat( predicted_warped_points(3,:), 3, 1 );

disp(warped_points);
disp(predicted_warped_points);
