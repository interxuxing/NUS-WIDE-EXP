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

%% set default parameters¡®
EXP_DIR = 'C:\workspace\program\image-annotation\benchmark-dataset\NUS-WIDE\NUS-WIDE-EXP';
file_valid_all = 'valid_raw_imgs.txt';
file_ori_train = 'TrainImagelist.txt';
file_ori_test = 'TestImagelist.txt';

file_valid_out = 'valid_train_test.txt';

if 0
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

for i = 1 : NUM_VALID_IMAGES
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
    if mod(i, 5000) == 0
        fprintf('searching %d th images over!\n',i);
    end
end


fclose(fid_valid_all);
fclose(fid_ori_train);
fclose(fid_ori_test);

end

%% now write the information to output file
% fid_valid_out = fopen(fullfile(EXP_DIR, file_valid_out), 'w');
% 
% for i = 1 : NUM_VALID_IMAGES
%     fprintf(fid_valid_out, '%s %d %d\n', valid_image_path{i}, is_train(i), index(i));
% end
% 
% fclose(fid_valid_out);


file_valid_out_train = 'valid_train_list.txt';
file_valid_out_test = 'valid_test_list.txt';

fid_valid_out_train = fopen(fullfile(EXP_DIR, file_valid_out_train), 'w');
fid_valid_out_test = fopen(fullfile(EXP_DIR, file_valid_out_test), 'w');

load('valid_out.mat');
index_train = find(valid_out_2 == 1);
% write train
for i = 1 : length(index_train)
    fprintf(fid_valid_out_train, '%s\n', valid_out_1{i});
end

index_test = find(valid_out_2 == 2)
for i = 1 : length(index_test)
    fprintf(fid_valid_out_test, '%s\n', valid_out_1{i});
end

fclose(fid_valid_out_train);
fclose(fid_valid_out_test);