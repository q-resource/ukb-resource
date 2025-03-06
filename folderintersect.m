aa = load("ukbins2taskvalid.mat");
aa=aa.valid_folders;
bb = load("ukbins3taskvalid.mat");
bb=bb.valid_folders;
cc=load("ukbins3restvalid.mat");
cc=cc.valid_folders;


abab=intersect(aa,bb);
task23valid=abab;
save("ukbtask23valid.mat","task23valid");



bcbc=intersect(bb,cc);
taskrest33valid=bcbc;
save("ukbtaskrest33valid.mat","taskrest33valid");




dd=load("ukbins2restvalid.mat");
dd=dd.valid_folders;


cdcd=intersect(cc,dd);
rest23valid=cdcd;
save("ukbrest23valid.mat","rest23valid");
adad=intersect(aa,dd);
taskrest22valid=adad;
save("ukbtaskrest22valid.mat","taskrest22valid");
abcd=intersect(adad,bcbc);
taskrest2323valid=abcd;
save("ukbtaskrest2323valid.mat","taskrest2323valid");
%还差统计rest2，3都有的和taskrest2都有的，和四个都有的


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