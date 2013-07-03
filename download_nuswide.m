function download_nuswide()


%% This script is to download the raw image in NUS-WIDE dataset
%%  1, first parse the NUS-WIDE-urls.txt file, get the raw images' url 
%%      (big, medium, samll size), also the directory name
%%  2, for each image, first check url of middle size, then large size, then small size
%%      download order is: middle, large, small
%%      for save directory, create a directory according to the tag name, e.g.
%%      'C:\ImageData\Flickr\actor\0001_2124494179.jpg'
%%      in my pc, create a sub directory named 'actor', save image as '0001_2124494179.jpg'.
%%  3, chack the correcty of each image, since medium, big, small size url may be invalid (out of period),
%%      then remove these images and their indexes
%%
%%  code writed by Xing Xu, xing.xu@ieee.org, 3st, July, 2013
%%


clc; clear file_info;

%% step 1
if ~exist('NUS_WIDE_urls.mat','file')

urlfile = 'NUS-WIDE-urls.txt';
fid = fopen(urlfile);
file_info = textscan(fid, '%s %d64 %s %s %s %s');
fclose(fid);

org_imgs_urls.img_dir = file_info{1};
org_imgs_urls.img_id = file_info{2};
org_imgs_urls.img_url_large = file_info{3};
org_imgs_urls.img_url_middle = file_info{4};
org_imgs_urls.img_url_small = file_info{5};
org_imgs_urls.img_url_orignal = file_info{6};

save('NUS_WIDE_urls.mat','org_imgs_urls');

else
    load('NUS_WIDE_urls.mat');
end

%% step 2 and 3
Image_Num = length(org_imgs_urls.img_dir);
EXP_ROOT_DIR = 'C:\workspace\program\image-annotation\benchmark-dataset\NUS-WIDE';
RAW_IMG_DIR = fullfile(EXP_ROOT_DIR, 'raw_imgs');
if ~exist(RAW_IMG_DIR, 'dir')
    mkdir(RAW_IMG_DIR);
end

file_valid_raw_imgs_list = 'valid_raw_imgs.txt';
file_invalid_raw_imgs_list = 'invalid_raw_imgs.txt';
fid_valid = fopen(fullfile(pwd, file_valid_raw_imgs_list), 'w');
fid_invalid = fopen(fullfile(pwd, file_invalid_raw_imgs_list), 'w');


nuswide_error_img = 'nuswide_error.jpg';
error_img_info = imfinfo(fullfile(pwd,nuswide_error_img));



%loop to download each image, and check validation, then write to
%valid/invalid list

for i = 1 : Image_Num
    img_org_dir = org_imgs_urls.img_dir{i};
    [top_dir, class_name, jpg_name] = parse_dir(img_org_dir); 
    
    %create class directory if needed
    if ~exist(fullfile(RAW_IMG_DIR, class_name))
        mkdir(fullfile(RAW_IMG_DIR, class_name));
    end
    
    % download img in order
    isvalid = 1;
    dst_file = fullfile(RAW_IMG_DIR, class_name,jpg_name);
    if ~strcmp(org_imgs_urls.img_url_middle{i}, 'null')
        [f, status] = urlwrite(org_imgs_urls.img_url_middle{i}, dst_file);
    elseif ~strcmp(org_imgs_urls.img_url_large{i}, 'null')
        [f, status] = urlwrite(org_imgs_urls.img_url_large{i}, dst_file);
    elseif ~strcmp(org_imgs_urls.img_url_small{i}, 'null')
        [f, status] = urlwrite(org_imgs_urls.img_url_small{i}, dst_file);
    elseif ~strcmp(org_imgs_urls.img_url_orignal, 'null')
        [f, status] = urlwrite(org_imgs_urls.img_url_orignal{i}, dst_file);
    else
        isvalid = 0;
        %write to invalide list file
        fprintf(fid_invalid, '%s %s\n',dst_file, jpg_name);
    end
       
    if isvalid == 1
         % after download, check its validation
        dst_file_info = imfinfo(dst_file);
        if (dst_file_info.FileSize == error_img_info.FileSize) && ...
                (dst_file_info.Width == error_img_info.Width) && ...
                (dst_file_info.Height == error_img_info.Height)
            isvalid = 0;
            delete(dst_file);
            %write to invalide list file
            fprintf(fid_invalid, '%s %s\n',dst_file, jpg_name);
            fprintf('%d %d %s\n',i, isvalid, jpg_name);
        end
        %write to valid list file
        fprintf(fid_valid, '%s %s\n',dst_file, jpg_name);
        fprintf('%d %d %s\n',i, isvalid, jpg_name);
    else
        fprintf('%d %d %s\n',i, isvalid, jpg_name);
    end
    
    if mod(i, 100) == 0
        fprintf('finished download %d-th image. \n', i);
    end
end

fclose(fid_valid);
fclose(fid_invalid);

end


function [top_dir, class_name, jpg_name] = parse_dir(original_dir)
% orginal_dir should be in format as: C:\ImageData\Flickr\actor\0001_2124494179.jpg
indexes = strfind(original_dir, '\'); %indexes should have 4 elements

if ~isempty(indexes)
    % jpg_name
    jpg_name = original_dir(indexes(4)+1 : end); %0001_2124494179.jpg
    % class_name
    class_name = original_dir(indexes(3)+1 : indexes(4)-1); %actor
    % top_dir
    top_dir = original_dir(1:indexes(3)); %C:\ImageData\Flickr\actor\
else
    lasterr
    return; 
end


end