% This program does impose the RSSI values computed by MainProgram on IISc
% Colour map.
% The input to this program is RSSI_all matrix.

MaxRSSI  = max(RSSIall,[],3);
%MaxRSSI = max(RSSIall,[],3) - min(RSSIall,[],3) ; 
R        = imagesc(MaxRSSI);
map      = colormap('Hot'); % one can change the colours by changing 'Hot'
colorbar;
axis image;
axis off;

k        = (MaxRSSI <= ReceiverSensitivity);
%k        = (MaxRSSI >= 30);
g        = repmat(k,1,1,3);
g1       = mat2gray(get(R, "cdata")); 
x        = gray2ind(g1, size(map,1));
rgb      = ind2rgb(x,map);
new_im   = im2double(ColourImage);
new_im2  = new_im.*double(g) + rgb.*double(~g);
imshow(new_im2);
imwrite(new_im2, 'Result.jpg');
%{
new = rgb.* double(g);
new_im2 = new_im.*double(g) + rgb.*double(~g);

%{
figure ; subplot(121); imshow(ColourImage); title('Original Image');
hold on;
for i = 1 : No_of_Txs
    plot(x1_all(i), y1_all(i), 'r*');
end
hold off
%}
%subplot(122); imshow(R); title('Heat Map'); colorbar('southoutside');

%subplot(122);
figure;imshow(new_im); title('Heat Map layer on Image');
%c = colorbar('location','southoutside');
%set(c,'location','southoutside');
%set(c,'Fontsize',8);


%}