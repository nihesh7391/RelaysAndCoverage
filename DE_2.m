clc;
clear all;
close all;

global GrayScaleImage ReceiverSensitivity PtIndBm f_operation tx_h rx_h
ReceiverSensitivity     = -110; % in dBm
PtIndBm                 = 14;   % in dBm
ScaleResize             = 6;  
XdistM                  = 1.52*1000;
YdistM                  = 2.09*1000;
f_operation             = 868; %in MHz
tx_h                    = 1; %in meters
rx_h                    = 1; %in meters
ColourImage             = imread('IISc_5regions.jpg');
%ColourImage             = imread('kakinada_medium.jpeg');
[Yactual, Xactual, ~]   = size(ColourImage);
ColourImage             = imresize(ColourImage,(1/ScaleResize));
GrayScaleImage          = ImagePreProcess_5regions(ColourImage);% to generate a GrayScaleImage of IISc
%imshow(ColourImage);  % display IIScColourImage
xscale                  =  0.6655 * ScaleResize; % (XdistM/Xactual)
yscale                  =  0.6682 * ScaleResize; % (YdistM/Yactual)
[Y,X]                   = size(GrayScaleImage);

% ------- Added by Nihesh -------%

maximum_transmitters = 10;

low = [3 3];
up = [503 683];
mut = 0.8;
crossp = 0.7;
popsize = 10;
its = 100;

for num_tx = 3:maximum_transmitters
    
    pop = rand(popsize, num_tx*2);
    rng = repmat(abs(up - low), 1, num_tx);
    pop_denorm = repmat(low, popsize, num_tx) + (pop.*rng);
    cost = zeros(popsize, 1);

    for i=1:popsize
        i
        trial_denorm = pop_denorm(i, :);
        x1all = trial_denorm(1:2:num_tx*2);
        y1all = trial_denorm(2:2:num_tx*2);
        RSSIall = zeros(Y,X,num_tx);

        for t = 1:num_tx
            x1 = x1all(1,t);
            y1 = y1all(1,t);
            % [x1,y1] = deal(x1all(1,t),y1all(1,t));
            RSSI = Algo_RSSI(x1,y1,xscale,yscale,X,Y);
            RSSIall(:,:,t) = RSSI;
        end
        MaxRSSI = max(RSSIall,[],3);
        cost(i, 1) = sum(sum(MaxRSSI<=ReceiverSensitivity))/(X*Y); % replace this with actual cost;
    end

    [~, best_idx] = min(cost);
    best_vec = pop_denorm(best_idx, :);

    indices = 1:popsize;

    for i=1:its
        for j=1:popsize
            random_perms = randperm(popsize, 4);
            temp_indices = random_perms(random_perms~=j);
            a = pop(temp_indices(1,1), :);
            b = pop(temp_indices(1,2), :);
            c = pop(temp_indices(1,3), :);

            mutant = a + mut*(b-c);
            mutant(mutant<0) = 0;
            mutant(mutant>1) = 1;

            cross_points = (rand(1, num_tx*2) < 0.5);
            if (sum(cross_points)==0)
                cross_points(randperm(num_tx*2, 1)) = 1;
            end

            trial = mutant.*cross_points + pop(j, :).*(~cross_points);
            trial_denorm = repmat(low, 1, num_tx) + (trial.*rng);

            x1all = trial_denorm(1:2:num_tx*2);
            y1all = trial_denorm(2:2:num_tx*2);
            RSSIall = zeros(Y,X,num_tx);

            for t = 1:num_tx
                x1 = x1all(1,t);
                y1 = y1all(1,t);
                % [x1,y1] = deal(x1all(1,t),y1all(1,t));
                RSSI = Algo_RSSI(x1,y1,xscale,yscale,X,Y);
                RSSIall(:,:,t) = RSSI;
            end
            
            MaxRSSI = max(RSSIall,[],3);
            trial_cost = sum(sum(MaxRSSI<=ReceiverSensitivity))/(X*Y);
            if (trial_cost<cost(j, 1))
                cost(j, 1) = trial_cost;
                pop(j, :) = trial;
            end
 
%             if (trial_cost<cost(best_idx))
%                 best_idx = j;
%                 best_vec = trial_denorm;
%             end
        end
    end
    
    [min_cost, best_vec] = min(cost);
    
    if (min_cost<=0.2)
        disp('Found a solution!!');
        break;
    else
        disp('Best solution till now');
        disp(pop_denorm(best_vec, :), cost(best_vec));
    end
    
end