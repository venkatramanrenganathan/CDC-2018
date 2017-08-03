clear all; close all; clc;
dt = 0.001; 
tMax = 10;
t = (0 : dt : tMax)';
repeats = 1000;
% adding white noise
snr_max = 10;
signal_noise_ratio = 0:snr_max;
signal_similarity = zeros(length(signal_noise_ratio),1);
similarity = zeros(repeats,1);
for i = 1: length(signal_noise_ratio)
    for j = 1:repeats
        y1 = randn(length(t), 1);
        % Spoofed neighbor fingerprint looks like delayed and amplified fingerprint
        % of legitimate neighbor x. That is, y1 spoofs y2
        y2 = [zeros(4,1); 3.*y1(1:length(t)-4,:)];
        y1 = awgn(y1,signal_noise_ratio(i),'measured');
        y2 = awgn(y2,signal_noise_ratio(i),'measured');
        similarity(j) = max(abs(xcorr(y1,y2)))/(norm(y1,2)*norm(y2,2))*100;
    end
    signal_similarity(i) = mean(similarity);
end

figure;
plot(signal_noise_ratio, signal_similarity)
set(gca, 'XLim', [0, snr_max])
grid on
xlabel('Signal To Noise Ratio')
ylabel('Signal Similarity(%)')
set(gca, 'XLim', [0, snr_max])
a = findobj(gcf, 'type', 'axes');
h = findobj(gcf, 'type', 'line');
set(h, 'linewidth', 4);
set(a, 'linewidth', 4);
set(a, 'FontSize', 24);