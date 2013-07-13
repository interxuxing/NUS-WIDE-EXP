% function generate_bow(config_file, feature_type)
%  ----- use trained codebook to generate bag of words for each valid sample in
% both train and test set
% 1, first use color descriptor to generate feature descriptor for each
% file, depending on different feature type (command)
% 2, then use codebook of that feature to generate bow for each sample in
% valid_train / valid_test list
% 3, delete the feature descriptor file for current sample
% 4, save final bow of all train / test samples in 2 .mat file
function generate_bow(config_file, feature_type, detector_type)

eval(config_file);
name_feature = Feature_Type{feature_type};
name_detector = Detector{detector_type};
% create temp folder, use for feature extraction
if ~exist(OUTPUT_DIR_TEMPFILE, 'dir')
    mkdir(OUTPUT_DIR_TEMPFILE);
end


%load codebook
codebook_name = sprintf('codebook_%s_%d.mat',name_feature, Codebook_Size{feature_type});
load(fullfile(OUTPUT_DIR_DESCRIPTOR_CODEBOOK, codebook_name));

fprintf('begin to generate bow....\n');
fprintf('feature type is %s, detector type is %s \n', name_feature, name_detector);
% loop for train / test valid list
% fist extract descriptor, then generate bov for each sample


for s = 1 : length(Set_Type)
    fprintf('Now %s set... ...\n', Set_Type{s})
    % parse file
    name_valid = fullfile(BATCHFILE_DIR, sprintf('valid_%s_list.txt',Set_Type{s}));
    fid_valid = fopen(name_valid);
    valid_info = textscan(fid_valid, '%s');
    valid_info = valid_info{1};
    
    output_dir_temp = OUTPUT_DIR_TEMPFILE;
    codebook_clusters = clusters;
    feature_matrix = zeros(length(valid_info), Codebook_Size{feature_type});
    
    parfor i = 1 : length(valid_info)
%     parfor i = 12640 : 12800
        output_tempfile = fullfile(output_dir_temp, extract_filename(valid_info{i}));
        output_tempfile = strrep(output_tempfile, '.jpg','.bin');
        % extract descriptor for each sample, depending on feature type
        % generate commandline
%         if strcmp(Feature_Type{feature_type}, 'opponentsift')
%            
%             command_line = ['colorDescriptor.exe ', valid_info{i}, ...
%                 ' --detector densesampling --ds_spacing 20 --descriptor opponentsift', ...
%                 ' --outputFormat binary', ' --output ', output_tempfile];
% 
%         elseif strcmp(Feature_Type{feature_type}, 'sift')
% 
%         end
        if detector_type == 1
                
                command_line = ['colorDescriptor.exe ', valid_info{i},...
            ' --detector densesampling --ds_spacing 20 --descriptor ', name_feature...
            ' --outputFormat binary', ' --output ', output_tempfile];
        
        elseif detector_type == 2              
               
                command_line = ['colorDescriptor.exe ', valid_info{i},...
            ' --detector harrislaplace --harrisThreshold 1e-6 --descriptor ', name_feature...
            ' --outputFormat binary', ' --output ', output_tempfile];  

        else
                disp('wrong detector type!');
        end
        
        system(command_line);
        % read descriptor file, then use codebook to generate bow
        try
        [des, fra] = readBinaryDescriptors(output_tempfile);
        catch
            fprintf('error format %d \n', i);
            lasterr;
%             feature_matrix(i,:) = H';
            continue;
        end
        des = uint8(des');
        AT = vl_ikmeanspush(des, codebook_clusters);
        H = vl_ikmeanshist(Codebook_Size{feature_type}, AT);
        feature_matrix(i,:) = H'; % row vector for each sample
        
        %delete this file
        delete(output_tempfile);
        
%         if(mod(i, 500) == 0)
%             fprintf('finished bow for %d th %s samples ...\n', i, Set_Type{s});
%         end
    end
    
    %save .mat file
    display('save .mat file!');
    if ~exist(fullfile(OUTPUT_DIR_DESCRIPTOR_ROOT, name_feature),'dir')
        mkdir(fullfile(OUTPUT_DIR_DESCRIPTOR_ROOT, name_feature));
    end
    bow_file = sprintf('valid_feature_matrix_%s_%s.mat', name_feature, Set_Type{s});
    
    save(fullfile(OUTPUT_DIR_DESCRIPTOR_ROOT, name_feature, bow_file),'feature_matrix','-v7.3');
    
    fclose(fid_valid);
    
    fprintf('save feature matrix file %s for %s set finished! \n', bow_file, Set_Type{s});
end


end


function short_name = extract_filename(long_name)
index = strfind(long_name, '\');
short_name = long_name(index(end)+1:end);

end
