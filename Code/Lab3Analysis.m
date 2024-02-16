clear,clc,close all 
%% Part 1 

%% Taking in data

data0 = readtable('0.txt.xlsx');
data051 = readtable('051.txt.xlsx');
data104 = readtable('104.txt.xlsx');
data156 = readtable('156.txt.xlsx');
data202 = readtable('202.txt.xlsx');
data316 = readtable('316.txt.xlsx');
data359 = readtable('359.txt.xlsx');
data410 = readtable('410.txt.xlsx');
data466 = readtable('466.txt.xlsx');
data512 = readtable('512.txt.xlsx');

%% pulling data I want

data_0 = data0{:,3};
data_051 = data051{:,3};
data_104 = data104{:,3};
data_156 = data156{:,3};
data_202 = data202{:,3};
data_316 = data316{:,3};
data_359 = data359{:,3};
data_410 = data410{:,3};
data_466 = data466{:,3};
data_512 = data512{:,3};

%% average of that data

data_0_average = mean(data_0);
data_051_average = mean(data_051);
data_104_average = mean(data_104);
data_156_average = mean(data_156);
data_202_average = mean(data_202);
data_316_average = mean(data_316);
data_359_average = mean(data_359);
data_410_average = mean(data_410);
data_466_average = mean(data_466);
data_512_average = mean(data_512);

%% taking final data to plot putting in array to plot 

water_pash1 = [0;0.51;1.04;1.56;2.02;3.16;3.59;4.10;4.66;5.12]*248.84;
water_pasc  = water_pash1;

data_average =[data_0_average;data_051_average;data_104_average;data_156_average;data_202_average;data_316_average;data_359_average;data_410_average;data_466_average;data_512_average];

%% poly fit 

slope_p1 = polyfit(data_average,water_pasc,1);

disp("the calibration coef is 622.6634 Pa/volt");

%% ploting part 1 water pas to volt

scatter(data_average,water_pasc)
xlabel("Voltage", "FontSize",12)
ylabel("Pressure (Pa)", "FontSize",12)
title("Pressure vs Voltage","FontSize",14)
grid on
hold on
a = polyval(slope_p1,water_pasc);
plot(water_pasc,a)
xlim([3,6]);
ylim([0,1650])
%% taking in data part 2

data0cm = readtable('p2_0.txt.xlsx');
data1cm = readtable('p2_1.txt.xlsx');
data2cm = readtable('p2_2.txt.xlsx');
data3cm = readtable('p2_3.txt.xlsx');
data4cm = readtable('p2_4.txt.xlsx');
data5cm = readtable('p2_5.txt.xlsx');
data6cm = readtable('p2_6.txt.xlsx');
data7cm = readtable('p2_7.txt.xlsx');
data8cm = readtable('p2_8.txt.xlsx');
data9cm = readtable('p2_9.txt.xlsx');
data10cm = readtable('p2_10.txt.xlsx');
data11cm = readtable('p2_11.txt.xlsx');
data12cm = readtable('p2_12.txt.xlsx');
data13cm = readtable('p2_13.txt.xlsx');
data14cm = readtable('p2_14.txt.xlsx');
data15cm = readtable('p2_15.txt.xlsx');

%% data I want 

data_0cm = data0cm{:,3};
data_1cm = data1cm{:,3};
data_2cm = data2cm{:,3};
data_3cm = data3cm{:,3};
data_4cm = data4cm{:,3};
data_5cm = data5cm{:,3};
data_6cm = data6cm{:,3};
data_7cm = data7cm{:,3};
data_8cm = data8cm{:,3};
data_9cm = data9cm{:,3};
data_10cm = data10cm{:,3};
data_11cm = data11cm{:,3};
data_12cm = data12cm{:,3};
data_13cm = data13cm{:,3};
data_14cm = data14cm{:,3};
data_15cm = data15cm{:,3};

%% average 

data_0cm_average = mean(data_0cm);
data_1cm_average = mean(data_1cm);
data_2cm_average = mean(data_2cm);
data_3cm_average = mean(data_3cm);
data_4cm_average = mean(data_4cm);
data_5cm_average = mean(data_5cm);
data_6cm_average = mean(data_6cm);
data_7cm_average = mean(data_7cm);
data_8cm_average = mean(data_8cm);
data_9cm_average = mean(data_9cm);
data_10cm_average = mean(data_10cm);
data_11cm_average = mean(data_11cm);
data_12cm_average = mean(data_12cm);
data_13cm_average = mean(data_13cm);
data_14cm_average = mean(data_14cm);
data_15cm_average = mean(data_15cm);

%% taking final data to plot putting in array to plot

meandata = [data_0cm_average;data_1cm_average;data_2cm_average;data_3cm_average;data_4cm_average;data_5cm_average;data_6cm_average;data_7cm_average;data_8cm_average;data_9cm_average;data_10cm_average;data_11cm_average;data_12cm_average;data_13cm_average;data_14cm_average;data_15cm_average];

pitot_press = polyval(slope_p1,meandata);

distance = (0:1:15)*0.01;

P_pitot = polyfit(distance,pitot_press,3);
y = polyval(P_pitot,distance);

%% ploting q vs dist 
figure(2)
scatter(distance,pitot_press)
hold on 
plot(distance,y)
hold off

xlabel("Distance (cm)", "FontSize",12)
ylabel("Dynamic pressure (Pa)", "FontSize",12)
title("Dynamic Pressure vs Distance","FontSize",14)
grid on


%% calc velocity

rho = 1.225;

velo = sqrt(2*(y)/rho);
velo2 = sqrt(2*(pitot_press)./(rho));
%% plot velo vs dist
figure(3)

scatter(distance,velo2)
hold on
xlabel("Distance (cm)", "FontSize",12)
ylabel("velocity (m/s)", "FontSize",12)
title("Velocity vs Distance","FontSize",14)
grid on
slope_velo = polyfit(distance,velo,12);
y1 = polyval(slope_velo,distance);

plot(distance,y1)






