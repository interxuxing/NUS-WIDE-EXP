%% This batch script is to extract 5 types of features by 2 types of detector
%   total 5x2 = 10 features
%   one by one

eval('config_file_nuswide');

LOG_FILE_DIR = 'D:\workspace-limu\cloud disk\Dropbox\limu\submission\CVIU-SP';
log_file = fullfile(LOG_FILE_DIR, 'feature_batch_log.txt');

fid_log_file = fopen(log_file, 'w');

for i = 1: length(Detector)
    for j = 1: length(Feature_Type) 
        fprintf(fid_log_file,'Now feature: %s, detector: %s \n', Feature_Type{j}, Detector{i});
        %save run_log file for each feature type
        run_log_name = sprintf('run_log_%s_%s', Detector{i}, Feature_Type{j});
        diary(fullfile(LOG_FILE_DIR, run_log_name));
        diary on;
        
        
        %1, generate descriptor for random shuffle samples
        fprintf(fid_log_file, 'start to generate descriptor for random shuffle samples \n');
        tstart = tic;
        generate_colordescriptor_batch('config_file_nuswide',j, i);
        telapsed = toc(tstart);
        fprintf(fid_log_file,'generate descriptor for random shuffle samples finished, using time %f \n', telapsed);
        
        %2, generate codebook
        fprintf(fid_log_file, 'start to generate codebook \n');
        tstart = tic;
        generate_codebook('config_file_nuswide', j);
        telapsed = toc(tstart);
        fprintf(fid_log_file,'generate codebook finished, using time %f \n', telapsed);
        
        %3, generate bow for train / test
        fprintf(fid_log_file, 'start to generate bow for valid train and test samples \n');
        tstart = tic;
        generate_bow('config_file_nuswide', j, i);
        telapsed = toc(tstart);
        fprintf(fid_log_file,'generate bow for valid train and test samples finished, using time %f \n', telapsed);
        
        diary off;
    end
end

fclose(fid_log_file);
fprintf(fid_log_file,'finished feature batch all! Congradulations! \n');