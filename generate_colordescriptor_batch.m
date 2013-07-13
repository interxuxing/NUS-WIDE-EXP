function generate_colordescriptor_batch(config_file, feature_type, detector_type)
% function generate_colordescriptor_batch(batch_file, output_dir)
%   This function is to extract descriptors for each image in batch_file in
%       a batch mode;
%   descriptor file for each image is in binary format, and will be saved
%   in output_dir;
%
%   We will use colorDescriptor tool to generate descriptors
eval(config_file);

if~exist(OUTPUT_DIR_DESCRIPTOR_BATCH, 'dir')
    mkdir(OUTPUT_DIR_DESCRIPTOR_BATCH);
end

if 0
    
%default output_dir
batch_file = 'valid_raw_imgs.txt';

%formulate the command line
batch_file_name = fullfile(BATCHFILE_DIR, batch_file);

%get category name
index = strfind(batch_file, '.txt');
if isempty(index)
    lasterr
    fprintf('format error: no .txt file!\n');
    return;
end


%% 1, read valid_raw_imgs.txt file, get valid raw images list
%   then random select 10k images, get the images'path list
fid_valid_list = fopen(batch_file_name);
file_info = textscan(fid_valid_list, '%s %s');
valid_list = file_info{1};
% randomly select K samples
K = 10e+3;
random_indexes = randperm(length(valid_list));
valid_random_list = valid_list(random_indexes(1:K));

fid_valid_list_random = fopen(fullfile(batch_file_dir, 'valid_list_random.txt'),'w'); 
for i = 1 : K
    fprintf(fid_valid_list_random, '%s\n', valid_random_list{i});
end
fclose(fid_valid_list_random);

end

%% 2, use the valid_list_random to generate feature descriptors for each random sampled
%       images, then save in the randomshuffle dir
batch_file_random_list = fullfile(BATCHFILE_DIR, 'valid_list_random.txt');

name_feature = Feature_Type{feature_type};
name_detector = Detector{detector_type};

switch detector_type
    case 1
         fprintf('detector type is %s \n', name_detector);
        command_line = ['colorDescriptor.exe --batch ', batch_file_random_list,...
    ' --detector densesampling --ds_spacing 20 --descriptor ', name_feature...
    ' --outputFormat binary', ' --output ', OUTPUT_DIR_DESCRIPTOR_BATCH]; 

    case 2      
        fprintf('detector type is %s \n', name_detector);
        command_line = ['colorDescriptor.exe --batch ', batch_file_random_list,...
    ' --detector harrislaplace --harrisThreshold 1e-6 --descriptor ', name_feature...
    ' --outputFormat binary', ' --output ', OUTPUT_DIR_DESCRIPTOR_BATCH]; 
    otherwise
        disp('wrong detector type!');
        return;
end

%excute the feature descriptor extraction commandline
system(command_line);


