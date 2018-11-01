i = 478;
img = imread([all_images(i).path all_images(i).name]);
graypic = rgb2gray(img);

% Median filter for reducing image noise
graypic = medfilt2(graypic, [16, 16],  'symmetric'); 

th = [0.1:0.1:0.99];
[nrows, ncols] = my_subplotlayout(length(th));


figure(1);
for i = 1:length(th)
    
    subplot(nrows, ncols, i)
    alledges = edge(graypic,'canny',th(i));
    
    gaussfilter = fspecial('gaussian', [15 15], 5);
    alledges = 10.*imfilter(double(alledges), gaussfilter, 'replicate');

    ih1 = image(img); 
    set(ih1, 'alphadata', 0.8)
    hold on;
    axis off

    r=zeros(size(img));
    r(:,:,1) = 1;

    ih2=image(r);
    set(ih2, 'AlphaData', alledges); 
end

