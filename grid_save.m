clc;
clear all;
close all;

global GrayScaleImage ReceiverSensitivity PtIndBm
ReceiverSensitivity     = -110; % in dBm
PtIndBm                 = 14;   % in dBm
ScaleResize             = 6;  
ColourImage             = imread('IISc_5regions.jpg');
ColourImage             = imresize(ColourImage,(1/ScaleResize));
GrayScaleImage          = ImagePreProcess_5regions(ColourImage);
xscale                  =  0.6655 * ScaleResize; % (XdistM/Xactual)
yscale                  =  0.6682 * ScaleResize; % (YdistM/Yactual)
[Y,X]                   = size(GrayScaleImage);

grid_size = 20;
x_range = floor(X/grid_size);
y_range = floor(Y/grid_size);

for i=1:x_range
    for j=1:y_range
        string(20*i)+' '+string(20*j)
        x1 = 20*i - 0.5;
        y1 = 20*j - 0.5;
        RSSI = Algo_RSSI(x1,y1,xscale,yscale,X,Y);
        parsave('coverage_files/'+string(20*i)+'_'+string(20*j)+'.mat', RSSI)
    end
end

function parsave(fname, RSSI)
  save(fname, 'RSSI')
end