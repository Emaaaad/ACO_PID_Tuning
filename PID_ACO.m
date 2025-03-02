clc; clear all; close all;

% System definition
ns = [1];
ds = [1 2 3];
G = tf(ns, ds);
s = tf('s');
delay = exp(-1 * s);
Time = pade(delay, 1);
Gt = Time * G;
Gf = feedback(Gt, 1);

figure(1)
step(Gf)
title('Step Response of Original System with Delay')

% ACO Parameters
N = 10;           % No. of Ants
ph_decay = 0.6;   % Pheromone decay factor
Sca_fact = 2;     % Scaling Parameter
itr = 10;         % Number of iterations
var = 3;          % No. of tuning variables (Kp, Ki, Kd)
h_size = 5;       % Step size in the search space

% Search Space
a = 0;            % Lower bound
b = 1000;         % Upper bound

% Initialize global best value
GBv = 10^12;
c_cf = 0;

% Initialize pheromone matrix and search space
for cc = 1:var
    % Initial value
    w = a;               
    to_ph_mt(cc) = 0;    % Total pheromone
    
    % Assign permissible discrete values and amounts of pheromone
    for m = 1:b
        x(cc, m) = w;
        w = w + h_size;
        ph_mt(cc, m) = 1;
        to_ph_mt(cc) = to_ph_mt(cc) + ph_mt(cc, m);
    end
end

% Main ACO loop
for tt = 1:itr
    for cc = 1:var
        % Probability of selecting path
        for m = 1:b
            prop(cc, m) = ph_mt(cc, m) / to_ph_mt(cc);
        end
        
        % Roulette-Wheel Selection
        for m = 1:b
            if m == 1
                rws(cc, m) = 0;
                rwe(cc, m) = rws(cc, m) + prop(cc, m);
            else
                rws(cc, m) = rwe(cc, m - 1);
                rwe(cc, m) = rws(cc, m) + prop(cc, m);
            end
        end
        
        % Select random position for each ant
        for k = 1:N
            rr(cc, k) = rand(1);
            for m = 1:b
                if (rr(cc, k) >= rws(cc, m)) && (rr(cc, k) < rwe(cc, m))
                    ff(cc, k) = x(cc, m);
                end
            end
        end
    end
    
    % Objective Function Values Corresponding to the paths chosen
    for k = 1:N
        % Model parameters
        kp = ff(1, k);
        ki = ff(2, k);
        kd = ff(3, k);
        
        % Simulation model
        Gc = pid(kp, ki, kd);
        Gcf = feedback(Gc * G, 1);
        y = step(Gcf);
        
        % ITAE calculation
        ff_cc = 0;
        for m_err = 1:length(y)
            ff_cc = ff_cc + ((abs(y(m_err) - 1)) * m_err);
        end
        ITAE(k) = ff_cc;
    end
    
    % Rank objective function
    [BFv, BFI] = min(ITAE);
    WFv = max(ITAE);
    
    if BFv < GBv
        GBv = BFv;
        for cc = 1:var
            bkc(cc) = ff(cc, BFI);
        end
    end
    c_cf = c_cf + 1;
    best_cf_ac(c_cf) = GBv;
    
    % Update the pheromone array
    up_ph = (Sca_fact * BFv) / WFv;
    for cc = 1:var
        to_ph_mt(cc) = 0;
        for m = 1:b
            if x(cc, m) == bkc(cc)
                ph_mt(cc, m) = ph_mt(cc, m) + up_ph;
            else
                ph_mt(cc, m) = max(ph_mt(cc, m) * ph_decay, 1e-6);  % Ensure pheromone levels do not go below a small threshold
            end
            to_ph_mt(cc) = to_ph_mt(cc) + ph_mt(cc, m);
        end
    end
end

% Display results
Min_ITAE = GBv
kp = bkc(1)
ki = bkc(2)
kd = bkc(3)

% Plot optimized system step response
figure(2)
Gc = pid(kp, ki, kd);
Gcf = feedback(Gc * G, 1);
step(Gcf);
title('Step Response with Optimized PID Controller')

% Plot cost function over iterations
t_cf = 1:c_cf;
figure(3)
plot(t_cf, best_cf_ac, 'r--', 'LineWidth', 2);
xlabel('Iteration');
ylabel('Cost Function (ITAE)');
legend('ITAE for ACO-PID');
title('ITAE with Each Iteration');
