clear BATCH;
addpath(genpath('/public/mig_old_storage/home1/ISTBI_data/toolbox/conn16a'));

% Define directories
base_dir = '/public/home2/nodecw_group/UKB_WGS_imaging_data/tfMRI/zstat/ins3';
output_dir = '/public/home/gongwk/ukbtaskfc/ins3parforL';
template_file = '/public/home/gongwk/MNI152_T1_3mm_brain_mask.nii';
event_file1 = '/public/home/gongwk/fear.txt';
event_file2 = '/public/home/gongwk/neut.txt';
roi_file = '/public/home/gongwk/Amygdala_L.nii';

% Get list of subdirectories in base_dir
subdirs = dir(base_dir);
subdirs = subdirs([subdirs.isdir] & ~ismember({subdirs.name}, {'.', '..'}));
% Limit to first two subdirectories
subdirs = subdirs(3000:min(3003, length(subdirs)));

% Create a cell array to store the applywarp commands
applywarp_commands = cell(length(subdirs), 1);

% Start parallel pool
if isempty(gcp('nocreate'))
    parpool('local');
end

% First pass: Unzip files, prepare applywarp commands, and clean up
parfor i = 1:length(subdirs)
    subdir_path = fullfile(base_dir, subdirs(i).name);
    disp(['Processing subdirectory: ', subdir_path]);

    zip_files = dir(fullfile(subdir_path, '*.zip'));
    
    local_applywarp_commands = {};
    
    for j = 1:length(zip_files)
        zip_name = zip_files(j).name;
        [~, folder_name, ~] = fileparts(zip_name);
        new_folder_name = split(folder_name, '_');
        new_folder_name = new_folder_name{1};
        
        unzip_path = fullfile(output_dir, new_folder_name);

        if ~exist(fullfile(subdir_path, zip_name), 'file')
            disp(['Zip file does not exist: ', zip_name]);
            continue;
        end
        
        try
            unzip(fullfile(subdir_path, zip_name), unzip_path);
        catch ME
            disp(['Failed to unzip file: ', zip_name, ' with error: ', ME.message]);
            continue;
        end
        
        feat_dir = fullfile(unzip_path, 'fMRI','tfMRI.feat');
        nii_file = fullfile(feat_dir, 'filtered_func_data.nii.gz');
        if ~exist(nii_file, 'file')
            disp(['NIfTI file does not exist: ', nii_file, ' - Skipping this loop.']);
            continue;
        end
        dest_file = fullfile(unzip_path, 'filtered_func_data.nii.gz');
        regfile = fullfile(output_dir,new_folder_name,'fMRI/tfMRI.feat/reg','example_func2standard_warp.nii.gz');
        rfile = fullfile(unzip_path, 'example_func2standard_warp.nii.gz');
        % Prepare applywarp command
        cmd = sprintf('applywarp -i %s -r %s -w %s -o %s', dest_file, template_file, rfile, dest_file);
        local_applywarp_commands{end+1} = cmd;

        % Move motion file
        mc_dir = fullfile(feat_dir, 'mc');
        motion_file = fullfile(mc_dir, 'prefiltered_func_data_mcf.par');
        new_motion_file = fullfile(unzip_path, 'motion.txt');
        movefile(motion_file, new_motion_file);
        movefile(regfile,rfile);
        movefile(nii_file, dest_file);
        % Clean up unnecessary files
        rmdir(fullfile(unzip_path, 'fMRI'), 's');
        if exist(fullfile(unzip_path, 'data'), 'dir')
            rmdir(fullfile(unzip_path, 'data'), 's');
        end
        if exist(fullfile(unzip_path, 'results'), 'dir')
            rmdir(fullfile(unzip_path, 'results'), 's');
        end
    end
    
    applywarp_commands{i} = local_applywarp_commands;
end

% Flatten the applywarp_commands cell array
applywarp_commands = [applywarp_commands{:}];
print(applywarp_commands)
% Now you can use the applywarp_commands for further processing

% Execute applywarp commands in parallel
disp('Executing applywarp commands in parallel...');
parfor k = 1:length(applywarp_commands)
    system(applywarp_commands{k});
end
disp('Parallel applywarp execution complete.');

