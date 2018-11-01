function img_properties = func_img_analysis(img_info, img_mat)

%%
img_properties = struct();

npics = size(img_mat,4);

for ipic = 1:npics
    
    fprintf('Analyzing image %d of %d.\n', ipic, npics)
    
    img_properties(ipic).name = img_info.name(ipic);
    img_properties(ipic).is_food = img_info.is_food(ipic);
    
    thepic = img_mat(:,:,:,ipic);
    
    
    
    % Convert color image to gray.
    graypic = rgb2gray(thepic);
    
    
    % Extract the three color channels.
    Rpic = double(thepic(:,:,1));
    Gpic = double(thepic(:,:,2));
    Bpic = double(thepic(:,:,3));
    
    
    % Non-white pixels
    iNonWhite = graypic(:)~=255;
    nNonWhite = sum(iNonWhite);
    
    
    % Compute dimensions of the image.
    img_properties(ipic).image_pixels = size(graypic);
    
    
    % Compute how red/green/blue this object is. Nanmean is
    % necessary-otherwise any completely black pixels will cause the entire
    % variable to be NaN (division by zero).
    sumpic = sum(thepic,3);
    img_properties(ipic).red   = nanmean(Rpic(iNonWhite)./sumpic(iNonWhite));
    img_properties(ipic).green = nanmean(Gpic(iNonWhite)./sumpic(iNonWhite));
    img_properties(ipic).blue  = nanmean(Bpic(iNonWhite)./sumpic(iNonWhite));
    
    
    % Compute object size as proportion of non-white pixels.
    img_properties(ipic).objectsize = nNonWhite / numel(graypic);
    
    
    % Compute image intensity (i.e. non-whiteness). We compute the mean
    % luminance across all pixels, which is influenced both by the
    % intensity of the pixels and on the number of pixels.
    % We also compute "normed" intensity, which is proportional to th
    % enumber of non-white pixels. E.g. if the object is only two pixel
    % slarge, but these pixel shave maximum intensity (i.e. both a re
    % black), the intensity will be low due to the small number of pixels
    % while the normed intensity will be maximal.
    img_properties(ipic).intensity = 255 - mean(graypic(:));
    img_properties(ipic).intensity_norm = 255 - mean(graypic(iNonWhite));
    
    
    % Compute the standard deviation of gray levels (index of within-image
    % contrast).
    img_properties(ipic).sd = std(single(graypic(iNonWhite)));
    
    
    % Compute image "complexity" as the proportion of pixels representing
    % object edges. Bigger objects naturally have a larger outline and thus
    % more complexity. The norm_complexity accounts for that by dividing
    % the number of edges by the oject's size.
    medfiltpic = medfilt2(graypic, [12, 12],  'symmetric'); 
    alledges = edge(medfiltpic,'canny',0.1);      
    
    gaussfilter = fspecial('gaussian', [3 3], 3);
    alledges = 5.*imfilter(double(alledges), gaussfilter, 'replicate');

    img_properties(ipic).edges = single(alledges);
    img_properties(ipic).complexity      = sum(alledges(:)) / numel(graypic);
    img_properties(ipic).complexity_norm = sum(alledges(:)) ./ nNonWhite;
    
    
    % Compute 2D image power spectrum.
    img_properties(ipic).powspec   = single(Powspect(graypic)');
    img_properties(ipic).meanpow   = mean(img_properties(ipic).powspec(5:end));
    img_properties(ipic).medianpow = median(img_properties(ipic).powspec(5:end));
    
end

img_properties = struct2table(img_properties);

disp('Done.')
