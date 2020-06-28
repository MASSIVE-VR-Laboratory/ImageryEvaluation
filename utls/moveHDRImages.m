function moveHDRImages(input_path, output_path, org_hdr_path)
%% Function to move HDR images from subfolders to a main output folder
% this function is NOT going to be required once the python file for
% predicting HDR is fixed for single inputs and output frames
% the function also reads the images and resizes based on the original
% HDR images

%% Main body of the function     

    input_folder_list = dir(input_path);
    input_folder_list = input_folder_list(~ismember({input_folder_list.name},{'.' '..', 'target_folder'}));
    
    org_file_list = dir(fullfile(org_hdr_path, '*.exr'));    
    
    parfor i = 1 : numel(input_folder_list)        
        input_filelist = dir(fullfile(input_folder_list(i).folder, input_folder_list(i).name, '*.exr'));
        org_hdr = exrread(fullfile(org_file_list(i).folder, org_file_list(i).name));        
        for j = 1 : numel(input_filelist)
            input_hdr = exrread(fullfile(input_filelist(j).folder, input_filelist(j).name));
            [h_org, w_org, ~] = size(org_hdr);
            target_hdr = imresize(input_hdr, [h_org, w_org], 'bicubic');
            target_hdr = ClampImg(target_hdr, 1e-5, max(target_hdr(:)));
            exrwrite(target_hdr, fullfile(output_path, sprintf('%05d_predicted.exr', (i-1))));
        end
        fprintf('\n File %05d.exr written', (i-1));
    end 
end