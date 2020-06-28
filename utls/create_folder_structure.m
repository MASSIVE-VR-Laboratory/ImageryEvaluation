function [fs] = create_folder_structure(write_path)
%% This function is to be called for creation of the folder structure
% works both for image and video sequence evaluation
% 
% Input: write path (the evaluation folder)
% Output: fs: a folder structure for the middle exp, exp_fusion and TMOs
%
% Author: Ratnajit Mukherjee, INESCTEC, Portugal, 2018
% Project: HDR4TT, ONR Global
%

%% Main body of the function

% middle exposure folder
    fs.middle_exp_folder = fullfile(write_path, 'mid_exp');
    if(~exist(fs.middle_exp_folder, 'dir'))
        fprintf('\n Creating middle exposure directory');
        mkdir(fs.middle_exp_folder);
    end
    
% exposure fusion folder
    fs.exp_fusion_folder = fullfile(write_path, 'exp_fusion');    
    if(~exist(fs.exp_fusion_folder, 'dir'))
        fprintf('\n Creating exposure fusion directory');
        mkdir(fs.exp_fusion_folder);
    end       
    
% Reinhard TMO folder
    fs.reinhard_folder = fullfile(write_path, 'ReinhardTMO');
    if(~exist(fs.reinhard_folder, 'dir'))
        fprintf('\n Creating ReinhardTMO directory');
        mkdir(fs.reinhard_folder);
    end
    
% Mantiuk TMO folder
    fs.mantiuk_folder = fullfile(write_path, 'MantiukTMO');
    if(~exist(fs.mantiuk_folder, 'dir'))
        fprintf('\n Creating MantiukTMO directory');
        mkdir(fs.mantiuk_folder);
    end
    
%% ADDITIONAL NOTE:     
% Just add the type of the folder you want to be created for exapnading the
% project if required.
end