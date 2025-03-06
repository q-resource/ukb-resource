% 定义源目录和目标目录
sourceDir = '/public/home2/nodecw_group/UKB_WGS_imaging_data/tfMRI/zstat/ins2';
targetDir = '/public/home/gongwk/ukb_taskparforreal/ins2';

% MNI152_T1_3mm_brain_mask.nii 的路径
mniMaskPath = fullfile(targetDir, 'MNI152_T1_3mm_brain_mask.nii');

% 确保目标目录存在
if ~exist(targetDir, 'dir')
    mkdir(targetDir);
end

% 创建错误日志文件
errorLogFile = fullfile(targetDir, 'error_log.txt');
fileID = fopen(errorLogFile, 'w');

% 获取源目录下所有子文件夹
subFolders = dir(sourceDir);
subFolders = subFolders([subFolders.isdir]);
subFolders = subFolders(~ismember({subFolders.name}, {'.', '..'}));

totalFolders = length(subFolders);
processedFolders = 0;
successfullyProcessed = 0;

% 遍历每个子文件夹
for i = 1:totalFolders
    subFolderName = subFolders(i).name;
    subFolderPath = fullfile(sourceDir, subFolderName);
    
    % 查找zip文件
    zipFiles = dir(fullfile(subFolderPath, '*.zip'));
    
    if ~isempty(zipFiles)
        zipFilePath = fullfile(subFolderPath, zipFiles(1).name);
        
        % 在目标目录创建临时文件夹
        tempDir = fullfile(targetDir, ['temp_' subFolderName]);
        if ~exist(tempDir, 'dir')
            mkdir(tempDir);
        end
        
        try
            % 复制zip文件到临时目录
            copyfile(zipFilePath, tempDir);
            
            % 解压zip文件
            unzip(fullfile(tempDir, zipFiles(1).name), tempDir);
            
            % 查找解压后的fMRI文件夹
            fMRIFolder = fullfile(tempDir, 'fMRI');
            if exist(fMRIFolder, 'dir')
                % 重命名fMRI文件夹
                targetFolderPath = fullfile(targetDir, subFolderName);
                if exist(targetFolderPath, 'dir')
                    try
                        rmdir(targetFolderPath, 's');
                    catch
                        warning(['Unable to remove directory: ' targetFolderPath]);
                        system(['rm -rf ' targetFolderPath]);
                    end
                end
                mkdir(targetFolderPath);
                
                % 处理zstat文件
                statsFolder = fullfile(fMRIFolder, 'tfMRI.feat', 'stats');
                regFolder = fullfile(fMRIFolder, 'tfMRI.feat', 'reg');
                warpFile = fullfile(regFolder, 'example_func2standard_warp.nii.gz');
                
                if exist(statsFolder, 'dir') && exist(warpFile, 'file')
                    for j = 1:5
                        inputFile = fullfile(statsFolder, sprintf('zstat%d.nii.gz', j));
                        outputFile = fullfile(targetFolderPath, sprintf('zstat%ds.nii.gz', j));
                        
                        % 执行 applywarp 命令
                        command = sprintf('applywarp -i %s -o %s -r %s -w %s', ...
                            inputFile, outputFile, mniMaskPath, warpFile);
                        system(command);
                    end
                    
                    successfullyProcessed = successfullyProcessed + 1;
                    disp(['Processed: ' subFolderName]);
                else
                    error('Required folders or files not found');
                end
            else
                error('fMRI folder not found');
            end
        catch ME
            % 记录错误信息到日志文件
            fprintf(fileID, '%s: %s\n', subFolderName, ME.message);
            disp(['Error processing ' subFolderName ': ' ME.message]);
        end
        
        % 删除临时文件夹
        try
            rmdir(tempDir, 's');
        catch
            warning(['Unable to remove temporary directory: ' tempDir]);
            system(['rm -rf ' tempDir]);
        end
    else
        % 记录没有zip文件的情况
        fprintf(fileID, '%s: No zip file found\n', subFolderName);
        disp(['Error: No zip file found in ' subFolderName]);
    end
    
    processedFolders = processedFolders + 1;
    disp(['Progress: ' num2str(processedFolders) '/' num2str(totalFolders) ' folders processed']);
end

% 关闭错误日志文件
fclose(fileID);

disp(['All folders processed. Total: ' num2str(totalFolders) ', Successfully processed: ' num2str(successfullyProcessed)]);
disp(['Error log saved to: ' errorLogFile]);





% 定义源目录和目标目录
sourceDir = '/public/home2/nodecw_group/UKB_WGS_imaging_data/tfMRI/zstat/ins3';
targetDir = '/public/home/gongwk/ukb_taskparforreal/ins3';

% MNI152_T1_3mm_brain_mask.nii 的路径
mniMaskPath = fullfile(targetDir, 'MNI152_T1_3mm_brain_mask.nii');

% 确保目标目录存在
if ~exist(targetDir, 'dir')
    mkdir(targetDir);
end

% 创建错误日志文件
errorLogFile = fullfile(targetDir, 'error_log.txt');
fileID = fopen(errorLogFile, 'w');

% 获取源目录下所有子文件夹
subFolders = dir(sourceDir);
subFolders = subFolders([subFolders.isdir]);
subFolders = subFolders(~ismember({subFolders.name}, {'.', '..'}));

totalFolders = length(subFolders);
processedFolders = 0;
successfullyProcessed = 0;

