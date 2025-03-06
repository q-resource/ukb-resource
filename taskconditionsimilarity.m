% ????
baseDir = '/public/home/gongwk/ukbtaskfc/ins3parforL';
templateFile = 'MNI152_T1_3mm_brain_mask.nii'; % MNI3mm????
templateData = y_ReadAll(templateFile);

% ?????????
corrValues = [];

% ?????
folders = dir(baseDir);
for i = 1:length(folders)
    if folders(i).isdir && ~strcmp(folders(i).name, '.') && ~strcmp(folders(i).name, '..')
        folderPath = fullfile(baseDir, folders(i).name);
        
        % ????????
        file1 = fullfile(folderPath, 'BETA_Subject001_Condition001_Source001.nii');
        file2 = fullfile(folderPath, 'BETA_Subject001_Condition002_Source001.nii');
        
        if isfile(file1) && isfile(file2)
            % ??NIfTI??
            data1 = y_ReadAll(file1);
            data2 = y_ReadAll(file2);
            
            % ??????
            brainData1 = data1(find(templateData > 0));
            brainData2 = data2(find(templateData > 0));
            
            % ?????
            corrVal = corr(brainData1, brainData2);
            corrValues = [corrValues; corrVal];
        end
    end
end

% ????????
figure;
histogram(corrValues, 'Normalization', 'probability');
xlabel('????');
ylabel('??');
title('???????????');
saveas(gcf, 'correlation_distribution.png');  % ???PNG??