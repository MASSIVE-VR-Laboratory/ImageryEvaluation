function [filename_array] = writeExposures(output_folder,exp_stack, filename)
%% This function writes the output in the specified folder
% Input: 
%       1) output_folder
%       2) input array (can be a single array or a stack)
%       3) filename passed from the mother function
%       4) image type (all exposures, middle exp, tmo)
%
% Author: Ratnajit Mukherjee, INESCTEC Portugal, 2018.
% Project: HDR4TT, Office of Naval Research (ONR) global, London
%

%% Main body of the function 
% check dimensions of an array passed to the function. If dimension is 3
% then its a normal RGB image else its an exposure stack
    if(ndims(exp_stack) == 3) 
        imwrite(exp_stack, fullfile(output_folder, [filename '.jpg']), 'quality', 100);                
    elseif(ndims(exp_stack) == 4)
        parfor i = 1 : size(exp_stack, 4)
            img = im2uint8(exp_stack(:,:,:,i));
            filename_array(i) = strcat(""+sprintf('%s_exp%d.jpg', filename, (i-1)));
            imwrite(img, fullfile(output_folder, sprintf('%s_exp%d.jpg', filename, (i-1))), 'quality', 100);
        end
    end
end