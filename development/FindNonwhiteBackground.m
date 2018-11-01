% Images in this database are supposed to be cropped and be placed on a
% purely white background. We realized that some images had backgrounds
% that were not entirely white. Rather, it looked like the background
% surrounding the objects was removed by hand using an "eraser" tool, and
% parts of the background were not completely erased, i.e. not perfectly
% white. This leads to problems for image analyses that are based on the
% number of non-white pixels, assuming that anything non-white is part of
% the object, not the background.
%
% This script tries identifying these images by checking if the pixels of
% the four corners of the image are actually white, assuming that these
% pixels can be safely assumed to be background in every image.

for iimage = 1:length(all_images)
    
    fprintf('%d\n', iimage)
    img = imread(fullfile(all_images(iimage).path, all_images(iimage).name));   
    
    corner(iimage,1) = mean(squeeze(img(1,1,:)) == [255, 255, 255]');
    corner(iimage,2) = mean(squeeze(img(1,end,:)) == [255, 255, 255]');
    corner(iimage,3) = mean(squeeze(img(end,1,:)) == [255, 255, 255]');
    corner(iimage,4) = mean(squeeze(img(end,end,:)) == [255, 255, 255]');
    
end

%%
nonwhite_corners = sum(corner, 2) ~= 4;

problematic_images = find(nonwhite_corners);

names = {all_images(problematic_images).name};