% 遍历每个子文件夹
for i = 1:totalFolders
    subFolderName = subFolders(i).name;
    subFolderPath = fullfile(sourceDir, subFolderName);
    
    % 查找zip文件
    zipFiles = dir(fullfile(subFolderPath, '*.zip'));
    
    if ~isempty(zipFiles)
        zipFilePath = fullfile(subFolderPath, zipFiles(1).name);
        
        % 在目标目录创建临时文件夹
        tempDir = fullfile(targetDir, ['temp_' subFolderName]);
        if ~exist(tempDir, 'dir')
            mkdir(tempDir);
        end
        
        try
            % 复制zip文件到临时目录
            copyfile(zipFilePath, tempDir);
            
            % 解压zip文件
            unzip(fullfile(tempDir, zipFiles(1).name), tempDir);
            
            % 查找解压后的fMRI文件夹
            fMRIFolder = fullfile(tempDir, 'fMRI');
            if exist(fMRIFolder, 'dir')
                % 重命名fMRI文件夹
                targetFolderPath = fullfile(targetDir, subFolderName);
                if exist(targetFolderPath, 'dir')
                    try
                        rmdir(targetFolderPath, 's');
                    catch
                        warning(['Unable to remove directory: ' targetFolderPath]);
                        system(['rm -rf ' targetFolderPath]);
                    end
                end
                mkdir(targetFolderPath);
                
                % 处理zstat文件
                statsFolder = fullfile(fMRIFolder, 'tfMRI.feat', 'stats');
                regFolder = fullfile(fMRIFolder, 'tfMRI.feat', 'reg');
                warpFile = fullfile(regFolder, 'example_func2standard_warp.nii.gz');
                
                if exist(statsFolder, 'dir') && exist(warpFile, 'file')
                    for j = 1:5
                        inputFile = fullfile(statsFolder, sprintf('zstat%d.nii.gz', j));
                        outputFile = fullfile(targetFolderPath, sprintf('zstat%ds.nii.gz', j));
                        
                        % 执行 applywarp 命令
                        command = sprintf('applywarp -i %s -o %s -r %s -w %s', ...
                            inputFile, outputFile, mniMaskPath, warpFile);
                        system(command);
                    end
                    
                    successfullyProcessed = successfullyProcessed + 1;
                    disp(['Processed: ' subFolderName]);
                else
                    error('Required folders or files not found');
                end
            else
                error('fMRI folder not found');
            end
        catch ME
            % 记录错误信息到日志文件
            fprintf(fileID, '%s: %s\n', subFolderName, ME.message);
            disp(['Error processing ' subFolderName ': ' ME.message]);
        end
        
        % 删除临时文件夹
        try
            rmdir(tempDir, 's');
        catch
            warning(['Unable to remove temporary directory: ' tempDir]);
            system(['rm -rf ' tempDir]);
        end
    else
        % 记录没有zip文件的情况
        fprintf(fileID, '%s: No zip file found\n', subFolderName);
        disp(['Error: No zip file found in ' subFolderName]);
    end
    
    processedFolders = processedFolders + 1;
    disp(['Progress: ' num2str(processedFolders) '/' num2str(totalFolders) ' folders processed']);
end

% 关闭错误日志文件
fclose(fileID);

disp(['All folders processed. Total: ' num2str(totalFolders) ', Successfully processed: ' num2str(successfullyProcessed)]);
disp(['Error log saved to: ' errorLogFile]);




% 定义源目录和目标目录
sourceDir = '/public/home2/nodecw_group/UKB_WGS_imaging_data/tfMRI/zstat/ins2';
targetDir = '/public/home/gongwk/ukb_taskparforreal/ins2';

% MNI152_T1_3mm_brain_mask.nii 的路径
mniMaskPath = fullfile(targetDir, 'MNI152_T1_3mm_brain_mask.nii');

% 确保目标目录存在
if ~exist(targetDir, 'dir')
    mkdir(targetDir);
end

% 创建错误日志文件
errorLogFile = fullfile(targetDir, 'error_log.txt');

% 获取源目录下所有子文件夹
subFolders = dir(sourceDir);
subFolders = subFolders([subFolders.isdir]);
subFolders = subFolders(~ismember({subFolders.name}, {'.', '..'}));

totalFolders = length(subFolders);

% 获取可用的核心数量
numCores = feature('numcores');

% 创建一个并行池，使用所有可用的核心
if isempty(gcp('nocreate'))
    parpool(numCores);
end

% 设置MATLAB使用所有可用的线程
maxNumCompThreads(numCores);

fprintf('Using %d cores for parallel processing\n', numCores);

% 使用并行循环处理文件夹
parfor i = 1:totalFolders
    subFolderName = subFolders(i).name;
    subFolderPath = fullfile(sourceDir, subFolderName);
    
    % 查找zip文件
    zipFiles = dir(fullfile(subFolderPath, '*.zip'));
    
    if ~isempty(zipFiles)
        zipFilePath = fullfile(subFolderPath, zipFiles(1).name);
        
        % 在目标目录创建临时文件夹
        tempDir = fullfile(targetDir, ['temp_' subFolderName '_' num2str(i)]);
        if ~exist(tempDir, 'dir')
            mkdir(tempDir);
        end
        
        try
            % 复制zip文件到临时目录
            copyfile(zipFilePath, tempDir);
            
            % 解压zip文件
            unzip(fullfile(tempDir, zipFiles(1).name), tempDir);
            
            % 查找解压后的fMRI文件夹
            fMRIFolder = fullfile(tempDir, 'fMRI');
            if exist(fMRIFolder, 'dir')
                % 重命名fMRI文件夹
                targetFolderPath = fullfile(targetDir, subFolderName);
                if exist(targetFolderPath, 'dir')
                    rmdir(targetFolderPath, 's');
                end
                mkdir(targetFolderPath);
                
                % 处理zstat文件
                statsFolder = fullfile(fMRIFolder, 'tfMRI.feat', 'stats');
                regFolder = fullfile(fMRIFolder, 'tfMRI.feat', 'reg');
                warpFile = fullfile(regFolder, 'example_func2standard_warp.nii.gz');
                
                if exist(statsFolder, 'dir') && exist(warpFile, 'file')
                    for j = 1:5
                        inputFile = fullfile(statsFolder, sprintf('zstat%d.nii.gz', j));
                        outputFile = fullfile(targetFolderPath, sprintf('zstat%ds.nii.gz', j));
                        
                        % 执行 applywarp 命令
                        command = sprintf('applywarp -i %s -o %s -r %s -w %s', ...
                            inputFile, outputFile, mniMaskPath, warpFile);
                        system(command);
                    end
                    
                    fprintf('Processed: %s\n', subFolderName);
                else
                    error('Required folders or files not found');
                end
            else
                error('fMRI folder not found');
            end
        catch ME
            % 记录错误信息到临时文件
            tempErrorFile = fullfile(tempDir, 'error.txt');
            tempFileID = fopen(tempErrorFile, 'w');
            fprintf(tempFileID, '%s: %s\n', subFolderName, ME.message);
            fclose(tempFileID);
            fprintf('Error processing %s: %s\n', subFolderName, ME.message);
        end
        
        % 删除临时文件夹
        rmdir(tempDir, 's');
    else
        % 记录没有zip文件的情况到临时文件
        tempErrorFile = fullfile(targetDir, ['nozip_' subFolderName '.txt']);
        tempFileID = fopen(tempErrorFile, 'w');
        fprintf(tempFileID, '%s: No zip file found\n', subFolderName);
        fclose(tempFileID);
        fprintf('Error: No zip file found in %s\n', subFolderName);
    end
    
    fprintf('Progress: %d/%d folders processed\n', i, totalFolders);
