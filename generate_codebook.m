% function generate_codebook is to generate codebook given descriptors
%   1, given descriptor files from N samples, using k-means clustering
%   method in VLFeat library.
%   
%   INPUT:  dir_descriptor --- directory where descriptor files locate
%           name_descriptor --- descriptor type, e.g. sift,
%           opponentsift,...
%           size_codebook --- cluster size
%           dir_codebook ---- directory to save the output codebook
function generate_codebook(config_file, feature_type)

eval(config_file);

if~exist(OUTPUT_DIR_DESCRIPTOR_CODEBOOK, 'dir')
    mkdir(OUTPUT_DIR_DESCRIPTOR_CODEBOOK);
end
% set default input parameter
name_descriptor = Feature_Type{feature_type};
size_codebook = Codebook_Size{feature_type};

% begin preparation 
% read each descriptor (.bin file) for list file and random select partial descriptors
% from each descriptor and concatenate them into one matrix DxN
descriptor_files = dir(OUTPUT_DIR_DESCRIPTOR_BATCH);

descriptor_total_sub = [];
% if 0
for d = 3 : length(descriptor_files) %ignore the '.' and '..' subdirs
    if descriptor_files(d).isdir == 0
        % get descritptor from this file, random select partial
        file_name = fullfile(OUTPUT_DIR_DESCRIPTOR_BATCH, descriptor_files(d).name);
        [des, fra] = readBinaryDescriptors(file_name);
        
        %select random partial
        des = des'; %DxN
        sample_number = floor(size(des,2) * 0.1);
        des_sub = vl_colsubset(des, sample_number);
        descriptor_total_sub = cat(2, descriptor_total_sub, des_sub);
    end
end
% else
%     load('train_descriptor.mat');
% end

fprintf('we have total %d numbers of descriptors for k-mean clustering \n', size(descriptor_total_sub, 2));
%use total_sub to do kmean with VLFeat
descriptor_total_sub = uint8(descriptor_total_sub);

tstart = tic;
[clusters, assigns] = vl_ikmeans(descriptor_total_sub, size_codebook,'method','elkan','maxiters',100,'Verbose');
telapsed = toc(tstart);
fprintf('finished kmeans clustering, using time %f \n', telapsed);

codebook_name = sprintf('codebook_%s_%d.mat',name_descriptor, size_codebook);
%save codebook
save(fullfile(OUTPUT_DIR_DESCRIPTOR_CODEBOOK, codebook_name), 'clusters','assigns');

fprintf('Generate codebook for %s feature has finished! \n', name_descriptor),

%% now to save storage, need to delete randomshuffle descriptor files
fprintf('to save storage, need to delete randomshuffle descriptor files...... \n');

tstart = tic;
delete(fullfile(OUTPUT_DIR_DESCRIPTOR_BATCH, '*.bin'));
telapsed = toc(tstart);
fprintf('delete random shuffle descriptor files finished, using time %f \n', telapsed);
