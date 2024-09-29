% Load the saved model data
load('theoreticalModelData.mat'); % contains t, p53, Mdm2
load('PSOParamsModelData.mat');   % contains t_sim, p53_sim, Mdm2_sim

% Create a new figure for plotting
figure(3);

% theory params (from paper)
k1_theory = 2;
k2_theory = 2;
tau_theory = 3;
n_theory = 2; 
dx_theory = 1;
dy_theory = 1;

if PSO_param == 3
    k1 = gBest(1);
    k2 = gBest(2);
    tau = gBest(3);
elseif PSO_param == 4
    k1 = gBest(1);
    k2 = gBest(2);
    tau = gBest(3);
    n = gBest(4);
elseif PSO_param == 5
    k1 = gBest(1);
    k2 = gBest(2);
    tau = gBest(3);
    n = gBest(4);
    dx = gBest(5);
else
    k1 = gBest(1);
    k2 = gBest(2);
    tau = gBest(3);
    n = gBest(4);
    dx = gBest(5);
    dy = gBest(6);
end
% Plot p53 data (theoretical with transparency, PSO with solid color)
hold on;
plot(t, p53, 'r', 'LineWidth', 2, 'DisplayName', 'Theoretical p53', 'Color', [1 0 0 0.3]); % red with opacity
plot(t_sim, p53_sim, 'r', 'LineWidth', 2, 'DisplayName', 'PSO p53');                      % solid red

% Plot Mdm2 data (theoretical with transparency, PSO with solid color)
plot(t, Mdm2, 'b', 'LineWidth', 2, 'DisplayName', 'Theoretical Mdm2', 'Color', [0 0 1 0.3]); % blue with opacity
plot(t_sim, Mdm2_sim, 'b', 'LineWidth', 2, 'DisplayName', 'PSO Mdm2');                       % solid blue

% Labels and title
xlabel('Time');
ylabel('Concentration');
if PSO_param == 3
    title('Comparison of Theoretical and PSO Parameters Data for p53 and Mdm2 (3 parameters)');
elseif PSO_param == 4
    title('Comparison of Theoretical and PSO Parameters Data for p53 and Mdm2 (4 parameters)');
elseif PSO_param == 5
    title('Comparison of Theoretical and PSO Parameters Data for p53 and Mdm2 (5 parameters)');
else
    title('Comparison of Theoretical and PSO Parameters Data for p53 and Mdm2 (6 parameters)');
end
legend('Location', 'best');
grid on;
hold off;

% Phase-plane plot for both theoretical and PSO model
figure(4);

% Plot theoretical phase-plane trajectory (with transparency)
plot(p53, Mdm2, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Theoretical Trajectory', 'Color', [0 0 0 0.3]);
hold on;

% Plot PSO-optimized phase-plane trajectory (solid color)
plot(p53_sim, Mdm2_sim, 'k-', 'LineWidth', 1.5, 'DisplayName', 'PSO Trajectory', 'Color', [0 0 0]);

% Labels and title
xlabel('p53');
ylabel('Mdm2');
if PSO_param == 3
    title('Phase-Plane Trajectory Comparison (3 parameters)');
elseif PSO_param == 4
    title('Phase-Plane Trajectory Comparison (4 parameters)');
elseif PSO_param == 5
    title('Phase-Plane Trajectory Comparison (5 parameters)');
else
    title('Phase-Plane Trajectory Comparison (6 parameters)');
end
grid on;

% Compute and plot nullclines for the theoretical model (with opacity)
p53_values_theory = linspace(min(p53), max(p53), 100);

% Mdm2-nullcline for the theoretical model (blue line with opacity)
Mdm2_nullcline_theory = k2_theory * p53_values_theory.^n_theory ./ (K2^n_theory + p53_values_theory.^n_theory) / dy_theory;
plot(p53_values_theory, Mdm2_nullcline_theory, 'LineWidth', 1.5, 'DisplayName', 'Theoretical Mdm2-nullcline', 'Color', [0 0 1 0.3]);  % blue with transparency

% p53-nullcline for the theoretical model (red line with opacity)
p53_nullcline_theory = (ks - dx_theory * p53_values_theory) ./ (k1_theory * p53_values_theory ./ (K1 + p53_values_theory));
plot(p53_values_theory, p53_nullcline_theory, 'LineWidth', 1.5, 'DisplayName', 'Theoretical p53-nullcline', 'Color', [1 0 0 0.3]);  % red with transparency

% Compute and plot nullclines for the PSO-optimized model (solid color)
p53_values_PSO = linspace(min(p53_sim), max(p53_sim), 100);

% Mdm2-nullcline for the PSO model (solid blue)
Mdm2_nullcline_PSO = k2 * p53_values_PSO.^n ./ (K2^n + p53_values_PSO.^n) / dy;
plot(p53_values_PSO, Mdm2_nullcline_PSO, 'b-', 'LineWidth', 1.5, 'DisplayName', 'PSO Mdm2-nullcline');

% p53-nullcline for the PSO model (solid red)
p53_nullcline_PSO = (ks - dx * p53_values_PSO) ./ (k1 * p53_values_PSO ./ (K1 + p53_values_PSO));
plot(p53_values_PSO, p53_nullcline_PSO, 'r-', 'LineWidth', 1.5, 'DisplayName', 'PSO p53-nullcline');

% Add a legend
legend('Location', 'best');

hold off;