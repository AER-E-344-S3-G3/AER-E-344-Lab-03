% AER E 344 Spring 2024 Lab 03 Analysis
% Section 3 Group 3
clear, clc, close all;

figure_dir = "../Figures/";
data_zip = "./data.zip";
u = symunit;
rho_air = 1.225; % [kg/m^3]

% Unzip the data file
unzip(data_zip);

%% Import Calibration Data
pStrings = ["0" "0.51" "1.04" "1.56" "2.02" "3.16" "3.59" "4.10" ...
    "4.66" "5.12"]; % [inH_2O]
p = str2double(pStrings); % [inH_2O]
p_pa = double(separateUnits(unitConvert(p .* u.inH2O, u.Pa))); % [Pa]
V = zeros(1, length(p)); % [V]

for i = 1 : length(p)
    dataFile = fopen(strrep(pStrings(i), ".", "") + ".txt", "r");
    dataFormat = "%*s %*s %f";
    V(i) = mean( ...
        cell2mat(textscan(dataFile, dataFormat, "HeaderLines", 5)));
    fclose(dataFile);
end

V_0 = V(1); % [V]

%% Import Wind Tunnel Data
L = 0 : 16; % [cm]
V_q = zeros(1, length(L)); % [inH_2O]

for i = 1 : length(L)
    dataFile = fopen("p2_" + string(L(i)) + ".txt", "r");
    dataFormat = "%*s %*s %f";
    V_q(i) = mean( ...
        cell2mat(textscan(dataFile, dataFormat, "HeaderLines", 5)));
    fclose(dataFile);
end

V_q_0 = V_0;

%% Calculate Calibration Coefficient
[C_regress, S] = polyfit(V - V_0, p_pa, 1);
C = C_regress(1); % [Pa/V]
R_sq = 1 - (S.normr/norm(p_pa - mean(p_pa)))^2;

fprintf("Calibration Values:\n");
fprintf("V_0 = %g V (zero pressure voltage)\n", V_0);
fprintf("C = %g Pa/V (calibration constant)\n\n", C);
fprintf("Setra electronic manometer calibration curve:\n");
fprintf("\tP = %g(V - V_0) [Pa]\n\n", C);
fprintf("R^2 = %f\n\n", R_sq);

%% Calculate Dynamic Pressure and Velocity
q_tunnel = C .* (V_q - V_q_0); % [Pa]
v_tunnel = sqrt(2 .* q_tunnel / rho_air); % [m/s]

%% Calculate Line of Best Fit for Dynamic Pressure Graph
q_regress_1 = polyfit(L(1:3), q_tunnel(1:3), 2);
q_regress_2 = polyfit(L(2:end), q_tunnel(2:end), 3);

fprintf("Wind Tunnel Mapping:\n");
fprintf("V_0 = %g V (zero pressure voltage)\n\n", V_q_0);
fprintf("q = %gL^2 + %gL + %g [Pa] for 0 <= L < 1\n", q_regress_1);
fprintf("q = %gL^3 + %gL^2 + %gL + %g [Pa] for 1 <= L < 16\n\n", ...
    q_regress_2);

%% Calculate Line of Best Fit for Velocity Graph
v_regress_1 = polyfit(L(1:3), v_tunnel(1:3), 2);
v_regress_2 = polyfit(L(2:end), v_tunnel(2:end), 3);

fprintf("v = %gL^2 + %gL + %g [m/s] for 0 <= L < 1\n", v_regress_1);
fprintf("v = %gL^3 + %gL^2 + %gL + %g [m/s] for 1 <= L < 16\n", ...
    v_regress_2);

%% Display Data
V_x = 0 : 0.01 : (V(end) - V_0) * 1.15;

figure(1);
h = scatter(V - V_0, p_pa, 75, "filled");
fontname("Times New Roman");
fontsize(12, "points");
title("Pressure vs. Voltage from Electronic Manometer");
xlabel("V - V_0 [V]");
ylabel("P [Pa]");
hold on;
plot(V_x, polyval(C_regress, V_x), "red");
hold off;
xlim([V(1) - V_0, V(end) - V_0]);
uistack(h, "top");
legend("Line of Best Fit", "Experimental Data", "Location", "northwest");
grid on;
saveas(gcf, figure_dir ...
    + "Pressure vs Voltage from Electronic Manometer.svg");

q_x_1 = L(1) : 0.01 : L(2);
q_x_2 = L(2) : 0.01 : L(end);

figure(2);
h = scatter(L, q_tunnel, 75, "filled");
fontname("Times New Roman");
fontsize(12, "points");
title("Dynamic Pressure vs. Distance from the Test Chamber Wall");
xlabel("L [cm]");
ylabel("q [Pa]");
hold on;
plot(q_x_1, polyval(q_regress_1, q_x_1), "r");
plot(q_x_2, polyval(q_regress_2, q_x_2), "r");
hold off;
uistack(h, "top")
legend("", "Line of Best Fit", "Experimental Data", ...
    "Location", "southeast");
grid on;
saveas(gcf, figure_dir ...
    + "Dynamic Pressure vs Distance from the Test Chamber Wall.svg");

v_x_1 = L(1) : 0.01 : L(2);
v_x_2 = L(2) : 0.01 : L(end);

figure(3);
h = scatter(L, v_tunnel, 75, "filled");
fontname("Times New Roman");
fontsize(12, "points");
title("Velocity vs. Distance from the Test Chamber Wall");
xlabel("L [cm]");
ylabel("v [m/s]");
hold on;
plot(v_x_1, polyval(v_regress_1, v_x_1), "r");
plot(v_x_2, polyval(v_regress_2, v_x_2), "r");
hold off;
uistack(h, "top")
legend("", "Line of Best Fit", "Experimental Data", ...
    "Location", "southeast");
grid on;
saveas(gcf, figure_dir ...
    + "Velocity vs Distance from the Test Chamber Wall.svg");

delete *.txt
