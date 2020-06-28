%% post processing batch
input_dir = 'D:\Ratnajit_bkup\hdr_prediction_workspace\ldr_versions\BestExposure';
output_dir = 'D:\Ratnajit_bkup\hdr_prediction_workspace\predicted_hdr\BestExposureexit\hdrcnn';

input_filelist = dir(fullfile(input_dir, '*.jpg'));
output_filelist = dir(fullfile(output_dir, '*.exr'));

for i = 1 : numel(input_filelist)
    info = imfinfo(fullfile(input_filelist(i).folder, input_filelist(i).name));    
    hdr = exrread(fullfile(output_filelist(i).folder, output_filelist(i).name));
    hdr = imresize(hdr, [info.Height, info.Width], 'Method', 'lanczos3');
    exrwrite(hdr, fullfile(output_filelist(i).folder, output_filelist(i).name));
    fprintf('\n File %s written', output_filelist(i).name);
end
