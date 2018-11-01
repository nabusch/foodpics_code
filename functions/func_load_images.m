function [img_info, img_mat] = func_load_images(img_dir)
% Loads all images located in folder "dir".
% Output:
% img_info: a table with information on all images.
% img_mat: a height x width x 3 x N matrix with the actual images.

%%
d = dir([img_dir '*.jpg']);

img_info = struct();

for i = 1:length(d)
    img_info(i).name = d(i).name;
    img_info(i).dir = img_dir;
    
    [path, this_file, ext] = fileparts([img_dir d(i).name]);
    if str2num(this_file) < 1000
        img_info(i).is_food = true;
    else
        img_info(i).is_food = false;
    end
    
    img_info(i).index = str2num(this_file);    
end

img_info = struct2table(img_info);

% Read information about first image to prealocate the image matrix.
tmpinf = imfinfo(fullfile(img_info.dir{1}, img_info.name{1}));
img_mat = uint8(zeros([tmpinf.Height, tmpinf.Width, 3, height(img_info)]));

%% Load images.
for ipic = 1:height(img_info)
    
    fprintf('Loading image %d of %d.\n', ipic, height(img_info))
    img_mat(:,:,:,ipic) = imread(fullfile(img_info.dir{ipic}, img_info.name{ipic}));
end

disp('Done.')
