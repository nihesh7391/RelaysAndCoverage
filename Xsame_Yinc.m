function MatrixXYLs = Xsame_Yinc(x1,y1,x2,y2,yscale)
   
    Ycross           = ceil(y1) : floor(y2);
    Xmatrix          = repmat(x1,size(Ycross,2),1)';
    YXvalues         = cat(1,Xmatrix,Ycross)';% for a given y values say y=1,2,3 obtain x values
    PixelIntersect   = cat(1,ceil(transpose(cat(1,Xmatrix,Ycross))),ceil([x2,y2]));
    Values           = cat(1,YXvalues,[x2,y2]);       % Values give all the x-y co-ordinates
    XY               = repmat([x1 y1],size(Values,1),1);  % transmitter location replicated 
    Lengths          = sum((Values-XY),2);    
    MatrixXYScaledLs = cat(2,PixelIntersect,Lengths.*yscale); % x, y co-ordinates and the lengths to the transmitter
    MatrixXYLs       = Length_Proportions(MatrixXYScaledLs) ; 
        
end