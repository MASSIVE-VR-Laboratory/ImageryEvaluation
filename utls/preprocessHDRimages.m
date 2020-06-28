function preprocessHDRimages(parent_folder, target_folder)
%% This function preprocesses HDR images for the image evaluation
%   Pre-processing is a part of the HDR image evaluation where all the files
%   are processed to a common filesize (within reasonable limits) and then
%   absolute graded for evaluation using perceptual metrics later.
% 
%   Author: Ratnajit Mukherjee, INESCTEC, Portugal, 2018
%   Project: HDR4TT, ONR Global
%

%% Header information and folder manipulation    
    parent_path = parent_folder; % the parent folder path        
    target_path = target_folder; % the folder where all target images will be stored    
%% creation of directory based on the requirements
    if(~exist(target_path, 'dir'))
        fprint('\n Directory does not exist. Creating directory...');
        mkdir(target_path);        
    else
        warning('\n Directory already exists. Skipping to the next part');
    end
    
% first level of sub-directories
    folder_list = dir(parent_path);
    folder_list = folder_list(~ismember({folder_list.name},{'.' '..', 'target_folder'}));

%% listing of files in the subdirectories
    processlist = [];
    for i = 1 : numel(folder_list)
        filedir = fullfile(folder_list(i).folder, folder_list(i).name);
        processlist = [processlist; dir(fullfile(filedir, '*.exr')); dir(fullfile(filedir, '*.hdr'))];
    end
    
%% processing the image list created
    process_images(processlist, target_path);
end