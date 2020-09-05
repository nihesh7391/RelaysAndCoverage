% this is main program
%It calculates RSSI for pixels and generates heat map
clc;   close all;

global GrayScaleImage ReceiverSensitivity PtIndBm f_operation tx_h rx_h
ReceiverSensitivity     = -110; % in dBm
PtIndBm                 = 14;   % in dBm
ScaleResize             = 6;  
NoTxs                   = 3;
XdistM                  = 1.52*1000;
YdistM                  = 2.09*1000;
f_operation             = 868; %in MHz
tx_h                    = 1; %in meters
rx_h                    = 1; %in meters
ColourImage             = imread('IISc_5regions.jpg');
%ColourImage             = imread('kakinada_medium.jpeg');
[Yactual, Xactual, ~]   = size(ColourImage);
ColourImage             = imresize(ColourImage,(1/ScaleResize));
GrayScaleImage          = ImagePreProcess_5regions(ColourImage);% to generate a GrayScaleImage of IISc
% imshow(ColourImage);  % display IIScColourImage
xscale                  =  0.6655 * ScaleResize; % (XdistM/Xactual)
yscale                  =  0.6682 * ScaleResize; % (YdistM/Yactual)
[Y,X]                   = size(GrayScaleImage);
% center                  = size(GrayScaleImage)/2 + 0.5;
% x1all                   = ceil(X/2 + 0.5);
% y1all                   = ceil(Y/2 + 0.5);
%[x1all, y1all]          = ginput(NoTxs); % taking input from the user.


x1all = [91.0005; 412.8548; 144.9786;]; %[218.3013; 101.4716; 180.8559;  335.1310;  288.6987];  %6*180.8559;
y1all = [431.1228; 510.1275; 259.6602;]; %[321.7817; 555.4410; 255.8777;  378.6987;  109.0917];  %6*255.8777;
% NoTxs = 1;%length(x1all);
%csvwrite('TxPositions.csv',ceil([x1all, y1all]));
%x1all = [125.4367;  381.5633];
%y1all = [155.5240;  148.0349];
RSSIall                 = zeros(Y,X,NoTxs);

for t = 1: NoTxs 
    t
    [x1,y1]         = deal(x1all(t,1),y1all(t,1));
    RSSI         = Algo_RSSI(x1,y1,xscale,yscale,X,Y);
    % RSSI            = Algo_RSSI_spiral(x1,y1,xscale,yscale,X,Y);
    RSSIall(:,:,t)  = RSSI;
end
   
MaxRSSI = max(RSSIall,[],3); % for multiple transmitters
figure;
R       = imagesc(MaxRSSI);
colorbar;
map     = colormap('Hot');
axis image;
axis off;

% SNR = max(RSSIall,[],3) - min(RSSIall,[],3) ; 
% figure;
% R       = imagesc(SNR);
% colorbar;
% map     = colormap('Hot');
% axis image;
% axis off;

ToPlotOnIIScMap; % this function does impose the RSSI values on the ColourMap
