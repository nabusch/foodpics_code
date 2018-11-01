% This script runs the image anaysis for the Foodprobe image set.

%%
clear; close all; clc
addpath('functions');

% Where are the image files located?
params.img_dir = 'C:\Users\nbusch\Desktop\FOOD IMAGES\imgs\';

% Where to save the analysis results.
params.results_dir = 'C:\Users\nbusch\Desktop\FOOD IMAGES\';

params.info_file = fullfile(params.results_dir, 'img_info.mat');
params.mat_file  = fullfile(params.results_dir, 'img_mat.mat');
params.prop_file = fullfile(params.results_dir, 'img_properties.mat');
params.do_overwrite = 1;


%% Load images and store them in a Matlab struct. You need to run this only
% once. Note: running this section overwrites any img_info file from a
% previous analysis. Automatically code if this image shows food or
% non-food. Note: convention is that all file names are numeric and numbers
% smaller 1000 are food, otherwise non-food.
if params.do_overwrite || ~exist(params.mat_file)
    [img_info, img_mat] = func_load_images(params.img_dir);
    save(params.info_file, 'img_info');
    save(params.mat_file, 'img_mat');
end


%% Load the .mat file with all images and compute image properties.
if params.do_overwrite || ~exist(params.prop_file)==2
    load(params.info_file);
    load(params.mat_file);
    img_properties = func_img_analysis(img_info, img_mat);
    save(params.prop_file, 'img_properties');
end


%% Compare the distributions of food and non-food images. Instead of 'sd',
% you can also enter any of the image features that are computed by
% func_runanalysis. A Wilcoxon test is used for testing if food/non food
% images have different distributions.
if ~exist('img_info')==1;       load(params.info_file); end
if ~exist('img_properties')==1; load(params.prop_file); end

nbins = 32; % number of bins for histogram plot
properties = {'sd', 'intensity', 'intensity_norm', 'complexity', 'complexity_norm'}; % names of properties to compare.

[img_compare, fig_h] = func_compare(img_info, img_properties, properties, nbins);


%% Show the most extreme images for a sanity check. Again, you can do this
% for any feature computed by func_runanalysis.
if ~exist('img_info')==1;       load(params.info_file); end
if ~exist('img_mat')==1;        load(params.mat_file); end
if ~exist('img_properties')==1; load(params.prop_file); end

properties = {'intensity', 'intensity_norm', 'complexity', 'complexity_norm'}; % names of properties to compare.
nimgs = 4; % show the nimgs images with highest/lowest values.
img_type = 'all'; % which images ot show: 'all', 'food', 'nonfood'
plotedges = 0; % visualize the edges within objects.

[fig_h] = func_plotexemplarpics(img_info, img_mat, img_properties, properties, nimgs, img_type, plotedges);


%% Write results to Excel
if ~exist('img_properties')==1; load(params.prop_file); end

out_properties = {
    'name',
    'is_food',
    'red',
    'green',
    'blue',
    'objectsize',
    'intensity',
    'intensity_norm',
    'sd',
    'complexity',
    'complexity_norm',
    'medianpow'
    };

out_table = img_properties(:, out_properties);
writetable(out_table, fullfile(params.results_dir, 'Results.xls'));

