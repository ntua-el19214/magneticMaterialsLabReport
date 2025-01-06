clear;
close all;
clc;

% Add all paths to current directory
addpath(genpath('.'));

% Define file paths
filePath_100 = '100mm.csv';
filePath_150 = '150mm.csv';
filePath_200 = '200mm.csv';
filePath_250 = '250mm.csv';

% Load CSV files into tables
dataTable_100 = readtable(filePath_100);
dataTable_150 = readtable(filePath_150);
dataTable_200 = readtable(filePath_200);
dataTable_250 = readtable(filePath_250);
disp('CSV files loaded successfully.');

% Extract data for plotting and smooth the voltages
time_100 = dataTable_100.second;
volt_100 = smoothdata(dataTable_100.Volt, 'movmean', 10);
intervalIdx_100 = findDetectionTime(time_100, volt_100);
detectionTime_100 = time_100(intervalIdx_100(1,2)) - time_100(intervalIdx_100(1,1));
velocity_100 = 0.1/detectionTime_100;
fprintf('Velocity for d = 100mm: %2.f\n', velocity_100)

time_150 = dataTable_150.second;
volt_150 = smoothdata(dataTable_150.Volt, 'movmean', 10);
intervalIdx_150 = findDetectionTime(time_150, volt_150);
detectionTime_150 = time_150(intervalIdx_150(1,2)) - time_150(intervalIdx_150(1,1));
velocity_150 = 0.15/detectionTime_150;
fprintf('Velocity for d = 150mm: %2.f\n', velocity_150)

time_200 = dataTable_200.second;
volt_200 = smoothdata(dataTable_200.Volt, 'movmean', 10);
intervalIdx_200 = findDetectionTime(time_200, volt_200);
detectionTime_200 = time_100(intervalIdx_200(1,2)) - time_100(intervalIdx_200(1,1));
velocity_200 = 0.2/detectionTime_200;
fprintf('Velocity for d = 200mm: %2.f\n', velocity_200)

time_250 = dataTable_250.second;
volt_250 = smoothdata(dataTable_250.Volt, 'movmean', 10);
intervalIdx_250 = findDetectionTime(time_250, volt_250);
detectionTime_250 = time_250(intervalIdx_250(1,2)) - time_250(intervalIdx_250(1,1));
velocity_250 = 0.25/detectionTime_250;
fprintf('Velocity for d = 250mm: %2.f\n', velocity_250)
% Create subplots
figure;

