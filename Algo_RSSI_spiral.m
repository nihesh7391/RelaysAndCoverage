function [RSSI,DistanceMatrix] = Algo_RSSI_spiral(x1,y1,xscale,yscale,X,Y)
tic;
     global GrayScaleImage ReceiverSensitivity PtIndBm f_operation tx_h rx_h
    
    Values      = csvread('Values.csv',1,1);
    Constants   = Values(:,1)';
    x_s         = Values(:,2)';
    Etas        = Values(:,3)';
    k_s         = Values(:,4)';
    PixelValues = Values(:,5)';
    
    x1 = ceil(x1) - 0.5 ; % make it center of the pixel
    y1 = ceil(y1) - 0.5 ;
   % disp ('In Algo RSSI')

    switch GrayScaleImage(ceil(y1),ceil(x1))
        case PixelValues(1,1)
            C = Constants(1,1);
        case PixelValues(1,2)
            C = Constants(1,2);
        case PixelValues(1,3)
            C = Constants(1,3);
        case PixelValues(1,4)
            C = Constants(1,4);
        case PixelValues(1,5)
            C = Constants(1,5);
        otherwise 
            sprintf('Its a backgroundpixel');
            return;
    end

    B    = transpose(GrayScaleImage);
    RSSI = (ReceiverSensitivity-1)*ones(Y,X);
    DistanceMatrix = zeros(Y,X);

    for s = 1: Y  
        s
        K = repmat(ceil(x1)-s:ceil(x1)+s,2*s+1,1).*(~padarray(ones(2*s-1,2*s-1),[1 1]));    
        L = transpose(repmat(ceil(y1)-s:ceil(y1)+s,2*s+1,1)).*(~padarray(ones(2*s-1,2*s-1),[1 1]));
        K = transpose(K);    L = transpose(L);   
        M = transpose(cat(1,reshape(K,1,numel(K)),reshape(L,1,numel(L))));    
        M(M(:,1) <= 0,:) = []; M(M(:,2) <= 0,:) = [];   
        M(M(:,1) >  X,:) = []; M(M(:,2) >  Y,:) = [];
        N = [zeros(size(M)),zeros(size(M,1),1)];    % to store X, Y pixels and RSSI
        N(:,1:2) = M;
        %N = zeros(size(M,1),(size(M,2)+1));
        %N(:,1) = M(:,1); N(:,2) = M(:,2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for  m =  1: size(M,1)
                    x2 = ceil(M(m,1))-0.5; 
                    y2 = ceil(M(m,2))-0.5; % to calculate distance to center of pixel

                    if (~(GrayScaleImage(ceil(y2),ceil(x2))))
                         continue;
                    end
                        if ((y2-y1)<0)
                                if((x2-x1)<0)                            
                                    MatrixXYLs = Xdec_Ydec(x1,y1,x2,y2,xscale,yscale);
                                elseif((x2-x1)>0)                            
                                    MatrixXYLs = Xinc_Ydec(x1,y1,x2,y2,xscale,yscale);
                                else                            
                                    MatrixXYLs = Xsame_Ydec(x1,y1,x2,y2,yscale);
                                end
                        elseif ((y2-y1)>0)
                                if((x2-x1)<0)                            
                                    MatrixXYLs = Xdec_Yinc(x1,y1,x2,y2,xscale,yscale);                        
                                elseif ((x2-x1)>0)                            
                                    MatrixXYLs = Xinc_Yinc(x1,y1,x2,y2,xscale,yscale);                        
                                else                            
                                    MatrixXYLs = Xsame_Yinc(x1,y1,x2,y2,yscale);
                                end
                        else
                                if((x2-x1)<0)                            
                                    MatrixXYLs = Xdec_Ysame(x1,y1,x2,y2,xscale);
                                elseif ((x2-x1)>0)                            
                                    MatrixXYLs = Xinc_Ysame(x1,y1,x2,y2,xscale);
                                end
                        end

                        linearindex =(MatrixXYLs(:,2) - 1)* X + MatrixXYLs(:,1);
                        MatrixXYLs = cat(2,MatrixXYLs,B(linearindex));               
                        
                        Temp1 = 1; d_term = 1; k_term_num = 0; cur_len = 0; Temp3 = 1;
                        d_mul = 1; d_sub = 0; % d_mul is denom of the equation. d_sub is also the same.

                        for j = 1:size(MatrixXYLs,1)
                            cur_len = MatrixXYLs(j,3)*d_mul - d_sub;
                            switch MatrixXYLs(j,4)
                                case PixelValues(1,1)                                    
                                        d_term = MatrixXYLs(j,3)^(-Etas(1,1));
                                        k_term_num = k_term_num + cur_len*k_s(1,1);
                                case PixelValues(1,2)                                    
                                        d_term = MatrixXYLs(j,3)^(-Etas(1,2));
                                        k_term_num = k_term_num + cur_len*k_s(1,2);
                                case PixelValues(1,3)                                    
                                        d_term = MatrixXYLs(j,3)^(-Etas(1,3));
                                        k_term_num = k_term_num + cur_len*k_s(1,3);
                                case PixelValues(1,4)                                    
                                        d_term = MatrixXYLs(j,3)^(-Etas(1,4));
                                        k_term_num = k_term_num + cur_len*k_s(1,4);
                                case PixelValues(1,5)                                    
                                        d_term = MatrixXYLs(j,3)^(-Etas(1,5));
                                        k_term_num = k_term_num + cur_len*k_s(1,5);
                            end  % -----------------end of switch-case-------

                            Temp1 = Temp1 * d_term;
                           
                            d_mul = d_sub + cur_len;
                            d_sub = d_sub + cur_len; 
         
                            f_term = f_operation^(-k_term_num/d_sub);
                            
                            if((tx_h^2)*(rx_h^x_s(1,1))*Temp1*f_term <= (10^(ReceiverSensitivity/10))/(C*(10^(PtIndBm/10))))
                                Temp3 = 0;                                
                                break; % -------------- break from j loop---------------
                            end
                                     
                        end %------------------- end of j loop--------------------------
                        
                        if (~(Temp3))                           
                            RSSI(M(m,2),M(m,1)) = ReceiverSensitivity;
                            N(m,3) = ReceiverSensitivity;
                        else
                            RSSI(M(m,2),M(m,1)) = PtIndBm + 10*log10(C*(tx_h^2)*(rx_h^x_s(1,1))*Temp1*f_term);%10*log10(C*Temp1);
                            N(m,3) = PtIndBm + 10*log10(C*(tx_h^2)*(rx_h^x_s(1,1))*Temp1*f_term);%10*log10(C*Temp1);
                        end
                           
            end %-------------end of m loop----------------------------------------------

            if (all(N(:,3) <= ReceiverSensitivity))     
             %   disp('all ReceiverSensitivity');
                break; %------------------- break from s loop----------------------------       
            end          

    end %---------------end of s loop----------------------------------------------------  

    RSSI(ceil(y1),ceil(x1)) = PtIndBm;  
    toc; 
end % ----------end of function