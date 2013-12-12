function [ no ] = form_digits( no, total_length )
    no = num2str(no);
    while(length(no) < total_length)
       no = ['0' no];
    end
end