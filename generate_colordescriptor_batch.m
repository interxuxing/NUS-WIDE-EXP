function generate_colordescriptor_batch(batch_file_dir, batch_file, output_dir)
% function generate_colordescriptor_batch(batch_file, output_dir)
%   This function is to extract descriptors for each image in batch_file in
%       a batch mode;
%   descriptor file for each image is in binary format, and will be saved
%   in output_dir;
%
%   We will use colorDescriptor tool to generate descriptors


%default output_dir
output_dir = 'C:\workspace\program\image-annotation\benchmark-dataset\NUS-WIDE\descriptors';
run_dir = pwd;
batch_file_dir = 'C:\workspace\program\image-annotation\benchmark-dataset\NUS-WIDE\download_list';
descriptor_type = ' opponentsift';

batch_file = 'adobehouses.txt';

%formulate the command line
batch_file_name = fullfile(batch_file_dir, batch_file);

%get category name
index = strfind(batch_file, '.txt');
if isempty(index)
    lasterr
    fprintf('format error: no .txt file!\n');
    return;
end

category_name = batch_file(1:(index-1));
output_dir_category = fullfile(output_dir, category_name);

command_line = ['colorDescriptor.exe --batch ', batch_file_name,...
    ' --detector densesampling --ds_spacing 20 --descriptor opponentsift', ...
    ' --outputFormat binary', ' --output ', output_dir_category];

system(command_line);


