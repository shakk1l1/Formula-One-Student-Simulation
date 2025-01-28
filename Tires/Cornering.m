clear; clc; close all;

load('B1654run15.mat')
% run1 = importdata("B1654run1.mat");

time = ET;
fs = ET(2)- ET(1);
%%
figure;
yyaxis left;
plot(FY);
yyaxis right;
plot(FZ);

%% overall experiment
figure;
plot(time, FZ)
xlabel('time [s]', 'FontSize', 14)
ylabel('Fz [N]', 'FontSize', 14)
grid on;

figure;
plot(time, NFY)
xlabel('time [s]', 'FontSize', 14)
ylabel('Normalized Fy [N]', 'FontSize', 14)
grid on;

figure;
plot(time, N);
xlabel('time [s]', 'FontSize', 14);
ylabel('Rotation speed [rpm]', 'FontSize', 14');
title('Rotation speed during the test', 'FontSize', 18);
grid on;

figure;
plot(time, SA);
xlabel('time [s]', 'FontSize', 14);
ylabel('Slip angle [°]', 'FontSize', 14');
title('Slip angle during the test', 'FontSize', 18);
grid on;

figure;
plot(time, V);
xlabel('time [s]', 'FontSize', 14);
ylabel('Speed[km/h]', 'FontSize', 14');
title('Tyre speed', 'FontSize', 18);
grid on;

%% third sweep
%during the third sweep the pressure is assumed constant (p = around 97 kPa)
index = 40916; % beginning of the third sweep
time2 = ET(index:end);
NFY2 = NFY(index:end);
SA2 = SA(index:end);
IA2 = IA(index:end);

figure;
yyaxis left;
plot(time2, SA2, 'LineWidth', 1.5);
ylabel('Slip angle [°]', 'FontSize', 14');
yyaxis right;
plot(time2, NFY2, 'LineWidth', 1.5);
ylabel('Normalized force(y) [-]', 'FontSize', 14');
xlabel('time [s]', 'FontSize', 14);
title('Slip angle during the test', 'FontSize', 18);
grid on;


% NFY as function of the camber:

figure;
plot(time2(IA2<1), NFY2(IA2<1), time2(IA2>1 & IA2<3), NFY2(IA2>1 & IA2<3), time2(IA2>3), NFY2(IA2>3), 'LineWidth', 1.5)
ylabel('Normalized force(y) [-]', 'FontSize', 14');
xlabel('time [s]', 'FontSize', 14);
legend('Camber = 0°', 'Camber = 2°', 'Camber = 4°');
grid on;

%% camber = 0°
SA2_0deg = SA2(IA2<1);
[SA2_0deg_sorted, idx] = sort(SA2_0deg);
NFY2_0deg =  NFY2(IA2<1);
NFY2_0deg_sorted = NFY2_0deg(idx);

figure;
plot(SA2_0deg_sorted, NFY2_0deg_sorted, 'o');
title('Camber = 0°', 'FontSize', 14')
ylabel('Normalized force(y) [-]', 'FontSize', 14');
xlabel('Slip angle [°]', 'FontSize', 14);
grid on;

%% camber = 2°
SA2_2deg = SA2(IA2>1 & IA2<3);
[SA2_2deg_sorted, idx] = sort(SA2_2deg);
NFY2_2deg =  NFY2(IA2>1 & IA2<3);
NFY2_2deg_sorted = NFY2_2deg(idx);

figure;
plot(SA2_2deg_sorted, NFY2_2deg_sorted, 'o');
title('Camber = 2°', 'FontSize', 14')
ylabel('Normalized force(y) [-]', 'FontSize', 14');
xlabel('Slip angle [°]', 'FontSize', 14);
grid on;

%% camber = 4°
SA2_4deg = SA2(IA2>3);
[SA2_4deg_sorted, idx] = sort(SA2_4deg);
NFY2_4deg =  NFY2(IA2>3);
NFY2_4deg_sorted = NFY2_4deg(idx);

figure;
plot(SA2_4deg_sorted, NFY2_4deg_sorted, 'o');
title('Camber = 4°', 'FontSize', 14')
ylabel('Normalized force(y) [-]', 'FontSize', 14');
xlabel('Slip angle [°]', 'FontSize', 14);
grid on;

%% Hysteresis
figure;
%plot(SA(ET > 1382.58 &ET< 1385.72), -FY(ET > 1382.58 & ET< 1385.72), SA(ET > 1385.72 &ET< 1388.8), -FY(ET > 1385.72 & ET< 1388.8), 'LineWidth', 1.5);
plot(SA(ET > 1382.58 &ET< 1395.35), NFY(ET > 1382.58 &ET< 1395.35), 'LineWidth', 1.5);
xlabel('Slip angle [°]', 'FontSize', 14);
ylabel('Normalized Fy [-]', 'FontSize', 14);
title('Hysteresis over a sweep cycle', 'FontSize', 18)
grid on;

%% Hysteresys treatement and curve fitting:
m = 1:length(SA);
sp = spline(m,SA);
z = fnzeros(sp);
z = round(z(1,:)); % list of the index of the zeros
z = z(2:2:end); % 1 cycle = 2 zero crossing

%visual check
% figure;
% plot(ET, SA);
% grid on
% hold on;
%plot(z, 0, 'o');

q = length(z) - 1; % number of cycles in the file
global_params = zeros(q, 6);
figure;

for i = 1:q % loop over all the cycles
    fprintf('Iteration %d of %d\n', i, q);
    start_index = z(i); % global index in the measurement list
    end_index = z(i+1);
    ET_i = ET(start_index:end_index);
    SA_i = SA(start_index:end_index);
    NFY_i = NFY(start_index:end_index);
    %plot(ET_i, SA_i);
    [min_value, ind] = min(SA_i);
    SA_i_shift = [SA_i(ind:end); SA_i(1:ind)]; 
    NFY_i_shift = [NFY_i(ind:end); NFY_i(1:ind)];

    l = length(SA_i_shift); % length of the sample
    
    NFY_i_avg = zeros(ceil(l/2));
    SA_i_avg = zeros(ceil(l/2));

    for j = 1:ceil(l/2) % loop for averaging the 2 half cycles
        SA_i_avg(j) = SA_i_shift(j);
        NFY_i_avg(j) = (NFY_i_shift(j) + NFY_i_shift(l-j+1))/2;
    end

    % We first sort on the basis of the tyre pressure:
    if P(start_index)<75
        global_params(i,1) = 1;
    elseif P(start_index)>90
        global_params(i,1) = 3;
    else
        global_params(i,1) = 2;
    end

    if IA(start_index)<1
        global_params(i,2) = 1; % 0°
    elseif IA(start_index)>3
        global_params(i,2) = 3; % 4°
    else
        global_params(i,2) = 2; % 2°
    end
    
    %curve fitting over the averaged data:
    [params_fit, NFY_fit]  = magic_curve_fit(SA_i_avg, NFY_i_avg);
    global_params(i,3:6) = params_fit;

    if i == 7
        %curve fitting over the averaged data:
        SA_i_avg_1 = SA_i_avg;
        NFY_i_avg_1 = NFY_i_avg;
        NFY_fit_1 = NFY_fit;
    end

    plot(SA_i_avg, NFY_i_avg, 'LineWidth', 1.5)
    hold on;
    grid on;
end
xlabel('Slip angle [°]', 'FontSize', 14);
ylabel('Normalized Fy [-]', 'FontSize', 14);
title('','FontSize', 18)

%Visual check for one of the fit
figure;
plot(SA_i_avg_1, NFY_i_avg_1, 'ro', SA_i_avg_1, NFY_fit_1, 'b-', 'LineWidth', 2);
legend('Experimental data','Magic formula fit');
xlabel('Slip angle [°]', 'FontSize', 14);
ylabel('Normalized Fy [-]', 'FontSize', 14);
title('Curve fitting (1st cycle)', 'FontSize', 18);
grid on;

%% Table with all the data
T = table((1:q)', global_params(:,1), global_params(:,2), global_params(:,3), ...
    global_params(:,4), global_params(:,5), global_params(:,6), ...
    'VariableNames', {'Cycle', 'Pressure', 'Camber', 'B', 'C', 'D', 'E'});
disp(T);
%% One curve for each P and camber
% We now have multiple equations (that can be evaluated in the same points)
% 1 eq for each set of parameters. We now average them and the we do one
% last interpolation.
slip_angle = -12:0.01:12;
P1 = zeros(3, length(slip_angle));
P2 = zeros(3, length(slip_angle));
P3 = zeros(3, length(slip_angle));

number_of_curves = zeros(3,3);

for i = 1:size(global_params,1)
    press_id = global_params(i,1);
    camb_id = global_params(i,2);
    iteration_params = global_params(i,3:6);
    
    if press_id == 1
        P1(camb_id,:) = P1(camb_id,:) + magic_formula2(iteration_params, slip_angle);
    elseif press_id == 2
        P2(camb_id,:) = P2(camb_id,:) + magic_formula2(iteration_params, slip_angle);
    else
        P3(camb_id,:) = P3(camb_id,:) + magic_formula2(iteration_params, slip_angle);
    end
    number_of_curves(camb_id, press_id) = number_of_curves(camb_id, press_id) + 1;
end
P1(1,:) = P1(1,:) / number_of_curves(1,1);
P1(2,:) = P1(2,:) / number_of_curves(2,1);
P1(3,:) = P1(3,:) / number_of_curves(3,1);
P2(1,:) = P2(1,:) / number_of_curves(1,2);
P2(2,:) = P2(2,:) / number_of_curves(2,2);
P2(3,:) = P2(3,:) / number_of_curves(3,2);
P3(1,:) = P3(1,:) / number_of_curves(1,3);
P3(2,:) = P3(2,:) / number_of_curves(2,3);
P3(3,:) = P3(3,:) / number_of_curves(3,3);

figure
h1 = plot(slip_angle, P1(1,:), slip_angle, P1(2,:), slip_angle, P1(3,:));
set(h1, 'LineWidth', 1.5);
legend('0°', '2°', '4°')
xlabel('Slip angle [°]', 'FontSize', 14);
ylabel('Normalized Fy [-]', 'FontSize', 14);
title('Pressure = 70 kPa','FontSize', 18);
grid on;

figure
h2 = plot(slip_angle, P2(1,:), slip_angle, P2(2,:), slip_angle, P2(3,:));
set(h2, 'LineWidth', 1.5);
legend('0°', '2°', '4°')
xlabel('Slip angle [°]', 'FontSize', 14);
ylabel('Normalized Fy [-]', 'FontSize', 14);
title('Pressure = 82.5 kPa','FontSize', 18);
grid on;

figure
h3 = plot(slip_angle, P3(1,:), ...
         slip_angle, P3(2,:), ...
         slip_angle, P3(3,:));  % Plot all curves

% Set line width for all curves
set(h3, 'LineWidth', 1.5);
legend('0°', '2°', '4°')
xlabel('Slip angle [°]', 'FontSize', 14);
ylabel('Normalized Fy [-]', 'FontSize', 14);
title('Pressure = 97 kPa','FontSize', 18);
grid on;
%% We now search the values of the parameters [B,C,D,E] of the averaged curves:
[params_fit, NFY_fit] = magic_curve_fit(slip_angle, P1(3,:));
plot(slip_angle,NFY_fit, 'ro', slip_angle, P1(3,:),'b')