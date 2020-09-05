function RSSI = Algo_RSSI(x1,y1,xscale,yscale,X,Y)
 tic;
    global GrayScaleImage ReceiverSensitivity PtIndBm f_operation tx_h rx_h
    
    Values      = csvread('Values.csv',1,1);
    Constants   = Values(:,1)';
    Etas        = Values(:,2)';
    PixelValues = Values(:,3)';
%     Constants   = Values(:,1)';
%     x_s         = Values(:,2)';
%     Etas        = Values(:,3)';
%     k_s         = Values(:,4)';
%     PixelValues = Values(:,5)';

    RSSI = zeros(Y,X);

    x1 = ceil(x1) - 0.5; % making the location of the transmitter at the center of the pixel.
    y1 = ceil(y1) - 0.5;
    
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
            disp('Its a background pixel'); 
            return;
    end
    % Above switch case's purpose is to select the constants depending on the
    % position of the transmitters whether they are on OA,SR,Concrete,HW,MW
    %if any other pixel the function will return to MainProgram.
 
    B = transpose(GrayScaleImage);

    for m = 1:Y
        for n = 1:X
            if (~GrayScaleImage(m,n))
                continue;                 % should skip pixel if its values is 0 in the image.
            end
            x2 = ceil(n) - 0.5;  % RSSI for (y2,x2)pixel to be computed due to (y1,x1)
            y2 = ceil(m) - 0.5;
            
            if ((x2-x1)>0)
                     if((y2-y1)>0)
                         MatrixXYLs = Xinc_Yinc(x1,y1,x2,y2,xscale,yscale);
                     elseif((y2-y1)<0)
                         MatrixXYLs = Xinc_Ydec(x1,y1,x2,y2,xscale,yscale);
                     else
                         MatrixXYLs = Xinc_Ysame(x1,y1,x2,y2,xscale);
                     end
            elseif (x2 == x1)
                     if((y2-y1)>0)
                         MatrixXYLs = Xsame_Yinc(x1,y1,x2,y2,yscale);
                     elseif ((y2-y1)<0)
                         MatrixXYLs = Xsame_Ydec(x1,y1,x2,y2,yscale);
                     end
            else
                     if((y2-y1)>0)
                         MatrixXYLs = Xdec_Yinc(x1,y1,x2,y2,xscale,yscale);
                     elseif ((y2-y1)<0)
                         MatrixXYLs = Xdec_Ydec(x1,y1,x2,y2,xscale,yscale);
                     else
                         MatrixXYLs = Xdec_Ysame(x1,y1,x2,y2,xscale);
                     end
            end

            LinearIndex =(MatrixXYLs(:,2) - 1)* X + MatrixXYLs(:,1);
            MatrixXYLs = cat(2,MatrixXYLs,B(LinearIndex));

            Temp1 = 1; d_term = 1; Temp3 = 1;

            for j = 1 : size(MatrixXYLs,1)
                    switch MatrixXYLs(j,4)
                        case PixelValues(1,1)
                            d_term = MatrixXYLs(j,3)^(-Etas(1,1));
                        case PixelValues(1,2)
                            d_term = MatrixXYLs(j,3)^(-Etas(1,2));
                        case PixelValues(1,3)
                            d_term = MatrixXYLs(j,3)^(-Etas(1,3));
                        case PixelValues(1,4)
                            d_term = MatrixXYLs(j,3)^(-Etas(1,4));
                        case PixelValues(1,5)
                            d_term = MatrixXYLs(j,3)^(-Etas(1,5));                        
                    end % -----------------end of switch-case-----------------

                    Temp1 = Temp1 * d_term;
                    
                  %  if(Temp1 <=  (10^(ReceiverSensitivity/10))/((10^(PtIndBm/10))*C));
                  %      Temp3 = 0;
                  %      break;
                   % end                    
            end %----------------end of for  j loop--------------------

            if (~Temp3)
                RSSI(m,n) = ReceiverSensitivity ;
            else
                RSSI(m,n) = PtIndBm + 10*log10(C*Temp1);
            end

        end %-------------end of n loop------------------------------------
    end %-------------end of m loop----------------------------------------
    RSSI(ceil(y1),ceil(x1)) = PtIndBm;
    toc;
end %--------------------------end of function----------------------------


