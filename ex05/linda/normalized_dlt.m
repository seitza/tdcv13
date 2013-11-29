function [ H ] = normalized_dlt( coords_reference, coords_warped )

    n = size(coords_reference,1);
    
    %disp(coords_reference);
    
    % normalization of thw points
    % compute center
    center_reference = [sum(coords_reference(:,1))/n, sum(coords_reference(:,2))/n];
    center_warped = [sum(coords_warped(:,1))/n, sum(coords_warped(:,2))/n];
    % translation, so that center is at the origin
    centered_reference = [coords_reference(:,1)-center_reference(1),coords_reference(:,2)-center_reference(2)];
    centered_warped = [coords_warped(:,1)-center_warped(1),coords_warped(:,2)-center_warped(2)];
    % sclaing to an average distance of sqrt(2)
    %disp(centered_reference);
    %disp((sum(sqrt(sum((centered_reference.^2),2)))));
    s = sqrt(2)*n/(sum(sqrt(sum((centered_reference.^2),2))));
    scaled_reference = centered_reference.*s;
    U = [s,0,0;0,s,0;0,0,1]*[1,0,-center_reference(1);0,1, -center_reference(2); 0,0,1];
    s = sqrt(2)*n/(sum(sqrt(sum((centered_warped.^2),2))));
    scaled_warped = centered_warped.*s;
    T = [s,0,0;0,s,0;0,0,1]*[1,0,-center_warped(1);0,1, -center_warped(2); 0,0,1];
    
    % compute dlt of scales coordinates
    Hsnake = dlt([scaled_reference,ones(n,1)], [scaled_warped,ones(n,1)]);
    H = inv(T)*Hsnake*U;

    %r = H*[coords_reference, ones(n,1)]';
end

