clear BATCH;
addpath(genpath('/public/mig_old_storage/home1/ISTBI_data/toolbox/conn16a'));

% Define directories
base_dir = '/public/home2/nodecw_group/UKB_WGS_imaging_data/tfMRI/zstat/ins3';
output_dir = '/public/home/gongwk/ukbtaskfc/ins3';
template_file = '/public/home/gongwk/MNI152_T1_3mm_brain_mask.nii';
event_file1 = '/public/home/gongwk/fear.txt';
event_file2 = '/public/home/gongwk/neut.txt';
roi_file = '/public/home/gongwk/newAmygdala_R.nii';

% Get list of subdirectories in base_dir
subdirs = dir(base_dir);
subdirs = subdirs([subdirs.isdir] & ~ismember({subdirs.name}, {'.', '..'}));

% Iterate over each subdirectory
for i = 1:length(subdirs)
    subdir_path = fullfile(base_dir, subdirs(i).name);
    disp(['Processing subdirectory: ', subdir_path]);

    % Find zip files within the current subdirectory
    zip_files = dir(fullfile(subdir_path, '*.zip'));
    
    for j = 1:length(zip_files)
        zip_name = zip_files(j).name;
        [~, folder_name, ~] = fileparts(zip_name);
        new_folder_name = split(folder_name, '_');
        new_folder_name = new_folder_name{1};
        
        % Define paths
        unzip_path = fullfile(output_dir, new_folder_name);

        % Check if zip file exists
        if ~exist(fullfile(subdir_path, zip_name), 'file')
            disp(['Zip file does not exist: ', zip_name]);
            continue;
        end
        
        try
            % Unzip the file
            disp(['Unzipping file: ', zip_name, ' to ', unzip_path]);
            unzip(fullfile(subdir_path, zip_name), unzip_path);
        catch ME
            disp(['Failed to unzip file: ', zip_name, ' with error: ', ME.message]);
            continue;
        end
        
        % Define paths
        feat_dir = fullfile(unzip_path, 'fMRI','tfMRI.feat');
        nii_file = fullfile(feat_dir, 'filtered_func_data.nii.gz');
        % Check if nii_file exists
        if ~exist(nii_file, 'file')
            disp(['NIfTI file does not exist: ', nii_file, ' - Skipping this loop.']);
            continue;
        end
        dest_file = fullfile(unzip_path, 'filtered_func_data.nii.gz');
        regfile = fullfile(output_dir,new_folder_name,'fMRI/tfMRI.feat/reg','example_func2standard_warp.nii.gz');
        disp('reg begin');
        system(['applywarp -i ', nii_file,  ' -r ', template_file,' -w ', regfile,' -o ', nii_file]);
        copyfile(nii_file,dest_file);
        disp('reg done');
        mc_dir = fullfile(feat_dir, 'mc');
        motion_file = fullfile(mc_dir, 'prefiltered_func_data_mcf.par');
        motion_txt = fullfile(mc_dir, 'prefiltered_func_data_mcf.txt');
        
        % Rename motion file to .txt
        disp(['Renaming motion file: ', motion_file, ' to ', motion_txt]);
        movefile(motion_file, motion_txt);
        
        % Setup CONN batch
        disp(['Setting up CONN batch for subject: ', new_folder_name]);
        BATCH.filename = fullfile(output_dir, [new_folder_name '.mat']);
        BATCH.Setup.RT = 2;
        BATCH.Setup.nsubjects = 1;
        BATCH.Setup.voxelresolution = 3; % Set resolution to 3mm
        BATCH.Setup.analyses = 2;

        nsession = 1;
        batch_sub = 1;
        
        % Define 4D data
        BATCH.Setup.functionals{batch_sub}{nsession} = nii_file;
        BATCH.Setup.structurals{batch_sub}{nsession} = template_file;

        % Define conditions
        fear = readtable(event_file1);
        neut = readtable(event_file2);
        condition_names = {'fear', 'neut'};
        BATCH.Setup.conditions.onsets{1}{batch_sub}{nsession} = vec(fear.Var1);
        BATCH.Setup.conditions.durations{1}{batch_sub}{nsession} = vec(fear.Var2);
        BATCH.Setup.conditions.onsets{2}{batch_sub}{nsession} = vec(neut.Var1);
        BATCH.Setup.conditions.durations{2}{batch_sub}{nsession} = vec(neut.Var2);
        BATCH.Setup.conditions.names = condition_names;
        
        % Temporal regression
        BATCH.Setup.covariates.names{1} = 'motions';
        BATCH.Setup.covariates.files{1}{batch_sub}{nsession} = motion_txt;

        % Use defined ROI
        BATCH.Setup.rois.multiplelabels = 0;
        BATCH.Setup.rois.files{1} = roi_file;
        BATCH.Setup.rois.mask = 0;
        
        BATCH.Setup.overwrite = 'Yes';
        BATCH.Setup.isnew = 1;
        BATCH.Setup.done = 1;
        
        % Denoising
        BATCH.Denoising.filter = [0.01, 0.1];
        BATCH.Denoising.done = 1;
        BATCH.Denoising.despiking = 1;
        
        % Analysis
        BATCH.Analysis.modulation = 0;
        BATCH.Analysis.measure = 1;
        BATCH.Analysis.weight = 2;
        BATCH.Analysis.type = 2;
        BATCH.Analysis.overwrite = 'Yes';
        BATCH.Analysis.sources = {'newAmygdala_R'}; % Update source name to match ROI
        BATCH.Analysis.done = 1;
        
        % Run CONN batch
        disp(['Running CONN batch for subject: ', new_folder_name]);
        conn_batch(BATCH);
        
        % Move and register BETA files
        beta_files = {'BETA_Subject001_Condition001_Source001.nii', 'BETA_Subject001_Condition002_Source001.nii'};
        for k = 1:length(beta_files)
            input_file = fullfile(unzip_path, 'results', 'firstlevel', 'ANALYSIS_01', beta_files{k});
            output_file = fullfile(unzip_path, beta_files{k});
            %system(['applywarp -i ', input_file,  ' -r ', template_file,' -w ', regfile,' -o ', output_file]);
            % Check if BETA file exists before moving
            if exist(input_file, 'file')
                disp(['Moving BETA file: ', input_file, ' to ', output_file]);
                movefile(input_file, output_file);
            else
                disp(['BETA file does not exist: ', input_file]);
            end
        end
        
        % Clean up
        disp(['Cleaning up files for subject: ', new_folder_name]);
        delete(BATCH.filename); % Delete the .mat file
        
        % Keep only the necessary BETA files
        rmdir(fullfile(unzip_path, 'fMRI'), 's'); % Delete fMRI directory
        rmdir(fullfile(unzip_path, 'data'), 's'); % Delete data directory
        rmdir(fullfile(unzip_path, 'results'), 's');
    end
end

disp('Processing complete!');
















