% Venkatraman Renganathan
% W_MSR Code
% Input initial conditions of node values
% See the consensus converging despite having F malicious nodes
clear all; close all; clc;
x0 = [60,75,68,70,66,83,300,300]';
m = length(x0);
time_span = 40;
delay = 7;
x = resilient_wmsr(m, time_span, delay, x0);
time_vec = 0:1:time_span;
plot(time_vec,x);
hold on;
plot(time_vec, mean(x0(1:end-2))*ones(1,time_span+1),'-.r');
hold on;
Y1 = max(x0(1:end-2))*ones(1,time_span+1);
Y2 = min(x0(1:end-2))*ones(1,time_span+1);
plot(time_vec, Y1, '--b', time_vec, Y2, '--b');
h = fill([time_vec fliplr(time_vec)], [Y1 fliplr(Y2)], 'b');
set(h,'facealpha',0.1);
%title('Resilient Consensus using Spoof Resilient W-MSR Algorithm')
title('SR-W-MSR Restoring Effect of Delay in Attack Detection');
xlabel('Time Steps');
ylabel('Information states');
ylim([20 320]);
legend('Agent 1','Agent 2','Agent 3','Agent 4','Agent 5','Agent 6','Agent 7(Mal)', 'Legitimate Mean');
a = findobj(gcf, 'type', 'axes');
h = findobj(gcf, 'type', 'line');
set(h, 'linewidth', 4);
set(a, 'linewidth', 4);
set(a, 'FontSize', 24);
