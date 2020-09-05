% MaxRSSI  = max(RSSIall,[],3);
SNR = max(RSSIall,[],3) - min(RSSIall,[],3) ; 
R        = imagesc(SNR);
map      = colormap('Hot'); % one can change the colours by changing 'Hot'
colorbar;
axis image;
axis off;

% k        = (MaxRSSI <= ReceiverSensitivity);
k        = (SNR >= 50);
g        = repmat(k,1,1,3);
g1       = mat2gray(R.CData); 
x        = gray2ind(g1, size(map,1));
rgb      = ind2rgb(x,map);
new_im   = im2double(ColourImage);
new_im2  = new_im.*double(~g) + rgb.*double(g);
imshow(new_im2);