load("theoreticalModelData.mat")

% PSO parameter init
N = 30; % no. of particiles
max_iterations = 100;
w = 0.5; % inertia weight 
c1 = 1.5; % cognitive constant;
c2 = 1.5; % Social constant 

% Bounds of params (e.g. [k1, k2, tau])
lb = [0.1,0.1,0.1];
ub = [5,5,10];

% initialize particle positions & velocities
positions = lb + (ub-lb).*rand(N,3); % random positions 
velocities = zeros(N,3);
pBest = positions; % initial personal best positions 
gBest = positions(1,:); % initial global best position
pBest_fitness = inf(N,1);
gBest_fitness = inf;

mse_history = zeros(max_iterations, 1);

figure;
hPlot = plot(1:max_iterations, mse_history, "LineWidth", 2);
xlabel("Iteration");
ylabel("Best MSE");
title("PSO optimization - MSE development");
grid on;
hold on;



% PSO Loop 
for iter = 1:max_iterations
    for i = 1:N
        % Set Simulink params from current particle positions
        k1 = positions(i, 1);
        k2 = positions(i, 2);
        tau = positions(i, 3);

        % Assign params to simulink model 
        assignin("base", "k1", k1);
        assignin("base", "k2", k2);
        assignin("base","tau", tau)

        % Run Simulink Model
        simOut = sim("PSO_p53_mdm2_simulation.slx");
        t_sim = simOut.get("tout");      % Time vector
        p53_sim = simOut.get("p53_data");   % p53 concentration data    
        Mdm2_sim = simOut.get("Mdm2_data");    % Mdm2 concentration data
        
        p53_theory_interpol = interp1(t, p53, t_sim);
        Mdm2_theory_interpol = interp1(t, Mdm2, t_sim);

        mse_p53 = mean((p53_sim - p53_theory_interpol).^2);
        mse_mdm2 = mean((Mdm2_sim - Mdm2_theory_interpol).^2);
        fitness = mse_p53 + mse_mdm2;

        if fitness < pBest_fitness(i)
            pBest_fitness(i) = fitness;
            pBest(i, :) = positions(i, :);
        end

        if fitness < gBest_fitness
            gBest_fitness = fitness;
            gBest = positions(i, :);
        end
    end

    mse_history(iter) = gBest_fitness;

    set(hPlot, "YData", mse_history(1:iter));
    set(hPlot, "XData", 1:iter);
    drawnow;

    r1 = rand(N,3);
    r2 = rand(N,3);
    velocities = w*velocities + c1*r1.*(pBest - positions) + c2*r2.*(gBest - positions);
    positions = positions + velocities;

    positions = max(min(positions, ub), lb);

    fprintf("Iteration %d: Best MSE = %f\n", iter, gBest_fitness)

    if gBest_fitness < 1e-6;
        break
    end 
end

fprintf("Optimal parameters:\n k1 = %f\n k2 = %f\n, tau = %f\n", gBest(1), gBest(2), gBest(3));

