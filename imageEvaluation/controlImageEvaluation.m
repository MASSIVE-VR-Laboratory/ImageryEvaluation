function controlImageEvaluation(input_struct)
%% This function acts as the controlling script for the HDR image evaluation.
% Input: HDR image folder, LDR output folder, Results Folder
% Methodology:
%   a) Create different type of imagery
%           1) split each image into multiple exposures 
%           2) create TMO and
%           3) exposure Fusion
%   b) Reconstruct the HDR using the different type of imagery
%   c) Verify the reconstruction using HDR metrics eval metrics
% 
%   Author: Ratnajit Mukherjee, INESCTEC, Portugal, 2018
%   Project: HDR4TT, ONR Global
%

%% Main body of the function
    read_path = input_struct.output_folder;         % the output folder from the preprocessing is the input folder for the evaluation
    write_path = input_struct.eval_folder;          % the eval folder will create subfolders for the evaluation files
    results_path = input_struct.results_folder;     % the final results folder where the evaluation tables will be stored to be used for analysis.
    folder_info = dir(fullfile(read_path, ['*.' input_struct.extension]));
        
%% Creation of folder structure inside the evaluation folder
    fs = create_folder_structure(write_path);  % written as a separate function for reusability      
    
%% create the multiple type of images (middle exp, exp_fusion and tmos)
    parfor i = 539: 542
        filename = split(folder_info(i).name, '.');
        fprintf('\n Fetching file: %s \n', folder_info(i).name);
        hdr = RemoveSpecials(exrread(fullfile(folder_info(i).folder, folder_info(i).name)), 4000);        
        % writing for defective images: 
        exrwrite(hdr, fullfile(folder_info(i).folder, folder_info(i).name));
        hdr = hdr .* (4000/max(hdr(:)));
        hdr = ClampImg(hdr, 1e-5, max(hdr(:)));                   
        
    %  extract and write the histogram equalized middle exposure
        fstops = [-8:1:7];    % Keeping the Canon 5D Mark III as a reference
        [ldr_stack, stack_exposures] = CreateLDRStackFromHDR(hdr, fstops, 'selected', 'sRGB', 'sRGB');
        [~,exp_idx] = min(abs(bsxfun(@minus,0.01,stack_exposures))); % exposure with min difference to 0.5 (half a stop under)  
        mid_exp = ldr_stack(:,:,:,exp_idx);
        % adaptive histogram equalization of the middle exposure
        histEQ = zeros(size(mid_exp));
        for j = 1 : size(mid_exp, 3)
            histEQ(:,:,j) = adapthisteq(mid_exp(:,:,j), 'NumTiles', [8 8], 'ClipLimit', 1e-3, 'NBins', 512, 'Range', 'full', 'Distribution', 'uniform');
        end        
        writeExposures(fs.middle_exp_folder, histEQ, filename{1});
        
    % create and write Reinhard TMO
        tmo = im2uint8(lin2rgb(real(ReinhardTMO(hdr))));
        writeExposures(fs.reinhard_folder, tmo, filename{1});
        
    % create and write Mantiuk TMO (calls PFStools external)
        cmd_str = sprintf('pfsinexr %s | pfstmo_mantiuk08 -q -d pd=lcd_bright|pfsout %s',...
                        fullfile(folder_info(i).folder, folder_info(i).name), fullfile(fs.mantiuk_folder, [filename{1} '.jpg']));
        system(cmd_str);            
        
    % create Exposure Fusion (external Python script)                
        filename_array = writeExposures(fs.exp_fusion_folder, ldr_stack, filename{1});        
        str = strjoin(filename_array, ' ');
        exp_fusion_cmd = sprintf('python3 ExposureFusion.py %s "%s"',fs.exp_fusion_folder, str);
        system(exp_fusion_cmd);
        
    % print out status
        fprintf('File %s.exr done...',filename{1});
        
    end
    
%% cleaning up temporary files created during exposure fusion
    cleanup_str = sprintf('rm %s/*_exp*.jpg', fs.exp_fusion_folder);
    system(cleanup_str);

%% Final status
    fprintf('\n *** FILE CREATION COMPLETE *** \n');
end 