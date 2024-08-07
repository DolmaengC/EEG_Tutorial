%% EEG & Matlab Tutorial
%
% 2022 BCI Lab Summer Study
% Tutorial Code - Minseok Song

clear; clc; clf;
load tutorial_data.mat
srate = 300;

%% Plot specific channel

% 1. Plot Fz data
data = table2array(eeg(:, 'Fz'));
plot(data);
legend('Fz');

% 2. Adjust the axis
xlim([0 length(data)]);
xticks([0 srate*3 srate*6 srate*9]);
xticklabels({'0', '3', '6', '9'});

xlabel('Time (sec)');
ylabel('Amplitude (\muV)');

%% Plot many channels

% 1. Plot many channels
channels = {'Fz', 'Cz'};
data = table2array(eeg(:, channels));
plot(data);
legend(channels);

% 2. Adjust the axis
xlim([0 length(data)]);
xticks([0 srate*3 srate*6 srate*9]);
xticklabels({'0', '3', '6', '9'});

xlabel('Time (sec)');
ylabel('Amplitude (\muV)');

%% Frequency Analysis (Fz channel)

% Select Fz channel
data = table2array(eeg(:, 'Fz'));

% 1. Before closing eyes (0 ~ 2s)
before_closing = data(1:srate*2);
% pspectrum(before_closing, srate); % Plot the figure without save data
[power_before, freq_before] = pspectrum(before_closing, srate); % Save data without plotting

% 2. While closing eyes (3 ~ 5s)
while_closing = data(srate*3:srate*5);
% pspectrum(while_closing, srate); % Plot the figure without save data
[power_closing, freq_closing] = pspectrum(while_closing, srate); % Save data without plotting

% 3. After closing eyes (6 ~ 8s)
after_closing = data(srate*6:srate*8);
% pspectrum(after_closing, srate); % Plot the figure without save data
[power_after, freq_after] = pspectrum(after_closing, srate); % Save data without plotting

%% Compare all of them
clf;

% Plot on frequency domain
subplot(2, 1, 1);

plot(freq_before, pow2db(power_before));  % pow2db(y) == 10log(y)
hold on;
plot(freq_closing, pow2db(power_closing));
hold on;
plot(freq_after, pow2db(power_after));

xlim([0 50]);
xlabel('Frequency (Hz)');
ylabel('Power (dB)');

legend({'Before', 'Closing', 'After'});
grid on;

% Plot on time domain
subplot(2, 1, 2);
plot(data);

xlim([0 length(data)]);
xticks([0 srate*3 srate*6 srate*9]);
xticklabels({'0', '3', '6', '9'});

xlabel('Time (sec)');
ylabel('Amplitude (\muV)');

% Fill color
co = colororder;
ylimits = ylim;
y = [ylimits(1) ylimits(1) ylimits(2) ylimits(2)];

x = [0 srate*2 srate*2 0];
patch('XData', x, 'YData', y, 'FaceColor', co(1, :), 'FaceAlpha', 0.3);

x = [srate*3 srate*5 srate*5 srate*3];
patch('XData', x, 'YData', y, 'FaceColor', co(2, :), 'FaceAlpha', 0.3);

x = [srate*6 srate*8 srate*8 srate*6];
patch('XData', x, 'YData', y, 'FaceColor', co(3, :), 'FaceAlpha', 0.3);