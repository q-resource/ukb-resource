[data,~,~,head]=y_ReadAll('Insular_left.nii');

[data,~,~,head]=y_ReadAll('Dahl_LCmax_prob_MNI05.nii.gz');

% 1. 读取 .nii 文件
inputFile = 'Dahl_LCmax_prob_MNI05.nii.gz';  % 输入文件名
outputFile = 'Dahl_LCmax_prob_MNI3.nii.gz';  % 输出文件名

% 使用 y_ReadAll 读取数据
[data,~,~,head] = y_ReadAll(inputFile);

% 2. 获取原始体数据的尺寸
originalSize = size(data);

% 3. 设定新的体数据尺寸（3mm 每个维度）
% 从 0.5mm 到 3mm，体素尺寸变大了 6 倍
scaleFactor = 0.5 / 3.0001;  % 计算比例因子
newSize = floor(originalSize * scaleFactor);  % 计算新的体数据尺寸

% 使用 imresize3 进行下采样
resizedData = imresize3(data, newSize, 'nearest');  % 使用 'nearest' 以保持体数据的离散性
y_Write(resizedData,head,outputFile);
nnz(data)