% 100mm data
subplot(2, 2, 1);
plot(time_100 * 10^6, volt_100, 'b-', 'LineWidth', 1.5); % Original plot
title('100mm Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;
% Add detection time as text
text(mean(time_100) * 10^6, max(volt_100) * 0.8, ...
    sprintf('Detection Time: %.2f \\mus', detectionTime_100 * 10^6), ...
    'FontSize', 10, 'Color', 'k');

% 150mm data
subplot(2, 2, 2);
plot(time_150 * 10^6, volt_150, 'r-', 'LineWidth', 1.5); % Original plot
title('150mm Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;
% Add detection time as text
text(mean(time_150) * 10^6, max(volt_150) * 0.8, ...
    sprintf('Detection Time: %.2f \\mus', detectionTime_150 * 10^6), ...
    'FontSize', 10, 'Color', 'k');

% 200mm data
subplot(2, 2, 3);
plot(time_200 * 10^6, volt_200, 'g-', 'LineWidth', 1.5); % Original plot
title('200mm Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;
% Add detection time as text
text(mean(time_200) * 10^6, max(volt_200) * 0.8, ...
    sprintf('Detection Time: %.2f \\mus', detectionTime_200 * 10^6), ...
    'FontSize', 10, 'Color', 'k');

% 250mm data
subplot(2, 2, 4);
plot(time_250 * 10^6, volt_250, 'k-', 'LineWidth', 1.5); % Original plot
title('250mm Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;
% Add detection time as text
text(mean(time_250) * 10^6, max(volt_250) * 0.8, ...
    sprintf('Detection Time: %.2f \\mus', detectionTime_250 * 10^6), ...
    'FontSize', 10, 'Color', 'k');

% Adjust layout
sgtitle('Voltage vs Time for Different Distances');


figure;

%% Plot calculated intervals to pick the correct indexes
% 100mm data
subplot(2, 2, 1);
plot(time_100 * 10^6, volt_100, 'b-', 'LineWidth', 1.5); % Original data
title('100mm Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;
hold on; % Overlay intervals

% Plot intervals for 100mm
for i = 1:size(intervalIdx_100, 1)
    x1 = time_100(intervalIdx_100(i, 1)) * 10^6;
    x2 = time_100(intervalIdx_100(i, 2)) * 10^6;
    fill([x1, x2, x2, x1], [min(volt_100), min(volt_100), max(volt_100), max(volt_100)], ...
         'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none'); % Shaded interval
end

% 150mm data
subplot(2, 2, 2);
plot(time_150 * 10^6, volt_150, 'r-', 'LineWidth', 1.5); % Original data
title('150mm Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;
hold on; % Overlay intervals

% Plot intervals for 150mm
for i = 1:size(intervalIdx_150, 1)
    x1 = time_150(intervalIdx_150(i, 1)) * 10^6;
    x2 = time_150(intervalIdx_150(i, 2)) * 10^6;
    fill([x1, x2, x2, x1], [min(volt_150), min(volt_150), max(volt_150), max(volt_150)], ...
         'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none'); % Shaded interval
end

% 200mm data
subplot(2, 2, 3);
plot(time_200 * 10^6, volt_200, 'g-', 'LineWidth', 1.5); % Original data
title('200mm Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;
hold on; % Overlay intervals

% Plot intervals for 200mm
for i = 1:size(intervalIdx_200, 1)
    x1 = time_200(intervalIdx_200(i, 1)) * 10^6;
    x2 = time_200(intervalIdx_200(i, 2)) * 10^6;
    fill([x1, x2, x2, x1], [min(volt_200), min(volt_200), max(volt_200), max(volt_200)], ...
         'g', 'FaceAlpha', 0.2, 'EdgeColor', 'none'); % Shaded interval
end

% 250mm data
subplot(2, 2, 4);
plot(time_250 * 10^6, volt_250, 'k-', 'LineWidth', 1.5); % Original data
title('250mm Data');
xlabel('Time (\mus)');
ylabel('Voltage (V)');
grid on;
hold on; % Overlay intervals

% Plot intervals for 250mm
for i = 1:size(intervalIdx_250, 1)
    x1 = time_250(intervalIdx_250(i, 1)) * 10^6;
    x2 = time_250(intervalIdx_250(i, 2)) * 10^6;
    fill([x1, x2, x2, x1], [min(volt_250), min(volt_250), max(volt_250), max(volt_250)], ...
         'k', 'FaceAlpha', 0.2, 'EdgeColor', 'none'); % Shaded interval
end


dt = linspace(0, 100/10^6, 1000);
dist = dt.*mean([velocity_100 velocity_150 velocity_200 velocity_250]);
% Plot the results
figure;
plot(dt*10^6, dist*1000, 'LineWidth', 1.5);
xlabel('Detection Time (\mus)');
ylabel('Distance (mm)');
title('Distance vs Detection Time (with Mean Velocity)');
grid on


function intervalIdx = findDetectionTime(timeVector, voltageVector)
    % Set small voltage values to zero
    voltageVector(abs(voltageVector) < 0.02) = 0;

    % Identify non-zero segments
    nonZeroIdx = find(voltageVector ~= 0); % Indices of non-zero values

    % Compute intervals between consecutive non-zero values
    intervalLengths = diff(nonZeroIdx); % Differences in indices

    % Find intervals greater than the specified length (e.g., 10)
    longIntervalsIdx = find(intervalLengths > 10);

    % Return start and end indices of long intervals
    intervalIdx = [nonZeroIdx(longIntervalsIdx), nonZeroIdx(longIntervalsIdx + 1)];
end
