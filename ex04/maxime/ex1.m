point_reference = [1 2 4 8 9; 8 5 4 7 2; 1 1 1 1 1];
point_warped = [5 4 2 8 9; 5 1 2 4 8; 1 1 1 1 1];

n = size(point_reference,2);

H = normalized_dlt(point_reference, point_warped);

disp(H);
