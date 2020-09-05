function MatrixXYLs = Xdec_Ysame(x1,y1,x2,y2,xscale)
   
    Xcross           = floor(x1):-1:ceil(x2);
    Ymatrix          = repmat(y1,size(Xcross,2),1)';
    XYvalues         = cat(1,Xcross,Ymatrix)';% for a given y values say y=1,2,3 obtain x values
    PixelIntersect   = cat(1,ceil(transpose(cat(1,Xcross+1,Ymatrix))),ceil([x2,y2]));
    Values           = cat(1,XYvalues,[x2,y2]);      % Values give all the x-y co-ordinates
    XY               = repmat([x1 y1],size(Values,1),1); % transmitter location replicated  
    Lengths          = abs(sum((Values-XY),2));     % distances to the transmitter
    MatrixXYScaledLs = cat(2,PixelIntersect,Lengths.*xscale); 
    MatrixXYLs       = Length_Proportions(MatrixXYScaledLs) ; 

end
