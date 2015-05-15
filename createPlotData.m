function data = createPlotData( image , stepSize )
    if nargin < 2
        stepSize = 5;
    end
    image = im2uint8(image);
    myfilter = fspecial('gaussian',[3 3], 0.5);
    myfilteredimage = imfilter(image, myfilter, 'replicate');
    data_temp = im2bw( myfilteredimage );
    g = bwmorph( data_temp , 'thin' , 0.1 );
    g = ~g;
    t = uint8(g);
    data = [];
    row = size( image , 1 );
    col = size( image , 2 );
    for i = 1 : stepSize : row
        for j = 1 : stepSize : col
            if i+stepSize-1 < row && j+stepSize-1<col
                val = g( i : i + stepSize - 1 , j : j + stepSize - 1 ); 
                t( i : i + stepSize - 1 , j : j + stepSize - 1 ) = 0.5; 
            elseif i+stepSize-1 > row && j+stepSize-1<col
                val = g( i : end , j : j + stepSize - 1 ); 
            elseif i+stepSize-1 < row && j+stepSize-1 > col
                val = g( i : i + stepSize - 1 , j : end ); 
            else
                val = g( i : end , j : end ); 
            end
            d = sum(sum(val));
            if d > 0
                data = [ data ; i+(stepSize)/2 j+(stepSize)/2 ]; 
            end
            
        end
    end
    
end