end

% 合并所有错误日志
system(['cat ' targetDir '/temp_*_*/error.txt ' targetDir '/nozip_*.txt > ' errorLogFile]);
system(['rm ' targetDir '/temp_*_*/error.txt ' targetDir '/nozip_*.txt']);

% 计算成功处理的文件夹数量
successfullyProcessed = totalFolders - numel(dir([targetDir '/*error.txt']));

fprintf('All folders processed. Total: %d, Successfully processed: %d\n', totalFolders, successfullyProcessed);
fprintf('Error log saved to: %s\n', errorLogFile);




% 定义源目录和目标目录
sourceDir = '/public/home2/nodecw_group/UKB_WGS_imaging_data/tfMRI/zstat/ins3';
targetDir = '/public/home/gongwk/ukb_taskparforreal/ins3';

% MNI152_T1_3mm_brain_mask.nii 的路径
mniMaskPath = fullfile(targetDir, 'MNI152_T1_3mm_brain_mask.nii');

% 确保目标目录存在
if ~exist(targetDir, 'dir')
    mkdir(targetDir);
end

% 创建错误日志文件
errorLogFile = fullfile(targetDir, 'error_log.txt');

% 获取源目录下所有子文件夹
subFolders = dir(sourceDir);
subFolders = subFolders([subFolders.isdir]);
subFolders = subFolders(~ismember({subFolders.name}, {'.', '..'}));

totalFolders = length(subFolders);

% 获取可用的核心数量
numCores = feature('numcores');

% 创建一个并行池，使用所有可用的核心
if isempty(gcp('nocreate'))
    parpool(numCores);
end

% 设置MATLAB使用所有可用的线程
maxNumCompThreads(numCores);

fprintf('Using %d cores for parallel processing\n', numCores);

% 使用并行循环处理文件夹
parfor i = 1:totalFolders
    subFolderName = subFolders(i).name;
    subFolderPath = fullfile(sourceDir, subFolderName);
    
    % 查找zip文件
    zipFiles = dir(fullfile(subFolderPath, '*.zip'));
    
    if ~isempty(zipFiles)
        zipFilePath = fullfile(subFolderPath, zipFiles(1).name);
        
        % 在目标目录创建临时文件夹
        tempDir = fullfile(targetDir, ['temp_' subFolderName '_' num2str(i)]);
        if ~exist(tempDir, 'dir')
            mkdir(tempDir);
        end
        
        try
            % 复制zip文件到临时目录
            copyfile(zipFilePath, tempDir);
            
            % 解压zip文件
            unzip(fullfile(tempDir, zipFiles(1).name), tempDir);
            
            % 查找解压后的fMRI文件夹
            fMRIFolder = fullfile(tempDir, 'fMRI');
            if exist(fMRIFolder, 'dir')
                % 重命名fMRI文件夹
                targetFolderPath = fullfile(targetDir, subFolderName);
                if exist(targetFolderPath, 'dir')
                    rmdir(targetFolderPath, 's');
                end
                mkdir(targetFolderPath);
                
                % 处理zstat文件
                statsFolder = fullfile(fMRIFolder, 'tfMRI.feat', 'stats');
                regFolder = fullfile(fMRIFolder, 'tfMRI.feat', 'reg');
                warpFile = fullfile(regFolder, 'example_func2standard_warp.nii.gz');
                
                if exist(statsFolder, 'dir') && exist(warpFile, 'file')
                    for j = 1:5
                        inputFile = fullfile(statsFolder, sprintf('zstat%d.nii.gz', j));
                        outputFile = fullfile(targetFolderPath, sprintf('zstat%ds.nii.gz', j));
                        
                        % 执行 applywarp 命令
                        command = sprintf('applywarp -i %s -o %s -r %s -w %s', ...
                            inputFile, outputFile, mniMaskPath, warpFile);
                        system(command);
                    end
                    
                    fprintf('Processed: %s\n', subFolderName);
                else
                    error('Required folders or files not found');
                end
            else
                error('fMRI folder not found');
            end
        catch ME
            % 记录错误信息到临时文件
            tempErrorFile = fullfile(tempDir, 'error.txt');
            tempFileID = fopen(tempErrorFile, 'w');
            fprintf(tempFileID, '%s: %s\n', subFolderName, ME.message);
            fclose(tempFileID);
            fprintf('Error processing %s: %s\n', subFolderName, ME.message);
        end
        
        % 删除临时文件夹
        rmdir(tempDir, 's');
    else
        % 记录没有zip文件的情况到临时文件
        tempErrorFile = fullfile(targetDir, ['nozip_' subFolderName '.txt']);
        tempFileID = fopen(tempErrorFile, 'w');
        fprintf(tempFileID, '%s: No zip file found\n', subFolderName);
        fclose(tempFileID);
        fprintf('Error: No zip file found in %s\n', subFolderName);
    end
    
    fprintf('Progress: %d/%d folders processed\n', i, totalFolders);
end

% 合并所有错误日志
system(['cat ' targetDir '/temp_*_*/error.txt ' targetDir '/nozip_*.txt > ' errorLogFile]);
system(['rm ' targetDir '/temp_*_*/error.txt ' targetDir '/nozip_*.txt']);

% 计算成功处理的文件夹数量
successfullyProcessed = totalFolders - numel(dir([targetDir '/*error.txt']));

fprintf('All folders processed. Total: %d, Successfully processed: %d\n', totalFolders, successfullyProcessed);
fprintf('Error log saved to: %s\n', errorLogFile);




% 定义源目录和目标目录
sourceDir = '/public/home2/nodecw_group/UKB_WGS_imaging_data/rfMRI/raw_data';
targetDir = '/public/home/gongwk/ukb_rest/ins2';

% MNI152_T1_3mm_brain_mask.nii 的路径
mniMaskPath = fullfile(targetDir, 'MNI152_T1_3mm_brain_mask.nii');

