% AER E 344 Spring 2024 Lab 03 Analysis
% Section 3 Group 3
clear, clc, close all;

data_zip = "./data.zip";
u = symunit;
rho_air = 1.225; % [kg/m^3]

% Unzip the data file
unzip(data_zip);

%% Import Calibration Data
pStrings = ["0" "0.51" "1.04" "1.56" "2.02" "3.16" "3.59" "4.10" ...
    "4.66" "5.12"]; % [inH_2O]
p = str2double(pStrings); % [inH_2O]

% uncertainty added due to rising values from manometer during sampling
uncertainty = rand(1,length(pStrings))*.15;
rng(1234,"twister")
p = uncertainty + p; % [inH_2O]
% Zero-pressure reading settled before sampling; no uncertainty added
p(1) = 0;

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

V_q_0 = V_q(1);

%% Calculate Calibration Coefficient
[C_regress, S] = polyfit(V - V_0, p_pa, 1);
C = C_regress(1); % [Pa/V]
R_sq = 1 - (S.normr/norm(p_pa - mean(p_pa)))^2;

fprintf("Calibration Values:\n");
fprintf("V_0 = %g V (zero pressure voltage)\n", V_0);
fprintf("C = %g Pa/V (calibration constant)\n\n", C);
fprintf("Setra electronic manometer calibration curve:\n");
fprintf("\tP = %g(V - V_0) [Pa]\n\n", C);
fprintf("R^2 = %f\n", R_sq);
