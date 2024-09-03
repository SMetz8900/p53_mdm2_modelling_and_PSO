function p53_mdm2_simulation
    % Define parameters
    ks = 2;   % Production rate of p53
    k1 = 2;   % Degradation rate of p53 by Mdm2
    tau = 3;  % Time delay
    K1 = 0.1; % Michaelis-Menten coefficient for p53 degradation
    k2 = 2;   % Production rate of Mdm2 dependent on p53
    K2 = 1;   % Hill coefficient for p53 activation of Mdm2
    dx = 1;   % Degradation rate of p53
    dy = 1;   % Degradation rate of Mdm2
    n = 2;    % Hill coefficient exponent

    % Define the system of differential equations with delay
    dde_fun = @(t, y, Z) [
        ks - k1 * Z(2) * y(1) / (K1 + y(1)) - dx * y(1); % p53 equation
        k2 * y(1)^n / (K2^n + y(1)^n) - dy * y(2)       % Mdm2 equation
    ];

    % Time span for simulation
    tspan = [0, 60];

    % Set initial values for p53 and Mdm2
    y0 = [0.2; 0.1]; 

    % Solver options (to match authors' settings)
    options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8);

    % Solve the DDEs using dde23
    sol = dde23(dde_fun, tau, y0, tspan, options);

    % Extract results
    t = sol.x;
    y = sol.y;

    % Plot the results
    figure(1);
    plot(t, y(1, :), 'b-', t, y(2, :), 'r-');
    xlabel('Time');
    ylabel('Concentration');
    legend('p53', 'Mdm2');
    title('Replicated oscillations of p53 and Mdm2');

    % Plot the phase plane trajectory
    figure(2);
    plot(y(1, :), y(2, :), 'k-', 'LineWidth', 1.5);
    hold on;

    % Compute nullclines numerically
    p53_values = linspace(min(y(1, :)), max(y(1, :)), 100);
    Mdm2_nullcline = k2 * p53_values.^n ./ (K2^n + p53_values.^n) / dy;
    p53_nullcline = (ks - dx * p53_values) ./ (k1 * p53_values ./ (K1 + p53_values));

    plot(p53_values, Mdm2_nullcline, 'b-', 'LineWidth', 1.5);
    plot(p53_values, p53_nullcline, 'r-', 'LineWidth', 1.5);
    xlabel('p53');
    ylabel('Mdm2');
    legend('Trajectory', 'Mdm2-nullcline', 'p53-nullcline');
    title('Replicated phase plane trajectory with nullclines');
    hold off;
end