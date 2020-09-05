 function MatrixXYLs = Xinc_Ysame(x1,y1,x2,y2,xscale)

    Xcross           = ceil(x1):floor(x2);                       
    Ymatrix          = repmat(y1,size(Xcross,2),1)';            
    XYvalues         = cat(1,Xcross,Ymatrix)';    % size(XYvalues) = 2,size(t) ...(x,y) values             
    PixelIntersect   = cat(1,ceil(XYvalues),ceil([x2,y2]));
    Values           = cat(1,XYvalues,[x2,y2]);           %  Values give all the x-y co-ordinates
    XY               = repmat([x1 y1],size(Values,1),1);      % transmitter location replicated            
    Lengths          = sum((Values-XY),2);
    MatrixXYScaledLs = cat(2,PixelIntersect,Lengths.*xscale);
    MatrixXYLs       = Length_Proportions(MatrixXYScaledLs) ; 

 end
     