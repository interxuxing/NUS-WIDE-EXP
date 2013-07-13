% function generate_valid_train_test_list(file_valid_all, file_ori_train, file_ori_test)
% is to reserve the valid image indexes in both original train / test .txt
% file.
% 
% for each file in file_valid_all
%   1, search it in file_ori_train, if found, return index
%   2, if not found, contine to search it in file_ori_test, if found,
%   return index
%   3, if still not found, throw exception
%
% the final output file_valid_out is formulate as
% image_path/trainortest/index
function generate_valid_train_test_list(file_valid_all, file_ori_train, file_ori_test, file_valid_out)

%% set default parameters
EXP_DIR = 'D:\workspace-limu\image-annotation\datasets\NUS-WIDE\download_list';
file_valid_all = 'valid_raw_imgs.txt';
file_ori_train = 'TrainImagelist.txt';
file_ori_test = 'TestImagelist.txt';


%% for each file in file_valid_all
fid_valid_all = fopen(fullfile(EXP_DIR, file_valid_all));
valid_all_info = textscan(fid_valid_all, '%s %s');
valid_image_path = valid_all_info{1};
valid_image_id = valid_all_info{2};


fid_ori_train = fopen(fullfile(EXP_DIR, file_ori_train));
ori_train_info = textscan(fid_ori_train, '%s');
ori_train_info = ori_train_info{1}; % Nx1 cell


fid_ori_test = fopen(fullfile(EXP_DIR, file_ori_test));
ori_test_info = textscan(fid_ori_test, '%s');
ori_test_info = ori_test_info{1}; % Nx1 cell

NUM_VALID_IMAGES = length(valid_image_id);
is_train = zeros(NUM_VALID_IMAGES, 1);
index = zeros(NUM_VALID_IMAGES, 1);

parfor i = 1 : NUM_VALID_IMAGES
    %first find in train
    res = strfind(ori_train_info, valid_image_id{i});
    ind = find(cellfun(@isempty, res) == 0);
    if ~isempty(ind)
        index(i) = ind;
        is_train(i) = 1;
    else % continue find in test
            res = strfind(ori_test_info, valid_image_id{i});
            ind = find(cellfun(@isempty, res) == 0);
            if ~isempty(ind)
                index(i) = ind;
                is_train(i) = 2;
            else
                fprintf('exception for current image %d!\n', i);
                pause;
            end
    end
    if mod(i, 1000) == 0
        fprintf('searching %d th images over!\n',i);
    end
end


fclose(fid_valid_all);
fclose(fid_ori_train);
fclose(fid_ori_test);


%% now write the information to output file

file_valid_out_train = 'valid_train_list.txt';
file_valid_out_test = 'valid_test_list.txt';

fid_valid_out_train = fopen(fullfile(EXP_DIR, file_valid_out_train), 'w');
fid_valid_out_test = fopen(fullfile(EXP_DIR, file_valid_out_test), 'w');

index_train = find(is_train == 1);
% write train
for i = 1 : length(index_train)
    fprintf(fid_valid_out_train, '%s\n', valid_image_path{index_train(i)});
end

index_test = find(is_train == 2);
for i = 1 : length(index_test)
    fprintf(fid_valid_out_test, '%s\n', valid_image_path{index_test(i)});
end

fclose(fid_valid_out_train);
fclose(fid_valid_out_test);