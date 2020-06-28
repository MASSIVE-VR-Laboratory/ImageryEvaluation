function process_images(filelist, target_path)
%% This function processes the images in a given directory
%   STEP 1: Check if the image HDR / EXR and read accordingly
%   STEP 2: Resize each image keeping same aspect ratio (use GPU if
%   possible)
%   STEP 3: Absolute grade the images
%   STEP 4: Print status message and return file count

%% Main body of the function
    gpuDevice; % initialize GPU
    gpucount = gpuDeviceCount;
    parfor i = 1 : numel(filelist)
        filename = filelist(i).name;
        fname_parts = cellstr(strsplit(filename, '.'));
        
        if (strcmp(fname_parts{2}, 'pfm') == true || strcmp(fname_parts{2}, 'hdr') == true)
            hdr = hdrimread(fullfile(filelist(i).folder, filename));
        elseif(strcmp(fname_parts{2}, 'exr') == true)
            hdr = exrread(fullfile(filelist(i).folder, filename));
        end                
        
        % processing in GPU/CPU based on availability
        if (gpucount > 0)
            hdr_res_graded = process_image(hdr,  'gpu');
        else
            hdr_res_graded = process_image(hdr, 'cpu');
        end
        exrwrite(hdr_res_graded, fullfile(target_path, sprintf('%05d.exr', (i-1))));
        fprintf('\n File %05d graded at put to target folder. ', (i-1));
    end    
end

function [hdr_res_graded] = process_image(hdr, opr_mode)
%% Resize and absolute grade image
% this part of the code is kept generic because we don't know what image
% we are getting (consider dim1 = height and dim2 = width)
    [org_dim1, org_dim2, ~] = size(hdr);

% resize image
    if (org_dim2 >= org_dim1)
        %image orientation = landscape / square
        [t_dim1, t_dim2] = check_dimensions(org_dim1, org_dim2);
    elseif(org_dim2 < org_dim1)        
        %img_orientation = 'portrait' 
        %rotate image to landscape
        r_dim1 = org_dim2; r_dim2 = org_dim1;        
        [t_dim1, t_dim2] = check_dimensions(r_dim1, r_dim2);
        [t_dim2, t_dim1] = deal(t_dim1, t_dim2);            
    end        
        
    if(strcmp(opr_mode, 'gpu') == true)
        gpuArr = gpuArray(hdr);
        gpuArr_res = imresize(gpuArr, [t_dim1, t_dim2], 'bicubic');
        hdr_res = gather(gpuArr_res);
    else
        hdr_res = imresize(hdr, [t_dim1, t_dim2], 'bicubic');
    end

% absolute grade the image with a peak of 4000 cd/m2
    hdr_res = ClampImg(hdr_res, 1e-5, max(hdr_res(:)));
    mult_factor = max(hdr_res(:)) / max(hdr_res(:)); 
    hdr_res_graded = hdr_res .* mult_factor; 
    
end

function [t_dim1, t_dim2] = check_dimensions(org_dim1, org_dim2)
%% decision for image dimensions
    if(org_dim1 > 1080)
        t_dim1 = 1080; %images larger than 1080p will resized to 1080p
        t_aspect = org_dim2 / org_dim1; % keep the same aspect ratio
        t_dim2 = round(t_dim1 * t_aspect); % target width based on the new height and aspect ratio    
    elseif((720 <= org_dim1) && (org_dim1 <= 1080))
        temp_dim1 = org_dim1 - 720;
        temp_dim2 = 1080 - org_dim1;
        if(temp_dim1 > temp_dim2)
            t_dim1 = 1080; %images larger than 1080p will resized to 1080p
            t_aspect = org_dim2 / org_dim1; % keep the same aspect ratio
            t_dim2 = round(t_dim1 * t_aspect); % target width based on the new height and aspect ratio
        else
            t_dim1 = 720;
            t_aspect = org_dim2 / org_dim1; % keep the same aspect ratio
            t_dim2 = round(t_dim1 * t_aspect);
        end
    elseif((480 <= org_dim1) && (org_dim1 <= 720))
        temp_dim1 = org_dim1 - 720;
        temp_dim2 = 1080 - org_dim1;
        if(temp_dim1 > temp_dim2)
            t_dim1 = 720; %images larger than 1080p will resized to 720p
            t_aspect = org_dim2 / org_dim1; % keep the same aspect ratio
            t_dim2 = round(t_dim1 * t_aspect); % target width based on the new height and aspect ratio
        else
            t_dim1 = 480;
            t_aspect = org_dim2 / org_dim1; % keep the same aspect ratio
            t_dim2 = round(t_dim1 * t_aspect);
        end
    else        % for images which are even smaller than 480p
        t_dim1 = 480;
        t_aspect = org_dim2 / org_dim1; % keep the same aspect ratio
        t_dim2 = round(t_dim1 * t_aspect); % target width based on the new height and aspect ratio 
    end        
end