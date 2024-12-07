% hypothesis:
% - Horizontal and flat road
% - drag and downforce neglected
% - no rolling resistance
% - influence of the engine negligible

%precision of the simulation can be inreased by a taking into account the
%effects of the variation of Fz, h1 and h2


deltaT = 0.01; %[s]
duration = 10; % [s]
t = 0:deltaT:duration;
 
% tyre parameters
vehicle.mu_a = 0.8;
vehicle.mu_g = 0.8 * vehicle.mu_a;
vehicle.rs = 0.2; %[m]

%vehycle properties
vehicle.I = 100; % [kg m^2] rotational inertia
vehicle.mt = 100; % [kg]
vehicle.l1 = 1; % [m]
vehicle.l2 = 1; % [m]
vehicle.k1 = 10000; % [N/m]
vehicle.k2 = 10000; % [N/m]
vehicle.b1 = 500; % [N/(m s)]
vehicle.b2 = 500; % [N/(m s)]
vehicle.h1 = 0.3; %[m] initial height of the suspension
vehicle.h2 = 0.3; %[m] initial height of the suspension

brake_repartition = 0.6;

braking_torque = zeros(length(t),1);
braking_torque(100:end) = 10000;
tr2 = braking_torque * brake_repartition; %front wheels;
tr1 = braking_torque * (1 - brake_repartition); %rear wheels

F1x = tr1/vehicle.rs;
F2x = tr1/vehicle.rs;

Y = [vehicle.mt * 9.81; 0];
A = [
    1   1
    vehicle.l1  -vehicle.l2
    ];
vehicle.static_Fz = A\Y;

% F = [F1x'; F2x'; static_Fz(1) * ones(1, length(t)); static_Fz(2) * ones(1, length(t))];
% 
% 
% 
% % we have a problem in the form y' = f(y)
% %state vector = [x_dot, x, z3_dot, z3, phi_dot, phi]
% 
% %initial conditions:
% y0 = [100; 0; 0; 0; 0; 0;]; %[x_dot, x, z3_dot, z3, phi_dot, phi]
% 
% y = zeros(6,length(t));
% y(:,1) = y0;
% 
% i = 2;
% 
% while (y(1,i -1)>0 && i < length(t))
%     %Fz calculation based on the previous iteration
%     F(3:4,i-1) = F(3:4,i-1) +  Fz_calculation(y(:,i-1), vehicle);
%     y(:,i) = y(:,i-1) + dynamics(y(:,i-1), F(:,i), vehicle) * deltaT;
% 
%     i=i+1;
% end
% 
% figure;
% plot(t, y(1,:));
% figure;
% plot(t, y(5,:))