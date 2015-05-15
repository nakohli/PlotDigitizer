%% Author - Naman Kohli - adapted from demo on Matlab Central for Delta E Color Segmentation
function [matchingColors] = getColorPlot( image , mask ,  bg)
    if nargin < 3
        bg = [ 255 , 255 , 255 ];
    end
    [rows,columns,~]=size(image);
    
    neighbour = 3;
	cform = makecform('srgb2lab');
	lab_Image = applycform(im2double(image),cform);
	L = lab_Image(:, :, 1); 
	a = lab_Image(:, :, 2); 
	b = lab_Image(:, :, 3); 
    
    LRegion = L(mask);
	LMean = mean(LRegion);
	aRegion = a(mask); 
	aMean = mean(aRegion);
	bRegion = b(mask);
	bMean = mean(bRegion);
    LVal = LMean * ones(rows, columns);
	aVal = aMean * ones(rows, columns);
	bVal = bMean * ones(rows, columns);
    deltaE = sqrt( (L - LVal) .^ 2 + (a - aVal) .^ 2 + (b - bVal) .^ 2);
	region = deltaE(mask);
    meanMaskedDeltaE = mean(region);
	% Get the standard deviation of the delta E in the mask region
	std_DeltaE = std(region);
    
    tolerance =  meanMaskedDeltaE + 3 * std_DeltaE;
    
    binaryImage = deltaE <= tolerance; 
    matchingColors = ones( size( image ) ) .* 255;
    for i = 1 : size(binaryImage , 1 )
        for j = 1 : size(binaryImage , 2 )
            if binaryImage(i,j) == 1
                matchingColors(i,j,:) = image(i,j,:);
            end
        end
    end
    
end