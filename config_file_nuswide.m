%%%%% Global configuration file %%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% DIRECTORIES - please change if copying the code to a new location
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BATCHFILE_DIR = 'D:\workspace-limu\image-annotation\datasets\NUS-WIDE\download_list\';
OUTPUT_DIR_DESCRIPTOR_BATCH = 'D:\workspace-limu\image-annotation\datasets\NUS-WIDE\descriptors\randomshuffle';
OUTPUT_DIR_TEMPFILE = 'D:\workspace-limu\image-annotation\datasets\NUS-WIDE\descriptors\tempfile';
OUTPUT_DIR_DESCRIPTOR_ROOT = 'D:\workspace-limu\image-annotation\datasets\NUS-WIDE\descriptors';
OUTPUT_DIR_DESCRIPTOR_CODEBOOK= 'D:\workspace-limu\image-annotation\datasets\NUS-WIDE\descriptors\codebook';

Feature_Type = {'csift','opponentsift', 'rgbsift','sift', 'rgsift'};
Codebook_Size = {4000, 4000, 4000, 4000, 4000};
Set_Type = {'train','test'};
Detector = {'densesampling','harrislaplace'};