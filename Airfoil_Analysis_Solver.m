clc, close all, clear, clear variables;

T=importdata("Clark Y Airfoil.txt");
x=T.data(:,1); % X Data set Export
Yup=T.data(:,2); % Y Upper Data set Export
Ylow=T.data(:,3); % Y Lower Data set Export
Ycamber=(Yup+Ylow)/2; % Camber at each point in the data set
[Ycmax,index_max_camb] = max(Ycamber); % Y Position of Max Camber and Position in data set
xmax=x(index_max_camb); % X Position of Max Camber
g = min(x);

% Finding Leading Edge Radius Thingy
[x_le, index_leading_edge] = min(x);
yup_le = Yup(index_leading_edge);
ylow_le = Ylow(index_leading_edge);
y_le = (yup_le+ylow_le)/2;

% Getting Data Set from Leading Edge (CAN CHANGE)
flipped_x = flipud(x);
flipped_yup = flipud(Yup);
flipped_ylow = flipud(Ylow);

% Getting Data from nose of airfoil
Sample_set = 4;
Sample_set_x = flipped_x(1:Sample_set);
Sample_set_yup = flipped_yup(1:Sample_set);
Sample_set_ylow = flipped_ylow(1:Sample_set);

% Use fitcircle function to uhhhh fit a circle :P
[xc_up, yc_up, r_le_up] = fitCircle(Sample_set_x,Sample_set_yup);
[xc_low, yc_low, r_le_low] = fitCircle(Sample_set_x,Sample_set_ylow);
% Average Lower and Upper Radii
r_le_avg = (r_le_up+r_le_low)/2;

% Circle data
theta = linspace(0, 2*pi, 100);
% Upper (ended up being useless)
x_circle_up = xc_up+r_le_up*cos(theta);
y_circle_up = yc_up+r_le_up*sin(theta);
% Lower
x_circle_low = xc_low+r_le_low*cos(theta);
y_circle_low = yc_low+r_le_low*sin(theta);

%% Plot 1
figure(1)
set(groot,'DefaultLineLineWidth',2)
plot(x,Yup) % Plotting Upper Half of Airfoil Profile
hold on
plot(x,Ylow) % Plotting Lower Half of Airfoil Profile
plot(x,Ycamber, '--') % Plotting Camber Line
plot(x,g+x*0, '--') % Plotting Chord Line
plot(x_le,y_le, 'o') % Plotting Leading Edge
plot(x_circle_low, y_circle_low, 'g'); % Plotting circle
hold off
legend('Airfoil Upper Profile', 'Airfoil Lower Profile', 'Camber Line', 'Chord Line', 'Leading Edge Point', 'Leading Edge Circle')
xlim([0,1]) % Adjusting Aspect Ratio of plot
ylim([(min(Ylow)-.2) (max(Yup)+.2)])
title('NACA Clark Y Airfoil')
grid on

%% Plot 2 Information
[Low_Point_Ycoord, Low_Point_Xcoord] = min(Ylow);
Low_Point_Xcoord = x(Low_Point_Xcoord);
End_Xcoord = max(x);
End_Ycoord = Ylow(end);
Slope = (End_Ycoord - Low_Point_Ycoord) / (End_Xcoord - Low_Point_Xcoord);
m = Slope;
b1 = Low_Point_Ycoord - m * Low_Point_Xcoord;
b2 = End_Ycoord - m * End_Xcoord;

if b1 == b2
    disp('Slope-Intercept Equation can be formed.')
else
    disp('Fix your code')
end
b = b1;
Tangent = m * x + b1;

%% Plot 2
figure(2)
set(groot,'DefaultLineLineWidth',2)
plot(x,Yup) % Plotting Upper Half of Airfoil Profile
hold on
plot(x,Ylow) % Plotting Lower Half of Airfoil Profile
plot(x,Ycamber, '--') % Plotting Camber Line
plot(x,Tangent, '--') % Plotting Chord Line
plot(x_le,y_le, 'o') % Plotting Leading Edge
plot(x_circle_low, y_circle_low, 'g'); % Plotting circle
hold off
legend('Airfoil Upper Profile', 'Airfoil Lower Profile', 'Camber Line', 'Chord Line', 'Leading Edge Point', 'Leading Edge Circle')
xlim([0,1]) % Adjusting Aspect Ratio of plot
ylim([(min(Ylow)-.2) (max(Yup)+.2)])
title('NACA Clark Y Airfoil Tangent')
grid on

%% Plot 3
figure(3)
set(groot,'DefaultLineLineWidth',2)
plot(x,g+x*0, '--') % Plotting Chord Line % Plotting Tip to Tip Chord
hold on
plot(x,Tangent, '--') % Plotting Tangent Chord
hold off
legend('Tip to Tip Chord','Tangent Chord')
xlim([0,1]) % Adjusting Aspect Ratio of plot
ylim([(min(Ylow)-.2) (max(Yup)+.2)])
title('NACA Clark Y Airfoil Chord Comparison')
grid on

%% Results We Need
% does ycamber max give the max camber as a percentage
Ycmaxper=Ycmax*100; % getting as a % for max camber

% Max thickness
Thicc = Yup - Ylow;
[Thicc_max, Thicc_pos] = max(Thicc);
Thicc_max_per = Thicc_max * 100;
Thicc_max_loc = x(Thicc_pos);

z1 = ['Max Camber as a Percentage of the Chord Length: ' num2str(Ycmaxper) ' Percent'];
z2 = ['Location of Max Camber From Leading Edge: ' num2str(xmax) ' Units'];
z3 = ['Max Thickness of Airfoil: ' num2str(Thicc_max_per) ' Percent'];
z4 = ['Location of Max Thickness From Leading Edge: ' num2str(Thicc_max_loc) ' Units'];
disp(z1)
disp(z2)
disp(z3)
disp(z4)

%% Helper function to fit a circle to a set of points
function [xc, yc, R] = fitCircle(x, y)
    % This function fits a circle to the given x and y points.
    % Output: (xc, yc) center of the circle, R is the radius.

    % Create the matrix A and vector b to solve Ax = b
    A = [2*x, 2*y, ones(size(x))];
    b = x.^2 + y.^2;

    % Solve the system
    params = A \ b;

    % Extract the circle parameters
    xc = params(1);
    yc = params(2);
    R = sqrt(xc^2 + yc^2 + params(3));
end

