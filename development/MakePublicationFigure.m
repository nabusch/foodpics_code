%%
properties = {
'red'
'green'
'blue'
'objectsize'
'intensity'
'sd'
'complexity'
'norm_complexity'
'meanpow'
'medianpow'    
};

n_properties = length(properties);
n_exemplars  = 3;

FoodId    =  find([all_images.isFood]==1);
nonFoodId =  find(~[all_images.isFood]);

food_images    = all_images(FoodId); % Only food images
nonfood_images = all_images(nonFoodId); % Only food images

%%
showImages = food_images;
% showImages = nonfood_images;

h = figure;
set(h, 'color', 'w', 'numbertitle', 'off', 'defaulttextinterpreter','none')

iplot = 0;

for iprop = 1:n_properties

    property_values = [showImages.(properties{iprop})];
    [sort_values, sort_indices] = sort(property_values);
    
    min_indices = sort_indices(1:n_exemplars);
    max_indices = sort_indices(end-(n_exemplars-1):end);
    all_indices = [min_indices max_indices];
    
    for iimage = 1:length(all_indices)
        img = imread(fullfile(showImages(all_indices(iimage)).path, showImages(all_indices(iimage)).name));   
    
        iplot = iplot+1;
        subplot(n_properties, 2*n_exemplars, iplot) 
            ih1 = image(img); hold on;
            axis square
            axis off
            if iimage == 1
                t = text(-80, 0.5*size(img,1), properties{iprop});
                set(t, 'rotation', 90, 'horizontalalignment', 'center')
            end
    end
        
end
