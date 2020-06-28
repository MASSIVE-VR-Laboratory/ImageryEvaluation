function [ eval_table ] = getObjectiveEvaluation( org_path, pred_path)
%% Main Evaluation control function calling several evaluation metrics
% NOTE: this evaluation function can evaluate images as well as video
% sequences. In case of video sequences (the output might be averaged based
% on the number of frames passed). 
% Author: Ratnajit Mukherjee, Copyright © 2018, INESCTEC, Portugal
% Project: HDR4TT, ONR Global, London

%% Main body of the function
    filelist = dir(fullfile(pred_path, '*.exr'));       
    parfor i = 1 : numel(filelist)
        org = RemoveSpecials(double(exrread(fullfile(org_path, sprintf('%05d.exr', (i-1))))));
        pred = RemoveSpecials(double(exrread(fullfile(pred_path, sprintf('%05d.exr', (i-1))))));                
        eval_table(i).psnr_rgb = RemoveSpecials(qm_psnr(org, pred, 'rgb'));                
        eval_table(i).pussim = RemoveSpecials(qm_pu2_ssim(org, pred));
        eval_table(i).pupsnr = RemoveSpecials(qm_pu2_psnr(org, pred));        
    end    
end 