% 确保目标目录存在
if ~exist(targetDir, 'dir')
    mkdir(targetDir);
end

% 创建错误日志文件
errorLogFile = fullfile(targetDir, 'error_log.txt');
fileID = fopen(errorLogFile, 'w');

% 获取源目录下所有zip文件
zipFiles = dir(fullfile(sourceDir, '*_2_*.zip'));

totalFiles = length(zipFiles);
processedFiles = 0;
successfullyProcessed = 0;

% 遍历每个zip文件
for i = 1:totalFiles
    zipFileName = zipFiles(i).name;
    zipFilePath = fullfile(sourceDir, zipFileName);
    
    try
        % 从zip文件名中提取ID
        [~, name, ~] = fileparts(zipFileName);
        parts = strsplit(name, '_');
        subjectID = parts{1};
        
        % 在目标目录创建临时文件夹
        tempDir = fullfile(targetDir, ['temp_' subjectID]);
        if ~exist(tempDir, 'dir')
            mkdir(tempDir);
        end
        
        % 复制zip文件到临时目录
        copyfile(zipFilePath, tempDir);
        
        % 解压zip文件
        unzip(fullfile(tempDir, zipFileName), tempDir);
        
        % 查找解压后的fMRI文件夹
        fMRIFolder = fullfile(tempDir, 'fMRI');
        if exist(fMRIFolder, 'dir')
            % 重命名fMRI文件夹
            newFolderName = subjectID;
            newFolderPath = fullfile(targetDir, newFolderName);
            if exist(newFolderPath, 'dir')
                rmdir(newFolderPath, 's');
            end
            movefile(fMRIFolder, newFolderPath);
            
            % 处理文件
            cleanDataFile = fullfile(newFolderPath, 'rfMRI.ica', 'filtered_func_data_clean.nii.gz');
            warpFile = fullfile(newFolderPath, 'rfMRI.ica', 'reg', 'example_func2standard_warp.nii.gz');
            outputFile = fullfile(newFolderPath, 'filtered_func_data_cleans.nii.gz');
            
            if exist(cleanDataFile, 'file') && exist(warpFile, 'file')
                % 执行 applywarp 命令
                command = sprintf('applywarp -i %s -o %s -r %s -w %s', ...
                    cleanDataFile, outputFile, mniMaskPath, warpFile);
                system(command);
                
                % 删除除了filtered_func_data_cleans.nii.gz以外的所有文件
                files = dir(newFolderPath);
                for j = 1:length(files)
                    if ~files(j).isdir && ~strcmp(files(j).name, 'filtered_func_data_cleans.nii.gz')
                        delete(fullfile(newFolderPath, files(j).name));
                    elseif files(j).isdir && ~strcmp(files(j).name, '.') && ~strcmp(files(j).name, '..')
                        rmdir(fullfile(newFolderPath, files(j).name), 's');
                    end
                end
                
                successfullyProcessed = successfullyProcessed + 1;
                disp(['Processed: ' subjectID]);
            else
                error('Required files not found');
            end
        else
            error('fMRI folder not found');
        end
        
        % 删除临时文件夹
        rmdir(tempDir, 's');
        
    catch ME
        % 记录错误信息到日志文件
        fprintf(fileID, '%s: %s\n', zipFileName, ME.message);
        disp(['Error processing ' zipFileName ': ' ME.message]);
    end
    
    processedFiles = processedFiles + 1;
    disp(['Progress: ' num2str(processedFiles) '/' num2str(totalFiles) ' files processed']);
end

% 关闭错误日志文件
fclose(fileID);

disp(['All files processed. Total: ' num2str(totalFiles) ', Successfully processed: ' num2str(successfullyProcessed)]);
disp(['Error log saved to: ' errorLogFile]);



















% 定义源目录和目标目录
sourceDir = '/public/home2/nodecw_group/UKB_WGS_imaging_data/rfMRI/raw_data';
targetDir = '/public/home/gongwk/ukb_resttest/ins2';
% MNI152_T1_3mm_brain_mask.nii 的路径
mniMaskPath = fullfile(targetDir, 'MNI152_T1_3mm_brain_mask.nii');

fprintf('Starting processing. Source directory: %s\nTarget directory: %s\n', sourceDir, targetDir);

% 确保目标目录存在
if ~exist(targetDir, 'dir')
    mkdir(targetDir);
    fprintf('Created target directory: %s\n', targetDir);
end

% 创建错误日志目录
errorLogDir = fullfile(targetDir, 'error_logs');
if ~exist(errorLogDir, 'dir')
    mkdir(errorLogDir);
    fprintf('Created error log directory: %s\n', errorLogDir);
end

% 获取源目录下所有zip文件
zipFiles = dir(fullfile(sourceDir, '*_2_*.zip'));
totalFiles = length(zipFiles);
fprintf('Found %d zip files to process.\n', totalFiles);

% 创建并行池
if isempty(gcp('nocreate'))
    fprintf('Creating parallel pool...\n');
    parpool('local');
    fprintf('Parallel pool created.\n');
end

