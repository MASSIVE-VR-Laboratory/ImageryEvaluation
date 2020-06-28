input_folder = 'D:\Ratnajit_bkup\hdr_prediction_workspace\org_hdr';
%output_folder_reinhard = 'D:\Ratnajit_bkup\hdr_prediction_workspace\ldr_versions\ReinhardTMO';
%output_folder_icam = 'D:\Ratnajit_bkup\hdr_prediction_workspace\ldr_versions\iCAM06';
output_folder_middle = 'D:\Ratnajit_bkup\hdr_prediction_workspace\ldr_versions\BestExposure';

% if ~exist(output_folder_reinhard, 'dir')
%     mkdir(output_folder_reinhard);
% end
% 
% if ~exist(output_folder_icam, 'dir')
%     mkdir(output_folder_icam);
% end

if ~exist(output_folder_middle, 'dir')
    mkdir(output_folder_middle);
end

filelist = dir(fullfile(input_folder, '*.exr'));

for i =305 : numel(filelist)
    hdr = exrread(fullfile(filelist(i).folder, filelist(i).name));
    hdr = RemoveSpecials(hdr);
    hdr = ClampImg(hdr, 1e-5, max(hdr(:)));
%     tmo_a = im2uint8(lin2srgb(ReinhardTMO(hdr)));
%     tmo_b = iCAM06_HDR(hdr);   
    tmo_c = im2uint8(lin2srgb(BestExposureTMO(hdr)));
%     imwrite(tmo_a, fullfile(output_folder_reinhard, sprintf('%05d.jpg', (i-1))), 'quality', 100);    
%     imwrite(tmo_b, fullfile(output_folder_icam, sprintf('%05d.jpg', (i-1))), 'quality', 100);        
    imwrite(tmo_c, fullfile(output_folder_middle, sprintf('%05d.jpg', (i-1))), 'quality', 100);        
    fprintf('\n File %05d done.', (i-1));
end
