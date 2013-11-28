function [ J ] = harris_detector( I_in, n, alpha, t , s0, k)
%s0, k can be ignored, as it is set by default

I = double(I_in);

if(nargin < 6)
    s0 = 1.5;
    k = 1.2;
end

%calculate sigma from input parameters
sigma_In = s0*k^n;
sigma_Dn = 0.7*sigma_In;

[gauss_y_D,gauss_x_D] = gen_gaussian_1D(sigma_Dn);

%use gaussian convolution on input image
I_g = conv2(conv2(I,gauss_x_D,'same'),gauss_y_D,'same');

diff_x = [[-1,-1,-1];[0,0,0];[1,1,1]];
diff_y = [[-1;-1;-1],[0;0;0],[1;1;1]];

%find derivatives of convoluted input image
I_dx = conv2(I_g,diff_x,'same');
I_dy = conv2(I_g,diff_y,'same');

%multiply derivatives
I_x2 = I_dx.*I_dx;
I_y2 = I_dy.*I_dy;
I_xy = I_dx.*I_dy;

[gauss_y_I,gauss_x_I] = gen_gaussian_1D(sigma_In);

%convolute 
I_g_x2 = sigma_Dn^2.*conv2(conv2(I_x2,gauss_y_I,'same'),gauss_x_I,'same');
I_g_xy = sigma_Dn^2.*conv2(conv2(I_xy,gauss_y_I,'same'),gauss_x_I,'same');
I_g_y2 = sigma_Dn^2.*conv2(conv2(I_y2,gauss_y_I,'same'),gauss_x_I,'same');


for i = 1:size(I,1)
   for j = 1:size(I,2)
       M = [[I_g_x2(i,j),I_g_xy(i,j)];[I_g_xy(i,j),I_g_y2(i,j)]];
       R(i,j) = det(M)-alpha*(trace(M)^2);
   end
end

R(R<t) = 0;

% find local maximums in R and mark them in J
%copied from linda
neighbor_size = 3;
half_size = (neighbor_size-1)/2;
J = [0,0];

for i = half_size+1:size(I,1)-half_size
    for j = half_size+1:size(I,2)-half_size
        maximum = 1;
        for m = i-half_size:i+half_size
            for n = j-half_size:j+half_size
                if i == m && j == n
                    continue;
                elseif R(m,n) >= R(i,j)
                    maximum = 0;
                end
            end
        end
        if maximum == 1
            J=vertcat(J,[j,i]);
        end
    end
end
J = J(2:size(J,1),:)';

end