% 使用并行循环处理文件
parfor i = 1:totalFiles
    zipFileName = zipFiles(i).name;
    zipFilePath = fullfile(sourceDir, zipFileName);
    
    fprintf('Starting processing of file %d/%d: %s\n', i, totalFiles, zipFileName);
    
    % 为每个处理任务创建唯一的错误日志文件
    errorLogFile = fullfile(errorLogDir, sprintf('error_log_%d.txt', i));
    
    try
        % 从zip文件名中提取ID
        [~, name, ~] = fileparts(zipFileName);
        parts = strsplit(name, '_');
        subjectID = parts{1};
        
        fprintf('Processing subject ID: %s\n', subjectID);
        
        % 在目标目录创建临时文件夹，使用唯一标识符
        tempDir = fullfile(targetDir, ['temp_' subjectID '_' num2str(i) '_' num2str(randi(1000000))]);
        if ~exist(tempDir, 'dir')
            mkdir(tempDir);
        end
        fprintf('Created temporary directory: %s\n', tempDir);
        
        % 复制zip文件到临时目录
        copyfile(zipFilePath, tempDir);
        fprintf('Copied zip file to temporary directory.\n');
        
        % 解压zip文件
        unzip(fullfile(tempDir, zipFileName), tempDir);
        fprintf('Unzipped file in temporary directory.\n');
        
        % 查找解压后的fMRI文件夹
        fMRIFolder = fullfile(tempDir, 'fMRI');
        if exist(fMRIFolder, 'dir')
            fprintf('Found fMRI folder.\n');
            % 重命名fMRI文件夹
            newFolderName = subjectID;
            newFolderPath = fullfile(targetDir, newFolderName);
            
            % 使用文件锁来避免并发访问冲突
            lockFile = [newFolderPath '.lock'];
            fprintf('Attempting to acquire lock for %s\n', newFolderName);
            while ~mkdir(lockFile)
                pause(rand);  % 随机等待一段时间后重试
            end
            fprintf('Lock acquired for %s\n', newFolderName);
            
            try
                if exist(newFolderPath, 'dir')
                    rmdir(newFolderPath, 's');
                    fprintf('Removed existing folder: %s\n', newFolderPath);
                end
                movefile(fMRIFolder, newFolderPath);
                fprintf('Moved fMRI folder to: %s\n', newFolderPath);
                
                % 处理文件
                cleanDataFile = fullfile(newFolderPath, 'rfMRI.ica', 'filtered_func_data_clean.nii.gz');
                warpFile = fullfile(newFolderPath, 'rfMRI.ica', 'reg', 'example_func2standard_warp.nii.gz');
                outputFile = fullfile(newFolderPath, 'filtered_func_data_cleans.nii.gz');
                
                if exist(cleanDataFile, 'file') && exist(warpFile, 'file')
                    fprintf('Found required files. Executing applywarp command...\n');
                    % 执行 applywarp 命令
                    command = sprintf('applywarp -i %s -o %s -r %s -w %s', ...
                        cleanDataFile, outputFile, mniMaskPath, warpFile);
                    system(command);
                    fprintf('applywarp command executed.\n');
                    
                    fprintf('Cleaning up unnecessary files...\n');
                    % 删除除了filtered_func_data_cleans.nii.gz以外的所有文件
                    files = dir(newFolderPath);
                    for j = 1:length(files)
                        if ~files(j).isdir && ~strcmp(files(j).name, 'filtered_func_data_cleans.nii.gz')
                            delete(fullfile(newFolderPath, files(j).name));
                        elseif files(j).isdir && ~strcmp(files(j).name, '.') && ~strcmp(files(j).name, '..')
                            rmdir(fullfile(newFolderPath, files(j).name), 's');
                        end
                    end
                    fprintf('Cleanup completed.\n');
                    
                    fprintf('Successfully processed: %s\n', subjectID);
                else
                    error('Required files not found');
                end
            finally
                % 无论处理是否成功，都要删除锁文件
                rmdir(lockFile);
                fprintf('Lock released for %s\n', newFolderName);
            end
        else
            error('fMRI folder not found');
        end
        
        % 删除临时文件夹
        rmdir(tempDir, 's');
        fprintf('Removed temporary directory: %s\n', tempDir);
        
    catch ME
        % 记录错误信息到该任务的日志文件
        fileID = fopen(errorLogFile, 'w');
        fprintf(fileID, '%s: %s\n', zipFileName, ME.message);
        fclose(fileID);
        fprintf('Error processing %s: %s\n', zipFileName, ME.message);
    end
    
    fprintf('Completed processing of file %d/%d: %s\n', i, totalFiles, zipFileName);
end
% 在所有并行处理完成后，再次检查并删除可能残留的 .lock 文件
fprintf('Cleaning up any remaining lock files...\n');
lockFiles = dir(fullfile(targetDir, '*.lock'));
for i = 1:length(lockFiles)
    lockPath = fullfile(targetDir, lockFiles(i).name);
    if exist(lockPath, 'dir')
        rmdir(lockPath);
        fprintf('Removed remaining lock file: %s\n', lockFiles(i).name);
    end
end
fprintf('All parallel processing completed. Merging error logs...\n');

% 合并所有错误日志
system(['cat ' fullfile(errorLogDir, 'error_log_*.txt') ' > ' fullfile(targetDir, 'combined_error_log.txt')]);
system(['rm -rf ' errorLogDir]);

fprintf('All files processed. Total: %d\n', totalFiles);
fprintf('Combined error log saved to: %s\n', fullfile(targetDir, 'combined_error_log.txt'));
fprintf('Processing completed.\n');





















% 定义文件路径和MNI 3mm的mask路径
root_dir = '/public/home/gongwk/ukb_taskparforreal/ins2';
mask_path = '/public/home/gongwk/tfMRI_mask53mm.nii.gz'; % 这里替换为你的MNI 3mm mask路径
output_path = '/public/home/gongwk/face&shape_similarity_distribution_5_ins2.png'; % 这里替换为你想保存图像的路径

% 获取所有子文件夹
subdirs = dir(root_dir);
subdirs = subdirs([subdirs.isdir] & ~ismember({subdirs.name}, {'.', '..'}));

% 初始化相似性数组和对应的文件夹名称
similarities = [];
folder_names = {};

% 遍历每个文件夹
for i = 1:length(subdirs)
    % 构建zstat1s.nii.gz和zstat2s.nii.gz的路径
    zstat1_path = fullfile(root_dir, subdirs(i).name, 'zstat1s.nii.gz');
    zstat2_path = fullfile(root_dir, subdirs(i).name, 'zstat2s.nii.gz');
    % 检查文件是否存在，如果不存在则跳过
    if ~exist(zstat1_path, 'file') || ~exist(zstat2_path, 'file')
        fprintf('Skipping folder %s because one or both zstat files are missing.\n', subdirs(i).name);
        continue;
    end
    % 读取zstat1s和zstat2s文件
    zstat1 = y_ReadAll(zstat1_path);
    zstat2 = y_ReadAll(zstat2_path);
    
    % 读取MNI 3mm mask
    mask = y_ReadAll(mask_path);
    
    % 应用mask
    zstat1_masked = zstat1(logical(mask));
    zstat2_masked = zstat2(logical(mask));
    
    % 计算相似性（例如皮尔森相关系数）
    similarity = corr(zstat1_masked, zstat2_masked);
    similarities = [similarities; similarity];
    folder_names{end+1} = subdirs(i).name; % 记录对应的文件夹名称
end

% 计算统计量
mean_similarity = nanmean(similarities);
median_similarity = nanmedian(similarities);
std_similarity = nanstd(similarities);
[max_similarity, max_idx] = max(similarities);
max_folder = folder_names{max_idx};

