%% expansion batch 

input_image_path = 'D:\Ratnajit_bkup\hdr_prediction_workspace\ldr_versions\';
output_image_path = 'D:\Ratnajit_bkup\hdr_prediction_workspace\predicted_hdr\';

dirs = dir(input_image_path);
dirs(1:2) = []; % those 2 are just path info

for i = 1 : numel(dirs)
    dirname = dirs(i).name;
    output_dir_name_kov = fullfile(output_image_path, dirname, 'Kov');    
    output_dir_name_huo = fullfile(output_image_path, dirname, 'Huo');    
    
    if ~exist(output_dir_name_kov, 'dir')
        mkdir(output_dir_name_kov);
    end
    
    if ~exist(output_dir_name_huo, 'dir')
        mkdir(output_dir_name_huo);
    end

    filelist = dir(fullfile(input_image_path, dirname, '*.jpg'));
    
    parfor j = 1 : numel(filelist)
        % read tmo and normalize
        tmo = im2double(imread(fullfile(filelist(j).folder, filelist(j).name)));
        hdr_kov = KovaleskiOliveiraEO(tmo, 'image', 100, (25/255), 0.001, 4000, 2.4);
        hdr_huo = HuoPhysEO(tmo, 4000, 0.75, 2.4);
        exrwrite(hdr_kov, fullfile(output_dir_name_kov, sprintf('%05d.exr', (j-1))));
        exrwrite(hdr_huo, fullfile(output_dir_name_huo, sprintf('%05d.exr', (j-1))));
    end
end