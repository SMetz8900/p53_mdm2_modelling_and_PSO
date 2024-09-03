params;

load_system("PSO_p53_mdm2_simulation.slx");
simOut = sim("PSO_p53_mdm2_simulation.slx");
t = simOut.get("tout");      % Time vector
p53 = simOut.get("p53_data");   % p53 concentration data
Mdm2 = simOut.get("Mdm2_data");    % Mdm2 concentration data

close_system("p53_mdm2_simulation_simulink.slx",0);

% Plot concentration oscillations
figure(1);
plot(t, p53, 'b-', t, Mdm2, 'r-');
xlabel('Time');
ylabel('Concentration');
legend('p53', 'Mdm2');
title('Replicated oscillations of p53 and Mdm2');

% Plot phase plane trajectory
figure(2);
plot(p53, Mdm2, 'k-', 'LineWidth', 1.5);
xlabel('p53');
ylabel('Mdm2');
title('Phase-Plane Trajectory');
grid on;

% Compute and plot nullclines
hold on;
p53_values = linspace(min(p53), max(p53), 100);
Mdm2_nullcline = k2 * p53_values.^n ./ (K2^n + p53_values.^n) / dy;
p53_nullcline = (ks - dx * p53_values) ./ (k1 * p53_values ./ (K1 + p53_values));
plot(p53_values, Mdm2_nullcline, 'b-', 'LineWidth', 1.5);
plot(p53_values, p53_nullcline, 'r-', 'LineWidth', 1.5);
legend('Trajectory', 'Mdm2-nullcline', 'p53-nullcline');
hold off;