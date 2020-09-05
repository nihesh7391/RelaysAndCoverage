function MatrixXYScaledLs = Scaling_Lengths(MatrixXYL,x1,y1,x2,y2,xscale,yscale)

  temp             = MatrixXYL(:,3);  
  SumLengths       = temp(end);% Last entry will give distance from (x1, y1) to (x2,y2)
  TotalDistance    = sqrt((((x2-x1)*xscale)^2) +(((y2-y1)*yscale)^2));
  ScaledLengths    = (temp./SumLengths) * TotalDistance;
  MatrixXYScaledLs = cat(2,MatrixXYL(:,1),MatrixXYL(:,2),ScaledLengths);

  end


