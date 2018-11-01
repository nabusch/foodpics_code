function pow = powspect(img)
% Kindly provided by Maximilien Chaumon.

if ndims(img) == 3
    % If it's a color image we collapse RGB --> grayscale
    img = rgb2gray(img);
end

Im_fft2 = fft2(img);% fast fourier
Im_pow2_ls = fftshift(log(1 + abs(Im_fft2).^2)); % power spectrum
% compute the circular mean
pow = circmean(Im_pow2_ls);

return

function avg = circmean(mat)
% Computes radial average of mat.
% avg is a vector of length half the length of mat.
% adapted from raPsd2d.m E. Ruzanski, RCG, 2009
% Maximilien Chaumon 2010.

%% Process image size information
[N M] = size(mat);

%% Adjust mat size
dimDiff = abs(N-M);
dimMax = max(N,M);
% Make square
if N > M                                                                    % More rows than columns
    if ~mod(dimDiff,2)                                                      % Even difference
        imgfp = [NaN(N,dimDiff/2) mat NaN(N,dimDiff/2)];                  % Pad columns to match dimensions
    else                                                                    % Odd difference
        imgfp = [NaN(N,floor(dimDiff/2)) mat NaN(N,floor(dimDiff/2)+1)];
    end
elseif N <= M                                                                % More columns than rows
    if ~mod(dimDiff,2)                                                      % Even difference
        imgfp = [NaN(dimDiff/2,M); mat; NaN(dimDiff/2,M)];                % Pad rows to match dimensions
    else
        imgfp = [NaN(floor(dimDiff/2),M); mat; NaN(floor(dimDiff/2)+1,M)];% Pad rows to match dimensions
    end
end

%% Radial average
[X Y] = meshgrid(-dimMax/2:dimMax/2-1, -dimMax/2:dimMax/2-1);               % Make Cartesian grid
[theta rho] = cart2pol(X, Y);                                               % Convert to polar coordinate axes
rho = round(rho);
i = cell(floor(dimMax/2) + 1, 1);
for r = 0:floor(dimMax/2)
    i{r + 1} = find(rho == r);
end
avg = zeros(1, floor(dimMax/2)+1);
for r = 0:floor(dimMax/2)
    avg(1, r + 1) = nanmean( imgfp( i{r+1} ) );
end
