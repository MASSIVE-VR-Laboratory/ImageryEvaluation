%% get image quality evaluation

ref_dir = 'D:\Ratnajit_bkup\hdr_prediction_workspace\graded_hdr';
predicted_dir = 'D:\Ratnajit_bkup\hdr_prediction_workspace\predicted_hdr';
results_path = 'D:\Ratnajit_bkup\hdr_prediction_workspace';

subdir_list = dir(predicted_dir); subdir_list(1:2) = [];

for i = 1 : numel(subdir_list)    
    leafdir_list = dir(fullfile(subdir_list(i).folder, subdir_list(i).name));
    leafdir_list(1:2) = [];    
    for j = 1 : numel(leafdir_list)
        leafdir_path = fullfile(leafdir_list(j).folder, leafdir_list(j).name);
        eval_table = getObjectiveEvaluation(ref_dir, leafdir_path); 
        tbl = struct2table(eval_table);
        % writing the CSV file
        csv_file_name = sprintf('%s_%s.csv', subdir_list(i).name, leafdir_list(j).name);       
        csv_file_path = fullfile(results_path, csv_file_name);
        writetable(tbl, csv_file_path);        
        fprintf('\n File: %s written.', csv_file_name);
    end
end 

