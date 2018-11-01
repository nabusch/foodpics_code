function [img_compare, fig_h] = func_compare(img_info, img_properties, properties, nbins);

%%
% Create a figure with exemplar images, that represent the most extreme
% values (minimum and maximum) of an image feature.

% Which images represent food/nonfood?
food_id     = find(img_info.is_food==1);
non_food_id = find(img_info.is_food==0);

img_compare = struct();

fig_h = figure;
set(fig_h, 'color', 'w', 'defaulttextinterpreter','none')
[rows, cols] = my_subplotlayout(length(properties));

lcolors = lines(2);

for iprop  = 1:length(properties)
    
    field = properties{iprop};
    
    % Get data on image properties for food/nonfood images.
    data{1,:} = img_properties{food_id, field};% the relevant data (e.g. sd or poewr spectra)
    data{2,:} = img_properties{non_food_id, field};
    
    if my_ndims(data{1}) == 2 % necessary for power spectra
        data{1}    = mean(data{1}, 2);
        data{2}    = mean(data{2}, 2);
    end
    
    % Compute statistical difference.
    [P,H,STATS] = ranksum(data{1}, data{2});
    
    % Write results to output table.
    img_compare(iprop).property = field;
    img_compare(iprop).n_food = length(food_id);
    img_compare(iprop).n_non_food = length(non_food_id);
    img_compare(iprop).vals_food = data(1);
    img_compare(iprop).vals_non_food = data(2);    
    img_compare(iprop).zval = STATS.zval;
    img_compare(iprop).ranksum = STATS.ranksum;
    img_compare(iprop).pval = P;
    
    % Plot results to figure;    
    subplot(rows, cols, iprop); hold all    
    for i = 1:2        
        bin_edges = linspace(min(data{i}), max(data{i}), nbins);
        
        % Compute the number of observations in each bin of the histogram.
        [n, bin] = histc(data{i}, bin_edges);
        
        % Convert to relative histogram.
        p = n ./ length(data{i});
        
        % Plot histogram as line plot.
        plot_h = plot(bin_edges, p, '-o', 'color', lcolors(i,:));
        set(plot_h, 'MarkerFaceColor', lcolors(i,:), 'MarkerSize', 2);
    end
    
    
    legend('food', 'non-food')
    xlabel(field, 'fontsize', 10, 'fontweight', 'bold')
    ylabel('proportion', 'fontsize', 10, 'fontweight', 'bold')
    title(['Histogram of ' field ' values'], 'fontsize', 12, 'fontweight', 'bold')    
    text(max(get(gca, 'XLim')),mean(get(gca, 'YLim')), sprintf('p=%0.3f', P), 'HorizontalAlignment', 'right')

    yl = get(gca, 'ylim');
    line([median(data{1}) median(data{1})], [yl(1) yl(2)], 'linestyle', ':', 'color', lcolors(1,:))
    line([median(data{2}) median(data{2})], [yl(1) yl(2)], 'linestyle', ':', 'color', lcolors(2,:))
        
end

img_compare = struct2table(img_compare);
