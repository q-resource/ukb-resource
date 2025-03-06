% 读取两个模板文件
[Template1,~,~,headt] = y_ReadAll('Schaefer2018_200Parcels_7Networks_order_FSLMNI152_2mm.nii.gz');
Template2 = y_ReadAll('Tian_Subcortex_S1_3T.nii.gz');

% 将编号从0-16的部分编号从201开始依次累加
Template2(Template2 > 0) = Template2(Template2 > 0) + 200;
CombinedTemplate=Template1;
CombinedTemplate(Template1 == 0) = Template2(Template1 == 0);


% 保存合并后的模板
y_Write(CombinedTemplate, headt, 'CombinedTemplate_0_216.nii');







% 读取模板文件
[Template,~,~,head] = y_ReadAll('CombinedTemplate_0_216_2mm.nii');

% 获取当前模板的尺寸和体素大小
original_size = size(Template);
voxel_size = [2 2 2]; % 原始体素尺寸为2毫米

% 计算新的尺寸比例
new_voxel_size = [3 3 3]; % 目标体素尺寸为3毫米
resize_factor = voxel_size ./ new_voxel_size;

% 使用imresize3进行体积重采样
ResampledTemplate = imresize3(Template, round(original_size .* resize_factor), 'nearest');

% 保存重新采样后的模板
y_Write(ResampledTemplate,head, 'CombinedTemplate_0_216_3mm.nii');

