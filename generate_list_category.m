function generate_list_category(raw_img_root_dir, download_list_dir)
% function generate_list_category(root_dir) is to generate list txt file
%  for each category (sub directory) in  raw_img_root_dir
%  then for each category, create a txt file, save in download_list_dir


% default dirs
raw_img_root_dir = 'C:\workspace\program\image-annotation\benchmark-dataset\NUS-WIDE\raw_imgs';
download_list_dir = 'C:\workspace\program\image-annotation\benchmark-dataset\NUS-WIDE\download_list';


% find subdir in root_dir
dirnames = dir(raw_img_root_dir);
for i = 3:length(dirnames) %ignore the '.' and '..' subdirs
    if dirnames(i).isdir == 1
        % go into this subdir
        sub_dir = fullfile(raw_img_root_dir, dirnames(i).name);
        generate_txt_category(sub_dir, download_list_dir, dirnames(i).name);
    else
        fprintf('there is a file in %s, exception!\n', root_dir);
    end
end

fprintf('generate for %d categories finished!\n', length(dirnames)-2);


end


function generate_txt_category(sub_dir, download_list_dir, category_name)
% generate a txt file with each line an image path in sub_dir,
%   save in download_list_dir

%first create a category_name.txt file in download_list_dir
txtfile = sprintf('%s.txt', category_name);

fid_txtfile = fopen(fullfile(download_list_dir, txtfile), 'w');

filenames = dir(sub_dir);
for f = 3 : length(filenames)
    if filenames(f).isdir == 0
        if ~strcmp(filenames(f).name, 'Thumbs.db')
            filename_f = fullfile(sub_dir, filenames(f).name);
            fprintf(fid_txtfile, '%s\n', filename_f);
        else
            continue;
        end
        
    end
end

fclose(fid_txtfile);

end