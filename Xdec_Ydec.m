function MatrixXYLs = Xdec_Ydec(x1,y1,x2,y2,xscale,yscale)
          
            Xcross          = ceil(x2):floor(x1);
            Ycross          = ceil(y2):floor(y1);
            LineSlope       = (y2-y1)/(x2-x1);
            Yintercept      = y2-(LineSlope*x2);
            Ymatrix         = LineSlope.*Xcross + Yintercept;
            Xmatrix         = (Ycross-Yintercept)/LineSlope;
            XYvalues        = cat(1,Xcross,Ymatrix)'; % size(XYvalues) = 2,size(t) ...(x,y) values 
            YXvalues        = cat(1,Xmatrix,Ycross)';% for a given y values say y=1,2,3 obtain x values           
                        
            if (LineSlope == 1)            
                PixelIntersect = cat(1,ceil(transpose(cat(1,Xcross+1,Ymatrix+1))),ceil([x2,y2]));
                Values         = cat(1,XYvalues,[x2,y2]); 
            else
                PixelIntersect = cat(1,ceil(transpose(cat(1,Xcross+1,Ymatrix))),ceil(transpose(cat(1,Xmatrix,Ycross+1))),ceil([x2,y2]));
                Values         = cat(1,XYvalues,YXvalues,[x2,y2]); %Values give all the x-y co-ordinates
            end              
                            
            XY               = repmat([x1, y1],size(Values,1),1);              % transmitter location replicated
            Lengths          = sqrt(sum((Values - XY).*(Values - XY),2)); % distances to the transmitter
            MatrixXYL        = cat(2,PixelIntersect,Lengths);           % x, y co-ordinates and the lengths to the transmitter
            MatrixXYL        = sortrows(MatrixXYL,3);            
            MatrixXYScaledLs = Scaling_Lengths(MatrixXYL,x1,y1,x2,y2,xscale,yscale);
            MatrixXYLs       = Length_Proportions(MatrixXYScaledLs) ;  
         
    end

