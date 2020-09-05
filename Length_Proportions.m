function MatrixXYLs = Length_Proportions(MatrixXYScaledLs)

    flag  = 0;
    ls    = MatrixXYScaledLs(:,3);
    k     = ls;    
    for i = 1: size(ls,1)             
        if (flag ==0)
            ls(i,1) = k(i,1);
            flag = 1;
        else            
            ls(i,1)= k(i,1)/k(i-1,1);
        end
    end    
    MatrixXYLs = cat(2,MatrixXYScaledLs(:,1),MatrixXYScaledLs(:,2),ls);

end
 
%----------------------------Optimised version ----------------------------
%{
l_num = MatrixXY_Scaled_Lengths(:,3);
l_den = l_num(1:end-1);
l_deno = cat(1,1,l_den);
ls = l_num./l_deno;

MatrixXYLs = cat(2,MatrixXY_Scaled_Lengths(:,1),MatrixXY_Scaled_Lengths(:,2),ls);
%}