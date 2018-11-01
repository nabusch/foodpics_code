function [fig_h] = func_plotexemplarpics(img_info, img_mat, img_properties, properties, nimgs, img_type, plotedges);
%%
% Create a figure with exemplar images, that represent the most extreme
% values (minimum and maximum) of an image feature.
    
food_id     = find(img_info.is_food==1);
non_food_id = find(img_info.is_food==0);
switch img_type
    case 'all' % all images
        idx = 1:height(img_info);
        
    case 'food' % only food images
        idx = find(img_info.is_food==1);
        
    case 'nonfood' % only non-food images
        idx = find(img_info.is_food==0);
        
    otherwise
        disp('Wrong image type'); return
end

images = img_mat(:,:,:,idx); 
info   = img_info(idx, :);
props  = img_properties(idx, :);

fig_h = figure;
set(fig_h, 'color', 'w', 'defaulttextinterpreter','none')



for iprop = 1:length(properties)

    field = properties{iprop};    
    
    if strcmpi(field, 'powspec') == 1
        prop_vals = median(props{:,field});
    else
        prop_vals = props{:,field};
    end

    [sortvals, sortidx] = sort(prop_vals ,'ascend');
    
    sortvals = sortvals([1:nimgs, end-(nimgs-1):end]);
    sortidx  = sortidx([1:nimgs, end-(nimgs-1):end]);
    
    for i = 1:nimgs*2
        subplot(length(properties), nimgs*2, sub2ind([nimgs*2 length(properties)], i, iprop))
        hold all
        
        im_h =imshow(images(:,:,:,sortidx(i))); 
        title(sprintf('%s = %3.3f', field, sortvals(i)))
        xlabel(info.name(sortidx(i)))
                
        if plotedges
            r = zeros(size(images(:,:,:,sortidx(i))));
            r(:,:,1) = 118/255;
            r(:,:,2) = 238/255;
            r(:,:,3) = 0;
            
            set(im_h, 'alphadata', 0.8)
            im_h2 = image(r);
            set(im_h2, 'AlphaData', cell2mat(img_properties.edges(sortidx(i))));
        end
    end    
end
