% Venkatraman Renganathan
% W_MSR Code studying the spoofing attack in a stochastic manner
% Input initial conditions of node values
% See the consensus converging despite having F malicious nodes
clear all; close all; clc;
m = 8;
F = 1;
time_span = 50;
repeats = 20; % Monte-carlo Simulation
repeat_vec = 1:repeats;
mean_x = zeros(repeats, 1);
delay = 3;
threshold_vector = 0.84:0.03:0.99;
snr_vector = 0:1:20;
diff_mean = zeros(length(threshold_vector),length(snr_vector));
x_0 = [50 51 52 53 54 55 300 300];
legit_mean_x0 = mean(x_0(1:end-2));

%%%%%%%%%%%%% Spoofing 1 Node %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for b = 1:length(threshold_vector)
%     for c = 1:length(snr_vector)
%         spoof_threshold = threshold_vector(b);  
%         snr = snr_vector(c);
%         x_values = spoof_resilient_wmsr(m, F, time_span, delay, spoof_threshold, snr, x_0);
%         [x_row,x_col] = size(x_values);
%         if(x_row == 8)
%             mean_x = mean(x_values(1:end-2,end));
%         else
%             mean_x = mean(x_values(1:end-1,end));
%         end
%         diff_mean(b,c) = mean_x - legit_mean_x0;    
%     end
% end

spoof_threshold = 0.95;
snr = 10;
x_values = spoof_resilient_wmsr(m, F, time_span, delay, spoof_threshold, snr, x_0);  
figure;
time_vec = 0:1:time_span+1;
plot(time_vec,x_values);
hold on;
plot(time_vec, legit_mean_x0*ones(1,time_span+2),'-.r');
hold on;
Y1 = max(x_0(1:end-2))*ones(1,time_span+2);
Y2 = min(x_0(1:end-2))*ones(1,time_span+2);
plot(time_vec, Y1, '--b', time_vec, Y2, '--b');
h = fill([time_vec fliplr(time_vec)], [Y1 fliplr(Y2)], 'b');
set(h,'facealpha',0.1);
title('Resilient Consensus using Spoof Resilient W-MSR Algorithm')
xlabel('Time Steps');
ylabel('Information states');
ylim([30 250]);
legend('Agent 1','Agent 2','Agent 3','Agent 4','Agent 5','Agent 6','Agent 7(Mal)', 'Legitimate Mean');
a = findobj(gcf, 'type', 'axes');
h = findobj(gcf, 'type', 'line');
set(h, 'linewidth', 4);
set(a, 'linewidth', 4);
set(a, 'FontSize', 24);