% Second pass: Process each subject sequentially
for i = 1:length(subdirs)
    subdir_path = fullfile(base_dir, subdirs(i).name);
    zip_files = dir(fullfile(subdir_path, '*.zip'));
    
    for j = 1:length(zip_files)
        zip_name = zip_files(j).name;
        [~, folder_name, ~] = fileparts(zip_name);
        new_folder_name = split(folder_name, '_');
        new_folder_name = new_folder_name{1};
        
        unzip_path = fullfile(output_dir, new_folder_name);
        nii_file = fullfile(unzip_path, 'filtered_func_data.nii.gz');
        motion_txt = fullfile(unzip_path, 'motion.txt');
        
        % Setup CONN batch
        disp(['Setting up CONN batch for subject: ', new_folder_name]);
        BATCH.filename = fullfile(output_dir, [new_folder_name '.mat']);
        BATCH.Setup.RT = 2;
        BATCH.Setup.nsubjects = 1;
        BATCH.Setup.voxelresolution = 3;
        BATCH.Setup.analyses = 2;

        nsession = 1;
        batch_sub = 1;
        
        BATCH.Setup.functionals{batch_sub}{nsession} = nii_file;
        BATCH.Setup.structurals{batch_sub}{nsession} = template_file;

        fear = readtable(event_file1);
        neut = readtable(event_file2);
        condition_names = {'fear', 'neut'};
        BATCH.Setup.conditions.onsets{1}{batch_sub}{nsession} = vec(fear.Var1);
        BATCH.Setup.conditions.durations{1}{batch_sub}{nsession} = vec(fear.Var2);
        BATCH.Setup.conditions.onsets{2}{batch_sub}{nsession} = vec(neut.Var1);
        BATCH.Setup.conditions.durations{2}{batch_sub}{nsession} = vec(neut.Var2);
        BATCH.Setup.conditions.names = condition_names;
        
        BATCH.Setup.covariates.names{1} = 'motions';
        BATCH.Setup.covariates.files{1}{batch_sub}{nsession} = motion_txt;

        BATCH.Setup.rois.multiplelabels = 0;
        BATCH.Setup.rois.files{1} = roi_file;
        BATCH.Setup.rois.mask = 0;
        
        BATCH.Setup.overwrite = 'Yes';
        BATCH.Setup.isnew = 1;
        BATCH.Setup.done = 1;
        
        BATCH.Denoising.filter = [0.01, 0.1];
        BATCH.Denoising.done = 1;
        BATCH.Denoising.despiking = 1;
        
        BATCH.Analysis.modulation = 0;
        BATCH.Analysis.measure = 1;
        BATCH.Analysis.weight = 2;
        BATCH.Analysis.type = 2;
        BATCH.Analysis.overwrite = 'Yes';
        BATCH.Analysis.sources = {'newAmygdala_R'};
        BATCH.Analysis.done = 1;
        
        disp(['Running CONN batch for subject: ', new_folder_name]);
        conn_batch(BATCH);
        
        beta_files = {'BETA_Subject001_Condition001_Source001.nii', 'BETA_Subject001_Condition002_Source001.nii'};
        for k = 1:length(beta_files)
            input_file = fullfile(unzip_path, 'results', 'firstlevel', 'ANALYSIS_01', beta_files{k});
            output_file = fullfile(unzip_path, beta_files{k});
            if exist(input_file, 'file')
                disp(['Moving BETA file: ', input_file, ' to ', output_file]);
                movefile(input_file, output_file);
            else
                disp(['BETA file does not exist: ', input_file]);
            end
        end
        
        % New cleanup section
        disp(['Performing final cleanup for subject: ', new_folder_name]);
        files_to_keep = {'filtered_func_data.nii.gz', 'BETA_Subject001_Condition001_Source001.nii', 'BETA_Subject001_Condition002_Source001.nii'};
        
        % Get all files in the unzip_path
        all_files = dir(fullfile(unzip_path, '*'));
        
        % Loop through all files and delete those not in files_to_keep
        for k = 1:length(all_files)
            if ~all_files(k).isdir && ~ismember(all_files(k).name, files_to_keep)
                delete(fullfile(unzip_path, all_files(k).name));
            end
        end
        
        % Remove all subdirectories
        subdirs_to_remove = dir(fullfile(unzip_path, '*'));
        subdirs_to_remove = subdirs_to_remove([subdirs_to_remove.isdir]);
        for k = 1:length(subdirs_to_remove)
            if ~strcmp(subdirs_to_remove(k).name, '.') && ~strcmp(subdirs_to_remove(k).name, '..')
                rmdir(fullfile(unzip_path, subdirs_to_remove(k).name), 's');
            end
        end
    end
end
disp('Processing complete!');