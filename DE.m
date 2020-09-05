
% function Diff_Evolve = DE(bounds, mut, crossp, popsize, its)
% end

x_low = 3;
x_up = 503;
y_low = 3;
y_up = 683;

bounds = 
mut = 0.8;
crossp = 0.7;
popsize = 10;
its = 100;

dimension = size(bounds);
pop = rand(popsize, dimension(1,2));
low_b = bounds(:, 1);
up_b = bounds(:, 2);
rng = abs(up_b - low_b);
pop_denorm = low_b + (pop.*rng)