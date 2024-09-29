% Matlab code to run PSO for parameter estimation of the p53 model including
% time delay
% (as found in: Eliaš,J.;Macnamara,C.K. Mathematical Modelling of p53 Signalling during DNA Damage Response: A Survey. Int. J. Mol. Sci. 2021,22,10590. https://doi.org/ 10.3390/ijms221910590)

% load data from "theoretical model" and initial parameter values (as
% specified in paper) 
params;
PSO_param = 5;
load("theoreticalModelData.mat");

% PSO parameter init
N = 30; % no. of particles
max_iterations = 100; % no. of max. iterations
w = 0.5; % inertia weight -> trade-off param. for global exploration & local exploitation
c1 = 1.5; % cognitive constant -> controls influence of individual best position for updates
c2 = 1.5; % social constant -> controls influence of global best position for updates

% Bounds of params (e.g. here for [k1, k2, tau])
lb = [0.1,0.1,0.1,-5,0.01];
ub = [5,5,10,10,10];

% initialize particle positions & velocities
positions = lb + (ub-lb).*rand(N,5);
velocities = zeros(N,5);
pBest = positions; 
gBest = positions(1,:);
pBest_fitness = inf(N,1);
gBest_fitness = inf;

% value to keep track of mse over PSO iterations
mse_history = zeros(max_iterations, 1);

% set up for plotting mse
figure(1);
hPlot = plot(1:max_iterations, mse_history, "LineWidth", 2);
xlabel("Iteration");
ylabel("Best MSE");
title("PSO optimization - MSE development");
grid on;
hold on;

% Create matrix to store the best parameters at each iteration
best_params_history = zeros(max_iterations, 5);

% PSO Loop 
for iter = 1:max_iterations
    for i = 1:N
        % Set Simulink params from current particle positions
        k1 = positions(i, 1);
        k2 = positions(i, 2);
        tau = positions(i, 3);
        n = positions(i, 4);
        dx = positions(i, 5);

        % Assign params to simulink model 
        assignin("base", "k1", k1);
        assignin("base", "k2", k2);
        assignin("base","tau", tau);
        assignin("base", "n", n);
        assignin("base", "dx", dx);

        % Run Simulink Model
        simOut = sim("PSO_p53_mdm2_simulation.slx");
        t_sim = simOut.get("tout");      % Time vector
        p53_sim = simOut.get("p53_data");   % p53 concentration data    
        Mdm2_sim = simOut.get("Mdm2_data");    % Mdm2 concentration data
        
        % interpolate data from theoretical model to match simulation time
        % points
        p53_theory_interpol = interp1(t, p53, t_sim);
        Mdm2_theory_interpol = interp1(t, Mdm2, t_sim);
        
        % calculate MSE (as a measure for fitness) 
        mse_p53 = mean((p53_sim - p53_theory_interpol).^2);
        mse_mdm2 = mean((Mdm2_sim - Mdm2_theory_interpol).^2);
        fitness = mse_p53 + mse_mdm2;

        % update personal best 
        if fitness < pBest_fitness(i) 
            pBest_fitness(i) = fitness;
            pBest(i, :) = positions(i, :);
        end
        
        % update global best
        if fitness < gBest_fitness
            gBest_fitness = fitness;
            gBest = positions(i, :);
        end
    end
    
    % Store the best parameters of the current iteration
    best_params_history(iter, :) = gBest;

    % plot MSE over iterations
    mse_history(iter) = gBest_fitness;
    set(hPlot, "YData", mse_history(1:iter));
    set(hPlot, "XData", 1:iter);
    drawnow;

    % update velocities & positions
    r1 = rand(N,5);
    r2 = rand(N,5);
    velocities = w*velocities + c1*r1.*(pBest - positions) + c2*r2.*(gBest - positions);
    positions = positions + velocities;

    % enforce defined param. bounds 
    positions = max(min(positions, ub), lb);

    % Print iteration number and best fitness (so far) 
    fprintf("Iteration %d: Best MSE = %f\n", iter, gBest_fitness)
    
    % convergence check 
    if gBest_fitness < 1e-6
        break
    end 
end

% Extract parameter history for plotting
k1_history = best_params_history(1:iter, 1);
k2_history = best_params_history(1:iter, 2);
tau_history = best_params_history(1:iter, 3);
n_history = best_params_history(1:iter, 4);
dx_history = best_params_history(1:iter, 5);

% Plot the parameter evolution
figure(2);
plot(1:iter, k1_history, "-r", "LineWidth", 2);
hold on;
plot(1:iter, k2_history, "-g", "LineWidth", 2);
plot(1:iter, tau_history, "-b", "LineWidth", 2);
plot(1:iter, n_history, "-c", "LineWidth", 2);
plot(1:iter, dx_history, "-k", "LineWidth", 2);
xlabel("Iteration");
ylabel("Parameter Value");
legend("k1", "k2", "tau","n", "dx");
title("PSO optimization - Parameter Evolution");
grid on;
hold off;

save("PSOParamsModelData.mat","t_sim","p53_sim","Mdm2_sim");

fprintf("Optimal parameters:\n k1 = %f\n k2 = %f\n, tau = %f\n, n = %f\n, dx = %f\n", gBest(1), gBest(2), gBest(3), gBest(4), gBest(5));