% 绘制相似性分布
figure;
histogram(similarities, 'Normalization', 'probability');
title('Similarity Distribution between zstat1s and zstat2s ins2 WB');
xlabel('Similarity');
ylabel('Probability');

% 在图上添加统计量信息
stats_text = sprintf('Mean: %.4f\nMedian: %.4f\nStd Dev: %.4f\nMax: %.4f (Folder: %s)', ...
                     mean_similarity, median_similarity, std_similarity, max_similarity, max_folder);
text(0.7, 0.9, stats_text, 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'FontSize', 12);

% 保存图像
saveas(gcf, output_path);




% 定义文件路径和MNI 3mm的mask路径
root_dir = '/public/home/gongwk/ukb_taskparforreal/ins2';
mask_path = '/public/home/gongwk/ukb_taskparforreal/ins2/AAL_61x73x61_YCG.nii'; % 这里替换为你的MNI 3mm mask路径
output_path = '/public/home/gongwk/ukb_taskparforreal/ins2/face&shape_similarity_distribution_Llingual_ins2.png'; % 这里替换为你想保存图像的路径

% 获取所有子文件夹
subdirs = dir(root_dir);
subdirs = subdirs([subdirs.isdir] & ~ismember({subdirs.name}, {'.', '..'}));

% 初始化相似性数组和对应的文件夹名称
similarities = [];
folder_names = {};

% 遍历每个文件夹
for i = 1:length(subdirs)
    % 构建zstat1s.nii.gz和zstat2s.nii.gz的路径
    zstat1_path = fullfile(root_dir, subdirs(i).name, 'zstat1s.nii.gz');
    zstat2_path = fullfile(root_dir, subdirs(i).name, 'zstat2s.nii.gz');
    % 检查文件是否存在，如果不存在则跳过
    if ~exist(zstat1_path, 'file') || ~exist(zstat2_path, 'file')
        fprintf('Skipping folder %s because one or both zstat files are missing.\n', subdirs(i).name);
        continue;
    end
    % 读取zstat1s和zstat2s文件
    zstat1 = y_ReadAll(zstat1_path);
    zstat2 = y_ReadAll(zstat2_path);
    
    % 读取MNI 3mm mask
    mask = y_ReadAll(mask_path);
    
    % 应用mask
    zstat1_masked = zstat1(mask == 47);
    zstat2_masked = zstat2(mask == 47);
    
    % 计算相似性（例如皮尔森相关系数）
    similarity = corr(zstat1_masked, zstat2_masked);
    similarities = [similarities; similarity];
    folder_names{end+1} = subdirs(i).name; % 记录对应的文件夹名称
end

% 计算统计量
mean_similarity = nanmean(similarities);
median_similarity = nanmedian(similarities);
std_similarity = nanstd(similarities);
[max_similarity, max_idx] = max(similarities);
max_folder = folder_names{max_idx};

% 绘制相似性分布
figure;
histogram(similarities, 'Normalization', 'probability');
title('Similarity Distribution between zstat1s and zstat2s Llingual ins2');
xlabel('Similarity');
ylabel('Probability');

% 在图上添加统计量信息
stats_text = sprintf('Mean: %.4f\nMedian: %.4f\nStd Dev: %.4f\nMax: %.4f (Folder: %s)', ...
                     mean_similarity, median_similarity, std_similarity, max_similarity, max_folder);
text(0.7, 0.9, stats_text, 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'FontSize', 12);

% 保存图像
saveas(gcf, output_path);






% 定义文件路径和MNI 3mm的mask路径
root_dir = '/public/home/gongwk/ukb_taskparforreal/ins3';
mask_path = '/public/home/gongwk/ukb_taskparforreal/ins2/MNI152_T1_3mm_brain_mask.nii'; % 这里替换为你的MNI 3mm mask路径
output_path = '/public/home/gongwk/ukb_taskparforreal/ins2/face&shape_similarity_distribution_WB_ins3.png'; % 这里替换为你想保存图像的路径

% 获取所有子文件夹
subdirs = dir(root_dir);
subdirs = subdirs([subdirs.isdir] & ~ismember({subdirs.name}, {'.', '..'}));

% 初始化相似性数组和对应的文件夹名称
similarities = [];
folder_names = {};

% 遍历每个文件夹
for i = 1:length(subdirs)
    % 构建zstat1s.nii.gz和zstat2s.nii.gz的路径
    zstat1_path = fullfile(root_dir, subdirs(i).name, 'zstat1s.nii.gz');
    zstat2_path = fullfile(root_dir, subdirs(i).name, 'zstat2s.nii.gz');
    % 检查文件是否存在，如果不存在则跳过
    if ~exist(zstat1_path, 'file') || ~exist(zstat2_path, 'file')
        fprintf('Skipping folder %s because one or both zstat files are missing.\n', subdirs(i).name);
        continue;
    end
    % 读取zstat1s和zstat2s文件
    zstat1 = y_ReadAll(zstat1_path);
    zstat2 = y_ReadAll(zstat2_path);
    
    % 读取MNI 3mm mask
    mask = y_ReadAll(mask_path);
    
    % 应用mask
    zstat1_masked = zstat1(logical(mask));
    zstat2_masked = zstat2(logical(mask));
    
    % 计算相似性（例如皮尔森相关系数）
    similarity = corr(zstat1_masked, zstat2_masked);
    similarities = [similarities; similarity];
    folder_names{end+1} = subdirs(i).name; % 记录对应的文件夹名称
end

% 计算统计量
mean_similarity = nanmean(similarities);
median_similarity = nanmedian(similarities);
std_similarity = nanstd(similarities);
[max_similarity, max_idx] = max(similarities);
max_folder = folder_names{max_idx};

% 绘制相似性分布
figure;
histogram(similarities, 'Normalization', 'probability');
title('Similarity Distribution between zstat1s and zstat2s ins3 WB');
xlabel('Similarity');
ylabel('Probability');

% 在图上添加统计量信息
stats_text = sprintf('Mean: %.4f\nMedian: %.4f\nStd Dev: %.4f\nMax: %.4f (Folder: %s)', ...
                     mean_similarity, median_similarity, std_similarity, max_similarity, max_folder);
text(0.7, 0.9, stats_text, 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'FontSize', 12);

