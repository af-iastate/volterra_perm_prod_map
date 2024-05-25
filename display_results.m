% The display_results.m script plots the results produced by the script: 
% run_test_suite.m. 
% It plots the results within data/results/results_record.mat. 
% This behavior can be changed by modifying the "load" command to load 
% the ".mat" file containing the desired results. 


clc; close all; clearvars;

% load results file
load('data/results/results_record.mat')

% plot K=3 through K=5
figure(1);
plot_results(3, timingsMorhac, timingsPM, timingsPPM);

figure(2);
plot_results(4, timingsMorhac, timingsPM, timingsPPM);

figure(3);
plot_results(5, timingsMorhac, timingsPM, timingsPPM);


function plot_results(K, tMorhac, tPM, tPPM)
    Ms = 2:17;

    tMorhacSeries = arrayfun(@(M) mean(tMorhac{K, M}), Ms);
    tPMSeries = arrayfun(@(M) mean(tPM{K, M}), Ms);
    tPPMSeries = arrayfun(@(M) mean(tPPM{K, M}), Ms);

    xTickArr = Ms;
    xLabelStr = '$M$';
    titleStr = sprintf('Mean Runtime $K=%d$', K);

    gcf();
    clf();
    hold on;
    plot(xTickArr, tMorhacSeries, 'Marker','o');
    plot(xTickArr, tPMSeries, 'Marker','*')
    plot(xTickArr, tPPMSeries, 'Marker','x');
    hold off;
    ylabel('sec.')
    xlabel(xLabelStr, 'Interpreter','latex');
    xticks(xTickArr);
    title(titleStr, 'Interpreter', 'latex');
    mLegend = {'Mor', 'PM', 'PPM'};
    legend(mLegend, ...
        'Location', 'northwest', ...
        'Orientation', 'horizontal', ...
        'Interpreter', 'latex');
    axis([min(xTickArr)-0.25, max(xTickArr)+0.25, ylim])
    box on;
end