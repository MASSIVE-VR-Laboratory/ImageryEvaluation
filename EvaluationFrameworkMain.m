%% This script is the header control all the evaluation to be conducted 
%   to check the feasibility of using HDR for object detection and tracking
%   1) The first phase of the evaluation methodology is to test the
%   reconstruction of HDR using deep learning technique (image / video).
%   2) The second phase of the evaluation methodology tests the best fit
%   for object detection using several different type of imagery
%   (ExpFusion/TMO/SingleExposure/HDR)

%% Additional comment: The reconstruction fidelity is to tested using HDR
% metrics such as puPSNR, puSSIM, HDR-VDP and HDR-VQM (in case of video).
% The framework can be executed in any platform (Windows/Linux/iOS). 

% Author: Ratnajit Mukherjee, INESCTEC, Portugal, 2018
% Project: HDR4TT, Office of Naval Research (ONR) global, London

%% Header information of the controlling script
    clearvars; clc;
    input_struct.input_type = 'image';  % it can also be a video. 
    input_struct.extension = 'exr';     % can be an .hdr/.exr file.
    input_struct.input_folder = '/media/visualisation/scratch/HDREvaluationSequences/HDRimages';% the parent folder path.
    input_struct.output_folder = '/home/visualisation/Desktop/output_folder';                   % the output folder path.
    input_struct.eval_folder = '/home/visualisation/Desktop/eval_folder';                       % the evaluation folder path.
    input_struct.results_folder = '/home/visualisation/Desktop/results_folder';                 % the final results path.

%% Main body of the controlling script
    fprintf('\n\n ******EVALUATION FRAMEWORK STARTING****** \n\n');    
    choice = questdlg('Do you want to preprocess the images to particular size?', 'Batch pre-process HDR images', 'Yes', 'No', 'Cancel', 'No');    
    
% STEP 1: Preprocess the images from multiple source folders to a
% particular folder

    switch(choice)
        case 'Yes'
            if(strcmp(input_struct.input_type, 'image') == true)                
                fprintf('\n *** BATCH PROCESSING HDR IMAGES ***');
                preprocessHDRimages(input_struct.input_folder, input_struct.output_folder);  % this process involves the use to multiple CPU cores and GPUs                
                fprintf('\n *** BATCH PROCESSING COMPLETE ***\n');
                
            elseif(strcmp(input_struct.input_type, 'video') == true)
                fprintf('\n *** BATCH PROCESSING HDR VIDEO SEQUENCES ***');
                preprocessHDRvideos(input_struct.input_folder, input_struct.output_folder);  % this process involves the use to multiple CPU cores and GPUs                
                fprintf('\n *** BATCH PROCESSING COMPLETE ***\n');
            end 
            
        case 'No'
            warning('Nothing to pre-process. Moving to evaluation phase');
            % do nothing
            
        case 'Cancel'
            error('Evaluation process stopped by user. Start script again for further evaluation');
            
    end
    
% STEP 2: Evaluation of the pre-processed / unchanged images (depending
% upon user input.
    
    if (strcmp(input_struct.input_type, 'image') == true)
        controlImageEvaluation(input_struct);
    elseif(strcmp(input_struct.input_type, 'video') == true)
        controlVideoEvaluation(input_struct);
    else
        error('\n\n Incorrect input. Try again\n\n');
    end 

    fprintf('\n\n ******EVALUATION FRAMEWORK COMPLETE****** \n\n');