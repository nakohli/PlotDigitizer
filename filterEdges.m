function [ filteredImage ] = filterEdges ( IMo )

    IMbw = imcomplement(im2bw(IMo,graythresh(IMo)));
    IMbw=bwmorph(IMbw,'skel',Inf);
    IMbw=bwmorph(IMbw,'spur',10);
    IMbw=bwmorph(IMbw,'clean',Inf);
    IMbw=bwareaopen(IMbw,50);
    filteredImage = imcomplement( IMbw );
    filteredImage = uint8 ( filteredImage )*255 ;
    filteredImage = cat( 3 , filteredImage , filteredImage , filteredImage ); 
end