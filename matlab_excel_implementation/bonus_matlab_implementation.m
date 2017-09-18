%GOPH 547
%Ye Sun
%Safian Omar Qureshi
%ID: 10086638
%Collaberated with Tian Yu, Younghwan Ryan Ok

%% Data preparation

clear;close all;

data = xlsread('bonus_matlab_data.xlsx','Sheet1','A3:F15');

floor = data(:,1); %  the number of floor (basement = 0)
g_inst = data(:,2); % absoluted reading of gravity (instrument units)
g = data(:,3); % absolute reading of gravity (mGal)
total_time = data(:,4); % accumulative time spent in minutes (min)
g_r = data(:,5); %the relative gravity (mGal)
interval_height = data(:,6); % The Height of each floor from basement to 8th

%% Drift correction
%Ploting drift
ind = find(floor == 0);
figure(1);
plot(total_time(ind),g_r(ind),'o');hold on;
title('Drift Error');
xlabel('Total Survey Time [min]');
ylabel('Relative Gracity [mGal]');

% calculate drift using linear regression method
dg_drift = zeros(size(g_r));
k1 = ind(1); 
for i = ind(2:end)'
    k2 = i;
    fit = polyfit([total_time(k1),total_time(k2)],[g_r(k1),g_r(k2)],1);
    dg_drift(k1+1:k2) = fit(1)*total_time(k1+1:k2)+fit(2); 
    k1 = k2;
end
plot(total_time,dg_drift,'*-');hold off;
legend('Basement readings','Calculated drift');


figure(2);
g_r_drift = g_r-dg_drift; %apply drift correction
plot(total_time,g_r); hold on;
plot(total_time,g_r_drift); hold off;
xlabel('Total Survey Time [min]');
ylabel('Relative Gracity [mGal]');
title('Dirft correction');
legend('Before','After')

%% Gradient calculation
g_r_drift(ind(2:end)) = []; % trim repeated basement measurement
interval_height(ind(2:end)) = []; % trim repeated basement height


height = cumsum(interval_height); % convert interval height into cumulative height

figure(3);
plot(height,g_r_drift);
xlabel('Height [m]');
ylabel('Drift-corrected Relative Gracity [mGal]');
title('Free-air Gradient')

fit = polyfit(height,g_r_drift,1);
hold on; plot(height,polyval(fit,height));
hold off;
legend('Average raw measurment','Linear fit')


FA_gradient = fit(1); % extract the slope

disp(['Free-Air gradient = ' num2str(FA_gradient)]);

