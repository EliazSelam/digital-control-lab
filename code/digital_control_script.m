%= Beginner-Friendly Digital Control Script (Fixed Simulation for Dead-Beat Observer)
% Works out of the box. Just run and see results.
% Edit only the matrices or poles if needed.

clc; clear; close all;

%= ----------------------------------------
% System Definition (Edit these if needed)
A  = [0 0.5; 0 2];     % System matrix
B  = [0.1; 1];         % Input matrix
C  = [1 -1];           % Output matrix
D  = 0;                % Feedthrough (often 0)
Ts = 0.2;              % Sampling time

%= Desired Poles Configuration
% Choose ONE method: poles OR polynomial (Dw / Dest)
% Fill only one section. Leave the other empty or commented.
% To comment a line: add '%' at the beginning.

% --- Option 1: Polynomials (recommended for clarity)
Dw   = [1 -1.6 0.64];      % Feedback polynomial
Dest = [1 0 0];            % Observer polynomial (Dead-Beat)

% --- Option 2: Define poles directly (uncomment to use)
% desired_poles   = [0.6 0.7];
% observer_poles  = [0 0];
% Dw   = poly(desired_poles);
% Dest = poly(observer_poles);

% Convert polynomials to poles (only if Option 1 used)
desired_poles   = roots(Dw);
observer_poles  = roots(Dest);

%= ----------------------------------------
% State Feedback
R   = acker(A, B, desired_poles);
Acl = A - B * R;
r1 = R(1); r2 = R(2);

%= ----------------------------------------
% DC Gain
Gss = 10;
z   = 1;
rho = Gss / (C * inv(z * eye(size(A)) - Acl) * B);

%= ----------------------------------------
% Observer
L    = acker(A', C', observer_poles)';
L1   = L(1); L2 = L(2);
Aobs = A - L * C;

%= ----------------------------------------
% Output Results
fprintf('וקטור המשוב R = [%.4f; %.4f]\n', r1, r2);
fprintf('וקטור המשערך L = [%.4f; %.4f]\n', L1, L2);
fprintf('DC Gain rho = %.4f\n\n', rho);

% Observability Check
obsv_matrix = obsv(A, C);
fprintf('דרגת תצפית (observability rank): %d\n\n', rank(obsv_matrix));

%= ----------------------------------------
% Transfer Function
sys_cl = ss(Acl, B * rho, C, D, Ts);
w = tf(sys_cl);
disp('Transfer Function w(z) = Y(z)/R(z):');
disp(w);

%= ----------------------------------------
% Simulation: Observer vs Controller Only
N = 50;
r_in = 1;

x_real = [1; 0];
x_hat  = [0; 0];
x_ctrl = [1; 0];

y_ctrl = zeros(1, N);
y_est  = zeros(1, N);
x_error = zeros(2, N);

for k = 1:N
    % Controller only
    u_ctrl     = -R * x_ctrl + rho * r_in;
    y_ctrl(k)  = C * x_ctrl;
    x_ctrl     = A * x_ctrl + B * u_ctrl;

    % Observer-based control
    y         = C * x_real;
    u_obs     = -R * x_hat + rho * r_in;
    y_est(k)  = y;
    x_real    = A * x_real + B * u_obs;
    x_hat     = A * x_hat + B * u_obs + L * (y - C * x_hat);

    % Error between real and estimated state
    x_error(:,k) = x_real - x_hat;
end

n = 0:N-1;

%= ----------------------------------------
% Plot: Pole-Zero Map
mkdir('../plots');
figure;
pzmap(sys_cl);
title('Pole-Zero Map');
grid on;
saveas(gcf, '../plots/pzmap.png');

% Plot: Step Response
figure;
step(sys_cl);
title('Step Response');
grid on;
saveas(gcf, '../plots/step_response.png');

% Plot: Simulation Comparison
figure;
stem(n, y_ctrl, 'b', 'filled', 'DisplayName', 'בקר בלבד (x ידוע)'); hold on;
stem(n, y_est,  'r', 'filled', 'DisplayName', 'בקר עם משערך (x מוערך)');
xlabel('k (צעד זמן)');
ylabel('y(k)');
title('השוואת תגובת מערכת: בקר בלבד מול משערך');
legend;
grid on;
saveas(gcf, '../plots/simulation_comparison.png');

% Plot: State Estimation Error
figure;
plot(n, x_error(1,:), 'b--', 'DisplayName', 'שגיאה בציר 1'); hold on;
plot(n, x_error(2,:), 'r--', 'DisplayName', 'שגיאה בציר 2');
title('שגיאה בין מצב אמיתי למשוערך (x - x̂)');
xlabel('k (צעד זמן)');
ylabel('שגיאה');
legend;
grid on;
saveas(gcf, '../plots/state_estimation_error.png');
