
color = {'black'};
clc
clf
x1all =[  182.3537;303.6769;422.0044;248.2576];
y1all =[  124.0699;  122.5721;  115.0830; 498.5240];
figure, imshow(ColourImage)
hold on;
plot(x1all(1,1), y1all(1,1), 'b+', 'MarkerSize', 5, 'LineWidth', 3);
hold on;
plot(x1all(2,1), y1all(2,1), 'b+', 'MarkerSize', 5, 'LineWidth', 3);
hold on;
plot(x1all(3,1), y1all(3,1), 'b+', 'MarkerSize', 5, 'LineWidth', 3);
hold on;
plot(x1all(4,1), y1all(4,1), 'b+', 'MarkerSize', 5, 'LineWidth', 3);
hold on;
plot(x1all(5,1), y1all(5,1), 'b+', 'MarkerSize', 5, 'LineWidth', 3);



for i = 1: NoTxs   
    x1 = x1all(i,1); 
    y1 = y1all(i,1);
%     plot(ceil(x1),ceil(y1),'*');
%     hold on;
    ColourImage = insertMarker(ColourImage,[x1 y1],'*','size',15,'color','black');
   % ColourImage = insertMarker(ColourImage,[x2 y2],'o','size',4,'color','red');
end
imshow(ColourImage);

  ColourImage = insertMarker(ColourImage,[x1 y1],'*','size',5,'color','black');
%    ColourImage = insertMarker(ColourImage,[x2 y2],'o','size',4,'color','red');


% for u = i: NoTxs
%     line([x1all(1,1) x1all(2,1)],[y1all(1,1) y1all(2,1)],'Color','black','Marker','*')% 'LineWidth',0.001,
% end


