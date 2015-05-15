function [theta] = angle(pts)
% im=imread('lines.png');
% im_crop=imcrop(im);
% dim=size(BW);
% offsetX = dim(2)-1
% offsetY = dim(1)-1
% threshold = graythresh(im_crop);
% BW = im2bw(im_crop,threshold);
% BW = ~BW;
% imshow(BW)
% [row,col]=ginput(1);    % select point on each intersecting line
% row=round(row);col=round(col);  % make integers
% 
% edge = find(BW(:,col),1);
% 
% boundary1 = bwtraceboundary(BW, [row1, col1], 'SW', 8, 70,'counter');
% boundary2 = bwtraceboundary(BW, [row2, col2], 'NW', 8, 90);
% imshow(im); hold on;
% % draw traces in original image
% plot(offsetX+boundary1(:,2),offsetY+boundary1(:,1),'g','LineWidth',2);
% plot(offsetX+boundary2(:,2),offsetY+boundary2(:,1),'g','LineWidth',2);

A=pts(2,:)-pts(1,:);
B=pts(4,:)-pts(3,:);
theta=acosd(dot(A,B)/(norm(A,2)*norm(B,2)));
if theta>90
    theta=180-theta;
end
end

