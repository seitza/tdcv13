function [S] = load_img_sequence(path, filename_prefix, filename_suffix, start_idx)
    query = strcat(path, filesep, '*.', filename_suffix);
    nr_imgs = numel(dir(query));
    
    is_color_img = 0;
    
    for i=1:nr_imgs
        file_name = strcat(path, filesep, num2str(start_idx+i-1, filename_prefix), '.', filename_suffix);
        if i==1
            first_img = double(imread(file_name))/255.0;
            size_img = size(first_img);
            
            if numel(size_img) == 3
                is_color_img = 1;
                S= double(zeros([size_img nr_imgs]));
                S(:,:,:,i) = first_img;
            else
                S= double(zeros(size_img(1),size_img(2),nr_imgs));
                S(:,:,i) = first_img;
            end
        else
            if is_color_img == 1
                S(:,:,:,i) = double(imread(file_name))/255.0;
            else
                S(:,:,i) = double(imread(file_name))/255.0;
            end
        end
    end
end

