% 设置主目录路径
main_dir = '/public/home/gongwk/ukbtaskfc/ins3parforL';
[datass,~,~,headss]=y_ReadAll('/public/home/gongwk/ukbtaskfc/ins3parforL/1301013/BETA_Subject001_Condition001_Source001.nii');
% 获取主目录下的所有文件夹
subfolders = dir(main_dir);
subfolders = subfolders([subfolders.isdir]);  % 仅保留文件夹
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));  % 去掉 '.' 和 '..' 目录

% 初始化变量用于累加 nii 文件数据
sum_data = [];
file_count = 0;

% 循环遍历每个子文件夹
for i = 1:length(subfolders)
    subfolder_path = fullfile(main_dir, subfolders(i).name);
    nii_file_path = fullfile(subfolder_path, 'BETA_Subject001_Condition002_Source001.nii');
    
    if exist(nii_file_path, 'file')
        % 读取 nii 文件
        nii_data = y_ReadAll(nii_file_path);
        
        % 累加数据
        if isempty(sum_data)
            sum_data = nii_data;
        else
            sum_data = sum_data + nii_data;
        end
        
        file_count = file_count + 1;
    end
end

% 计算平均值
mean_data = sum_data / file_count;

% 保存平均值为新的 nii 文件
mean_nii_file_path = fullfile(main_dir, 'BETA_Subject001_Condition002_Source001_mean.nii');
y_Write(mean_data, headss, mean_nii_file_path);
