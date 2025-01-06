clear;
close all;
clc;

% Add all paths to current directory
addpath(genpath('.'));

% Define file paths
filePath_5 = '5g.csv';
filePath_20 = '20g.csv';
filePath_100 = '100g.csv';
filePath_200 = '200g.csv';

% Load CSV files into tables
dataTable_5 = readtable(filePath_5);
dataTable_20 = readtable(filePath_20);
dataTable_100 = readtable(filePath_100);
dataTable_200 = readtable(filePath_200);
disp('CSV files loaded successfully.');
um_x = 200;
% Extract data for plotting and smooth the voltages
time_5 = dataTable_5.second;
volt_5 = smoothdata(dataTable_5.Volt, 'movmean', 10);
[peakValues_5, peakIdx_5] = findpeaks(volt_5, 'MinPeakHeight', 0.0065, 'MinPeakDistance', um_x);
fprintf('Amplitude of first reflected wave is: %2.f mV\n', peakValues_5(3)*1000)

time_20 = dataTable_20.second;
volt_20 = smoothdata(dataTable_20.Volt, 'movmean', 10);
[peakValues_20, peakIdx_20] = findpeaks(volt_20, 'MinPeakHeight', 0.014, 'MinPeakDistance', um_x);
fprintf('Amplitude of first reflected wave is: %2.f mV\n', peakValues_20(3)*1000)

time_100 = dataTable_100.second;
volt_100 = smoothdata(dataTable_100.Volt, 'movmean', 10);
[peakValues_100, peakIdx_100] = findpeaks(volt_100, 'MinPeakHeight', 0.018, 'MinPeakDistance', um_x);
fprintf('Amplitude of first reflected wave is: %2.f mV\n', peakValues_100(3)*1000)

time_200 = dataTable_200.second;
volt_200 = smoothdata(dataTable_200.Volt, 'movmean', 10);
[peakValues_200, peakIdx_200] = findpeaks(volt_200, 'MinPeakHeight', 0.02,'MinPeakDistance', um_x);
fprintf('Amplitude of first reflected wave is: %2.f mV\n', peakValues_200(3)*1000)

% Create subplots
figure;

% 100mm data (5g Data)
subplot(2, 2, 1);
plot(time_5 * 10^6, volt_5, 'b-', 'LineWidth', 1.5); % Original plot
title('5g Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;

% Plot semi-transparent vertical lines at each peak index
hold on;
for i = 1:length(peakIdx_5)
    xline(time_5(peakIdx_5(i)) * 10^6, 'r', 'LineWidth', 1.5, 'Alpha', 0.3); % Red semi-transparent lines
end
hold off;

% 150mm data (20g Data)
subplot(2, 2, 2);
plot(time_20 * 10^6, volt_20, 'r-', 'LineWidth', 1.5); % Original plot
title('20g Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;

% Plot semi-transparent vertical lines at each peak index
hold on;
for i = 1:length(peakIdx_20)
    xline(time_20(peakIdx_20(i)) * 10^6, 'g', 'LineWidth', 1.5, 'Alpha', 0.3); % Green semi-transparent lines
end
hold off;

% 200mm data (100g Data)
subplot(2, 2, 3);
plot(time_100 * 10^6, volt_100, 'g-', 'LineWidth', 1.5); % Original plot
title('100g Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;

% Plot semi-transparent vertical lines at each peak index
hold on;
for i = 1:length(peakIdx_100)
    xline(time_100(peakIdx_100(i)) * 10^6, 'b', 'LineWidth', 1.5, 'Alpha', 0.3); % Blue semi-transparent lines
end
hold off;

% 250mm data (200g Data)
subplot(2, 2, 4);
plot(time_200 * 10^6, volt_200, 'k-', 'LineWidth', 1.5); % Original plot
title('200g Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;

% Plot semi-transparent vertical lines at each peak index
hold on;
for i = 1:length(peakIdx_200)
    xline(time_200(peakIdx_200(i)) * 10^6, 'm', 'LineWidth', 1.5, 'Alpha', 0.3); % Magenta semi-transparent lines
end
hold off;


% Adjust layout
sgtitle('Voltage vs Time for Different Distances');

figure
% Define x-values (assuming these correspond to the original data points)
x = [5, 20, 100, 200];

% Define the voltage vector
voltage = [peakValues_5(3), peakValues_20(3), peakValues_100(3), peakValues_200(3)];

% Define new x-values where you want to interpolate
xq = linspace(5, 200, 50); % Generates 50 points between 5 and 200

% Perform interpolation (linear by default)
voltage_interp = interp1(log10(x), voltage, log10(xq), 'linear'); % Linear in log-space

% Plot original and interpolated data
plot(x, voltage*10^3, 'ro', 'MarkerSize', 8, 'LineWidth', 2); % Original points
hold on;
plot(xq, voltage_interp*10^3, 'b-', 'LineWidth', 1.5); % Interpolated curve
xlabel('Weight (g)');
ylabel('Voltage (mV)');
legend('Original Data', 'Interpolated Data');
title('Voltage meassurement Vs Added edge weight');
grid on;


% dt = linspace(0, 100/10^6, 1000);
% dist = dt.*mean([velocity_5 velocity_20 velocity_100 velocity_200]);
% % Plot the results
% figure;
% plot(dt*10^6, dist*1000, 'LineWidth', 1.5);
% xlabel('Detection Time (\mus)');
% ylabel('Distance (mm)');
% title('Distance vs Detection Time (with Mean Velocity)');
% grid on

function [peakIdx, peakValues] = findPeaks(voltageVector)
    % Set small & megative voltage values to zero (below 0.02)
    voltageVector(voltageVector < 0.001) = 0;

    % Find peaks in the voltage vector using findpeaks
    [peaks, peakIdx] = findpeaks(voltageVector);

    % Filter out peaks with low amplitude, if necessary (e.g., below 0.02)
    peakIdx = peakIdx(peaks > 0.02); % Retain only peaks above 0.02

    % Return both the peak values and their indices
    peakValues = peaks(peaks > 0.02); % The actual peak values (optional)
end
