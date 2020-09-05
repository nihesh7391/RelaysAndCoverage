%clc; clear all; close all;

Coordinates   = csvread('ConnectedNodes.csv'); % keeps changing 
q             = size(Coordinates,1);
temp1         = zeros(q-1,2,3);
temp1(:,:,1)  = ceil(Coordinates(1:q-1,4:5));
temp2         = ceil(Coordinates(:,1:3));

for h = 1 : q-1
    for m = 1 : 2
        z = temp1(h,m,1);
        temp1(h,m,2:3) = temp2(z,2:3);                
    end
end
%line([temp1(:,1,2) temp1(:,2,2)],[temp1(:,1,3) temp1(:,2,3)])
%ColourImage          = imread('IISc_5regions_NoOutline_700_cropped.jpg');
%Scale_Resize         = 6;  
%ColourImage          = imresize(ColourImage,(1/Scale_Resize));

imshow(ColourImage);
for u = 1: q -1
    line([temp1(u,1,2) temp1(u,2,2)],[temp1(u,1,3) temp1(u,2,3)],'Color','black','LineWidth',1,'Marker','*')
end

%{
hold on;
%pos   = [x1all y1_all];
color = { 'black'};
R1 = temp2(:,2:3);%[291 241;286 258];%; 250 284
%R2 = [249.7161399	283.749926; 250 2848];
RGB = insertMarker(ColourImage,R1,'*','color',color,'size' ,10);
%RGB = insertMarker(RGB,R1,'+','size',10);
imshow(RGB)


-----------------------------------------------------------------
t     = [1 2; 2 2; 3 6; 5 5 ; 3.63	4.97];
dist  = pdist(t);
Z     = squareform(dist);
[m,n] = size(Z);
t     = Z .* tril(ones(m,n));
ind   = find(t);
[I,J] = ind2sub([m,n],ind);
r_c   = [I J];
r_c_dist = [I J transpose(dist)];
temp1 = sortrows(r_c_dist,3);
%temp2 = sparse(I, J, transpose(dist));


------------- test marker ---------------
I = imread('autumn.tif');
%I = imread('IISc_5regions_NoOutline_700_cropped.jpg');
RGB = insertMarker(I,[147 279]);
pos   = [120 248;195 246;195 312;120 312]; 
color = {'red','white','green','magenta'};
RGB = insertMarker(RGB,pos,'x','color',color,'size',20); 
imshow(RGB);
%}

