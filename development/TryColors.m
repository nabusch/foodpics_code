% Sanity check to make sure that computation of color content gives the
% expected results.

i = 532;
img = imread([all_images(i).path all_images(i).name]);
graypic = rgb2gray(img);

% Non-white pixels
iNonWhite = graypic(:)~=255;
nNonWhite = sum(iNonWhite);

    Rpic = double(img(:,:,1));
    Gpic = double(img(:,:,2));
    Bpic = double(img(:,:,3));
    
    Rpic(~iNonWhite)=NaN;
    Gpic(~iNonWhite)=NaN;
    Bpic(~iNonWhite)=NaN;

% Compute how red/green/blue this object is. Nanmean is
% necessary-otherwise any completely black pixels will cause the entire
% variable to be NaN (division by zero).
sumpic = sum(img,3);
red   = nanmean(Rpic(iNonWhite)./sumpic(iNonWhite));
green = nanmean(Gpic(iNonWhite)./sumpic(iNonWhite));
blue  = nanmean(Bpic(iNonWhite)./sumpic(iNonWhite));

figure
subplot(1,4,1)
image(img)
title(['r: ' num2str(red) ', g: ' num2str(green) ', b: ' num2str(blue)])

subplot(1,4,2)
imagesc(Rpic./sumpic)
subplot(1,4,3)
imagesc(Gpic./sumpic)
subplot(1,4,4)
imagesc(Bpic./sumpic)
