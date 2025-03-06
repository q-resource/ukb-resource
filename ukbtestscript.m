[data1,~,~,head1]=y_ReadAll('BETA_Subject001_Condition001_Source001_mean_副本.nii');
[data2,~,~,head2]=y_ReadAll('BETA_Subject001_Condition002_Source001_mean_副本.nii');
datacontrast=data1-data2;
y_Write(datacontrast,head1,'LAmygdala_contrast');







% 读取 3D 体积影像 (例如 NIfTI 文件)
[data,~,~,head]=y_ReadAll('Dahl_LCmax_prob_MNI05.nii.gz'); % 读取 .nii 文件

% 原始体积大小
original_size = size(V);

% 计算目标大小，将每个维度缩小到原来的一半
target_size = round(original_size / 2);

% 将体积影像缩放到 1mm 分辨率 (即缩小一半)
resized_V = imresize3(V, target_size);

% 如果需要保存为新的 NIfTI 文件
niftiwrite(resized_V, 'resized_image.nii');

% 显示缩放前后的体积大小
disp(['Original Size: ', mat2str(original_size)]);
disp(['Resized Size: ', mat2str(target_size)]);
