function plot_region(region, color)
    min_x = region(1); min_y = region(2); max_x = region(3); max_y = region(4);
    
    corners = [min_x min_y;
               min_x max_y;
               max_x max_y;
               max_x min_y;
               min_x min_y;
              ];
    plot(corners(:,1), corners(:,2), 'Color', color);
end