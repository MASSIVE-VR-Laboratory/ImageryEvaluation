function predictHDR(read_path,write_path)
%% PREDICT HDR uses the external HDRCNN (Gabriel Eilerstein) to predict HDR
% 1) individual HDR frames are read to obtain file sizes
% 2) call external python script for predicted output to designated dir
% Author: Ratnajit Mukherjee, INESCTEC, 2018
% Project: HDR4TT, ONR London

%% Main body of the function



% reading the list of files and storing their file sizes
   filelist = dir(fullfile(read_path, '*.jpg'));  
       
% calling the external script for HDRCNN-predict 

    % command line options
    script_path = 'C:\Users\PC\PycharmProjects\hdrcnn\hdrcnn_predict.py';
    params_path = 'C:\Users\PC\PycharmProjects\hdrcnn\hdrcnn_params_compr.npz';    
    gamma = 1.2;
    parfor i = 1 : numel(filelist)   
        ldr = imread(fullfile(filelist(i).folder, filelist(i).name));
        output_filename = fullfile(write_path);
        cmd_str = sprintf('python %s --params %s --im_dir %s --out_dir %s --width %d --height %d --gamma %d', ...
                           script_path, params_path, fullfile(filelist(i).folder, filelist(i).name),output_filename, ...
                           size(ldr, 2), size(ldr, 1), gamma); 
        system(cmd_str);          
        fprintf('\n File %s predicted..', filelist(i).name);   
    end
    fprintf("\n *** STAGE 2: HDR prediction complete ***\n");
    delete(gcp('nocreate'));
end