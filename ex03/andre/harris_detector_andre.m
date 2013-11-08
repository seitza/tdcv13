function [ R ] = harris_detector_andre( I_in, n, alpha, t , s0, k)

I = double(I_in);

if(nargin < 6)
    s0 = 1.5;
    k = 1.2;
end

sigma_In = s0*k^n;
sigma_Dn = 0.7*sigma_In;

[gauss_y_D,gauss_x_D] = gen_gaussian_1D(sigma_Dn);

I_g = conv2(conv2(I,gauss_x_D,'same'),gauss_y_D,'same');

diff_x = [[-1,-1,-1];[0,0,0];[1,1,1]];
diff_y = [[-1;-1;-1],[0;0;0],[1;1;1]];

I_dx = conv2(I_g,diff_x,'same');
I_dy = conv2(I_g,diff_y,'same');

I_x2 = I_dx.*I_dx;
I_y2 = I_dy.*I_dy;
I_xy = I_dx.*I_dy;

[gauss_y_I,gauss_x_I] = gen_gaussian_1D(sigma_In);

I_g_x2 = sigma_Dn^2.*conv2(conv2(I_x2,gauss_y_I,'same'),gauss_x_I,'same');
I_g_xy = sigma_Dn^2.*conv2(conv2(I_xy,gauss_y_I,'same'),gauss_x_I,'same');
I_g_y2 = sigma_Dn^2.*conv2(conv2(I_y2,gauss_y_I,'same'),gauss_x_I,'same');


for i = 1:size(I,1)
   for j = 1:size(I,2)
       M = [[I_g_x2(i,j),I_g_xy(i,j)];[I_g_xy(i,j),I_g_y2(i,j)]];
       R(i,j) = det(M)-alpha*(trace(M)^2);
   end
end

end