% 保存图像
saveas(gcf, output_path);




% 定义文件路径和MNI 3mm的mask路径
root_dir = '/public/home/gongwk/ukb_taskparforreal/ins3';
mask_path = '/public/home/gongwk/ukb_taskparforreal/ins2/AAL_61x73x61_YCG.nii'; % 这里替换为你的MNI 3mm mask路径
output_path = '/public/home/gongwk/ukb_taskparforreal/ins3/face&shape_similarity_distribution_RF_ins3.png'; % 这里替换为你想保存图像的路径

% 获取所有子文件夹
subdirs = dir(root_dir);
subdirs = subdirs([subdirs.isdir] & ~ismember({subdirs.name}, {'.', '..'}));

% 初始化相似性数组和对应的文件夹名称
similarities = [];
folder_names = {};

% 遍历每个文件夹
for i = 1:length(subdirs)
    % 构建zstat1s.nii.gz和zstat2s.nii.gz的路径
    zstat1_path = fullfile(root_dir, subdirs(i).name, 'zstat1s.nii.gz');
    zstat2_path = fullfile(root_dir, subdirs(i).name, 'zstat2s.nii.gz');
    % 检查文件是否存在，如果不存在则跳过
    if ~exist(zstat1_path, 'file') || ~exist(zstat2_path, 'file')
        fprintf('Skipping folder %s because one or both zstat files are missing.\n', subdirs(i).name);
        continue;
    end
    % 读取zstat1s和zstat2s文件
    zstat1 = y_ReadAll(zstat1_path);
    zstat2 = y_ReadAll(zstat2_path);
    
    % 读取MNI 3mm mask
    mask = y_ReadAll(mask_path);
    
    % 应用mask
    zstat1_masked = zstat1(mask == 56);
    zstat2_masked = zstat2(mask == 56);
    
    % 计算相似性（例如皮尔森相关系数）
    similarity = corr(zstat1_masked, zstat2_masked);
    similarities = [similarities; similarity];
    folder_names{end+1} = subdirs(i).name; % 记录对应的文件夹名称
end

% 计算统计量
mean_similarity = mean(similarities);
median_similarity = median(similarities);
std_similarity = std(similarities);
[max_similarity, max_idx] = max(similarities);
max_folder = folder_names{max_idx};

% 绘制相似性分布
figure;
histogram(similarities, 'Normalization', 'probability');
title('Similarity Distribution between zstat1s and zstat2s RF ins3');
xlabel('Similarity');
ylabel('Probability');

% 在图上添加统计量信息
stats_text = sprintf('Mean: %.4f\nMedian: %.4f\nStd Dev: %.4f\nMax: %.4f (Folder: %s)', ...
                     mean_similarity, median_similarity, std_similarity, max_similarity, max_folder);
text(0.7, 0.9, stats_text, 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'FontSize', 12);

% 保存图像
saveas(gcf, output_path);
















% 定义文件路径和MNI 3mm的mask路径
root_dir = '/public/home/gongwk/ukb_taskparforreal/ins2';
mask_path = '/public/home/gongwk/ukb_taskparforreal/ins2/MNI152_T1_3mm_brain_mask.nii'; % 这里替换为你的MNI 3mm mask路径
output_path = '/public/home/gongwk/ukb_taskparforreal/ins2/face&shape_similarity_distribution_1meancorr2_ins2.png'; % 这里替换为你想保存图像的路径

% 获取所有子文件夹
subdirs = dir(root_dir);
subdirs = subdirs([subdirs.isdir] & ~ismember({subdirs.name}, {'.', '..'}));

% 初始化相似性数组和对应的文件夹名称
similarities = [];
folder_names = {};

% 遍历每个文件夹
for i = 1:length(subdirs)
    % 构建zstat1s.nii.gz和zstat2s.nii.gz的路径
    zstat1_path = '/public/home/gongwk/ukb_taskparforreal/ins2/tfMRI_zstat1_FE3mm.nii.gz';
    zstat2_path = fullfile(root_dir, subdirs(i).name, 'zstat2s.nii.gz');
    % 检查文件是否存在，如果不存在则跳过
    if ~exist(zstat1_path, 'file') || ~exist(zstat2_path, 'file')
        fprintf('Skipping folder %s because one or both zstat files are missing.\n', subdirs(i).name);
        continue;
    end
    % 读取zstat1s和zstat2s文件
    zstat1 = y_ReadAll(zstat1_path);
    zstat2 = y_ReadAll(zstat2_path);
    
    % 读取MNI 3mm mask
    mask = y_ReadAll(mask_path);
    
    % 应用mask
    zstat1_masked = zstat1(logical(mask));
    zstat2_masked = zstat2(logical(mask));
    
    % 计算相似性（例如皮尔森相关系数）
    similarity = corr(zstat1_masked, zstat2_masked);
    similarities = [similarities; similarity];
    folder_names{end+1} = subdirs(i).name; % 记录对应的文件夹名称
end

% 计算统计量
mean_similarity = mean(similarities);
median_similarity = median(similarities);
std_similarity = std(similarities);
[max_similarity, max_idx] = max(similarities);
max_folder = folder_names{max_idx};

% 绘制相似性分布
figure;
histogram(similarities, 'Normalization', 'probability');
title('Similarity Distribution between zstat1smean and zstat2s ins2 WB');
xlabel('Similarity');
ylabel('Probability');

% 在图上添加统计量信息
stats_text = sprintf('Mean: %.4f\nMedian: %.4f\nStd Dev: %.4f\nMax: %.4f (Folder: %s)', ...
                     mean_similarity, median_similarity, std_similarity, max_similarity, max_folder);
text(0.7, 0.9, stats_text, 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'FontSize', 12);

% 保存图像
saveas(gcf, output_path);





% 定义文件路径和MNI 3mm的mask路径
root_dir = '/public/home/gongwk/ukb_taskparforreal/ins2';
mask_path = '/public/home/gongwk/ukb_taskparforreal/ins2/MNI152_T1_3mm_brain_mask.nii'; % 这里替换为你的MNI 3mm mask路径
output_path = '/public/home/gongwk/ukb_taskparforreal/ins2/face&shape_similarity_distribution_2meancorr1_ins2.png'; % 这里替换为你想保存图像的路径

