% AER E 344 Spring 2024 Lab 03 Analysis
% Section 3 Group 3
clear, clc, close all;

u = symunit;

%% Import Calibration Data
pStrings = ["0" "0.51" "1.04" "1.56" "2.02" "3.16" "3.59" "4.10" ...
    "4.66" "5.12"]; % [inH_2O]
p = str2double(pStrings); % [inH_2O]
V = zeros(1, length(p)); % [V]

for i = 1 : length(p)
    dataFile = fopen(strrep(pStrings(i), ".", "") + ".txt", "r");
    dataFormat = "%*s %*s %f";
    V(i) = mean( ...
        cell2mat(textscan(dataFile, dataFormat, "HeaderLines", 5)));
    fclose(dataFile);
end

V_0 = V(1); % [V]

fprintf("V_0 = %g V (zero pressure voltage)\n", V_0);

%% Import Dynamic Pressure Data
l = 0 : 16; % [cm]
q = zeros(1, length(l)); % [inH_2O]

for i = 1 : length(l)
    dataFile = fopen("p2_" + string(l(i)) + ".txt", "r");
    dataFormat = "%*s %*s %f";
    q(i) = mean( ...
        cell2mat(textscan(dataFile, dataFormat, "HeaderLines", 5)));
    fclose(dataFile);
end

%% Calculate Calibration Coefficient
C_regress = polyfit(V - V_0, p, 1);
C = C_regress(1); % [inH_2O/V]
C = double(separateUnits(unitConvert(C * u.inH2O, u.Pa))); % [Pa/V]
fprintf("C = %g Pa/V (calibration constant)\n", C);
fprintf("Setra electronic manometer calibration curve:\n\tP = %g(V - V_0) [Pa]\n", C);

%% Plot Graphs
V_x = 0 : 0.01 : (V(end) - V_0) * 1.15;

figure(1);
h = scatter(V - V_0, p, 50, "filled");
title("Pressure vs. Voltage from Electronic Manometer");
xlabel("V - V_0 [V]");
ylabel("P [Pa]");
hold on;
plot(V_x, polyval(C_regress, V_x));
hold off;
xlim([V(1) - V_0, V(end) - V_0]);
uistack(h, "top");
legend("Experimental Data", "Line of Best Fit", "Location", "northwest");
grid on;

% %% taking final data to plot putting in array to plot 
% 
% water_pash1 = [0;0.51;1.04;1.56;2.02;3.16;3.59;4.10;4.66;5.12]*248.84;
% water_pasc  = water_pash1;
% 
% data_average =[data_0_average;data_051_average;data_104_average;data_156_average;data_202_average;data_316_average;data_359_average;data_410_average;data_466_average;data_512_average];
% 
% %% poly fit 
% 
% slope_p1 = polyfit(data_average,water_pasc,1);
% 
% disp("the calibration coef is 622.6634 Pa/volt");
% 
% %% ploting part 1 water pas to volt
% 
% scatter(data_average,water_pasc)
% xlabel("Voltage", "FontSize",12)
% ylabel("Pressure (Pa)", "FontSize",12)
% title("Pressure vs Voltage","FontSize",14)
% grid on
% hold on
% a = polyval(slope_p1,water_pasc);
% plot(water_pasc,a)
% xlim([3,6]);
% ylim([0,1650])
% legend("Raw Data","Line Of Best Fit.")
% 
% 
% %% taking final data to plot putting in array to plot
% 
% meandata = [data_0cm_average;data_1cm_average;data_2cm_average;data_3cm_average;data_4cm_average;data_5cm_average;data_6cm_average;data_7cm_average;data_8cm_average;data_9cm_average;data_10cm_average;data_11cm_average;data_12cm_average;data_13cm_average;data_14cm_average;data_15cm_average];
% 
% pitot_press = polyval(slope_p1,meandata);
% 
% distance = (0:1:15)*0.01;
% 
% P_pitot = polyfit(distance,pitot_press,3);
% y = polyval(P_pitot,distance);
% 
% %% ploting q vs dist 
% figure(2)
% scatter(distance,pitot_press)
% 
% hold on 
% plot(distance,y)
% legend("Raw Data","Line Of Best Fit.")
% hold off
% 
% xlabel("Distance (cm)", "FontSize",12)
% ylabel("Dynamic pressure (Pa)", "FontSize",12)
% title("Dynamic Pressure vs Distance","FontSize",14)
% grid on
% 
% 
% %% calc velocity
% 
% rho = 1.225;
% 
% velo = sqrt(2*(y)/rho);
% velo2 = sqrt(2*(pitot_press)./(rho));
% %% plot velo vs dist
% figure(3)
% 
% scatter(distance,velo2)
% hold on
% xlabel("Distance (cm)", "FontSize",12)
% ylabel("velocity (m/s)", "FontSize",12)
% title("Velocity vs Distance","FontSize",14)
% 
% grid on
% slope_velo = polyfit(distance,velo,12);
% y1 = polyval(slope_velo,distance);
% 
% plot(distance,y1)
% legend("Raw Data","Line Of Best Fit.")
% 
% 
% 
% 
% 