% 获取所有子文件夹
subdirs = dir(root_dir);
subdirs = subdirs([subdirs.isdir] & ~ismember({subdirs.name}, {'.', '..'}));

% 初始化相似性数组和对应的文件夹名称
similarities = [];
folder_names = {};

% 遍历每个文件夹
for i = 1:length(subdirs)
    % 构建zstat1s.nii.gz和zstat2s.nii.gz的路径
    zstat1_path = '/public/home/gongwk/ukb_taskparforreal/ins2/tfMRI_zstat2_FE3mm.nii.gz';
    zstat2_path = fullfile(root_dir, subdirs(i).name, 'zstat2s.nii.gz');
    % 检查文件是否存在，如果不存在则跳过
    if ~exist(zstat1_path, 'file') || ~exist(zstat2_path, 'file')
        fprintf('Skipping folder %s because one or both zstat files are missing.\n', subdirs(i).name);
        continue;
    end
    % 读取zstat1s和zstat2s文件
    zstat1 = y_ReadAll(zstat1_path);
    zstat2 = y_ReadAll(zstat2_path);
    
    % 读取MNI 3mm mask
    mask = y_ReadAll(mask_path);
    
    % 应用mask
    zstat1_masked = zstat1(logical(mask));
    zstat2_masked = zstat2(logical(mask));
    
    % 计算相似性（例如皮尔森相关系数）
    similarity = corr(zstat1_masked, zstat2_masked);
    similarities = [similarities; similarity];
    folder_names{end+1} = subdirs(i).name; % 记录对应的文件夹名称
end

% 计算统计量
mean_similarity = mean(similarities);
median_similarity = median(similarities);
std_similarity = std(similarities);
[max_similarity, max_idx] = max(similarities);
max_folder = folder_names{max_idx};

% 绘制相似性分布
figure;
histogram(similarities, 'Normalization', 'probability');
title('Similarity Distribution between zstat1s and zstat2smean ins2 WB');
xlabel('Similarity');
ylabel('Probability');

% 在图上添加统计量信息
stats_text = sprintf('Mean: %.4f\nMedian: %.4f\nStd Dev: %.4f\nMax: %.4f (Folder: %s)', ...
                     mean_similarity, median_similarity, std_similarity, max_similarity, max_folder);
text(0.7, 0.9, stats_text, 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'FontSize', 12);

% 保存图像
saveas(gcf, output_path);



% 定义目标文件夹路径
target_folder = '/public/home/gongwk/ukb_resttest/ins3';

% 获取目标文件夹下的所有子文件夹
subfolders = dir(target_folder);
subfolders = subfolders([subfolders.isdir]); % 只保留文件夹
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'})); % 排除当前和上一级文件夹

% 初始化一个空的cell数组来存储符合条件的子文件夹名称
valid_folders = {};

% 遍历每个子文件夹
for i = 1:length(subfolders)
    subfolder_path = fullfile(target_folder, subfolders(i).name);
    
    % 获取子文件夹中的所有文件
    files = dir(subfolder_path);
    files = files(~[files.isdir]); % 只保留文件
    
    % 检查是否只包含指定的文件
    if length(files) == 1 && strcmp(files.name, 'filtered_func_data_cleans.nii.gz')
        valid_folders{end+1} = subfolders(i).name; %#ok<AGROW>
    end
end

% 将符合条件的子文件夹名称保存为MAT文件
save('ukbins3restvalid.mat', 'valid_folders');



% 定义目标文件夹路径
target_folder = '/public/home/gongwk/ukb_resttest/ins2';

% 获取目标文件夹下的所有子文件夹
subfolders = dir(target_folder);
subfolders = subfolders([subfolders.isdir]); % 只保留文件夹
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'})); % 排除当前和上一级文件夹

% 初始化一个空的cell数组来存储符合条件的子文件夹名称
valid_folders = {};

% 遍历每个子文件夹
for i = 1:length(subfolders)
    subfolder_path = fullfile(target_folder, subfolders(i).name);
    
    % 获取子文件夹中的所有文件
    files = dir(subfolder_path);
    files = files(~[files.isdir]); % 只保留文件
    
    % 检查是否只包含指定的文件
    if length(files) == 1 && strcmp(files.name, 'filtered_func_data_cleans.nii.gz')
        valid_folders{end+1} = subfolders(i).name; %#ok<AGROW>
    end
end

% 将符合条件的子文件夹名称保存为MAT文件
save('ukbins2restvalid.mat', 'valid_folders');








% 定义目标文件夹路径
target_folder = '/public/home/gongwk/ukb_taskparforreal/ins2';

% 获取目标文件夹下的所有子文件夹
subfolders = dir(target_folder);
subfolders = subfolders([subfolders.isdir]); % 只保留文件夹
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'})); % 排除当前和上一级文件夹

% 初始化一个空的cell数组来存储符合条件的子文件夹名称
valid_folders = {};

% 遍历每个子文件夹
for i = 1:length(subfolders)
    subfolder_path = fullfile(target_folder, subfolders(i).name);
    
    % 获取子文件夹中的所有文件
    files = dir(subfolder_path);
    files = files(~[files.isdir]); % 只保留文件
    
    % 检查文件数量是否为5
    if length(files) == 5
        valid_folders{end+1} = subfolders(i).name; %#ok<AGROW>
    end
end

% 将符合条件的子文件夹名称保存为MAT文件
save('ukbins2taskvalid.mat', 'valid_folders');



% 定义目标文件夹路径
target_folder = '/public/home/gongwk/ukb_taskparforreal/ins3';

% 获取目标文件夹下的所有子文件夹
subfolders = dir(target_folder);
subfolders = subfolders([subfolders.isdir]); % 只保留文件夹
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'})); % 排除当前和上一级文件夹

% 初始化一个空的cell数组来存储符合条件的子文件夹名称
valid_folders = {};

% 遍历每个子文件夹
for i = 1:length(subfolders)
    subfolder_path = fullfile(target_folder, subfolders(i).name);
    
    % 获取子文件夹中的所有文件
    files = dir(subfolder_path);
    files = files(~[files.isdir]); % 只保留文件
    
    % 检查文件数量是否为5
    if length(files) == 5
        valid_folders{end+1} = subfolders(i).name; %#ok<AGROW>
    end
end

% 将符合条件的子文件夹名称保存为MAT文件
save('ukbins3taskvalid.mat', 'valid_folders');
