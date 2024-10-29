% The run_test_suite.m script records the execution durations across five 
% runs of Volterra filtering using the "Morhac", "Product Map" (PM), and 
% "Permutation/Product Map" (PPM) methods for Volterra kernels of memories,
% M={1,2,...,17}, and orders, K={1,2,...,5}. 
% This script produces the file `results_latest.mat` in the data/results 
% subdirectory. 


clc; clearvars; close all;

% results file name
resultFileName = 'data/results/results_latest.mat';

% load Volterra filtering method scripts
currentFile = mfilename('fullpath');
[pathstr, ~, ~] = fileparts(currentFile);
addpath(fullfile(pathstr, 'methods/morhac'));
addpath(fullfile(pathstr, 'methods/pm'));
addpath(fullfile(pathstr, 'methods/ppm'));

% load input kernels & Gaussian input signal
load('data/kernels/kernels_data.mat', 'hs', 'hsMorhac', 'xGauss');
xGauss1 = xGauss(1:1000);

Ks = 1:5;
Ms = 1:17;

ysMorhac = cell(length(Ks), length(Ms));
ysPM = cell(length(Ks), length(Ms));
ysPPM = cell(length(Ks), length(Ms));

timingsMorhac = cell(length(Ks), length(Ms));
timingsPM = cell(length(Ks), length(Ms));
timingsPPM = cell(length(Ks), length(Ms));

nRuns = 5;

for K=Ks
    for M=Ms
        h = hs{K, M};
        hMor = hsMorhac{K, M};
        results = compete(xGauss1, h, hMor, M, K, nRuns);
        
        ysMorhac{K,M} = results.yMorhacRuns;
        ysPM{K,M} = results.yPMRuns;
        ysPPM{K,M} = results.yPPMRuns;

        timingsMorhac{K,M} = results.tMorhacRuns;
        timingsPM{K,M} = results.tPMRuns;
        timingsPPM{K,M} = results.tPPMRuns;
    end
end

save(resultFileName, 'timingsMorhac', 'timingsPM', 'timingsPPM')


function results = compete(x, h, hMorhac, M, K, nRuns)
    results = struct();

    N = length(x);
    results.yMorhacRuns = zeros(nRuns, N);
    results.yPMRuns = zeros(nRuns, N);
    results.yPPMRuns = zeros(nRuns, N);
    
    results.tMorhacRuns = zeros(nRuns, 1);
    results.tPMRuns = zeros(nRuns, 1);
    results.tPPMRuns = zeros(nRuns, 1);
    for ii=1:nRuns
        [yMorhacRun, tMorhacRun] = volterraFilterMorhac(x, hMorhac, M, K);
        [yPMRun, tPMRun] = volterraFilterPM(x, h, M, K);
        [yPPMRun, tPPMRun] = volterraFilterPPM(x, h, M, K);

        results.yMorhacRuns(ii, :) = yMorhacRun.';
        results.yPMRuns(ii, :) = yPMRun.';
        results.yPPMRuns(ii, :) = yPPMRun.';

        results.tMorhacRuns(ii) = tMorhacRun;
        results.tPMRuns(ii) = tPMRun;
        results.tPPMRuns(ii) = tPPMRun;
        
        [~,minIdx] = min([tMorhacRun, tPMRun, tPPMRun]);
        nRes = '';
        if minIdx == 1
            nRes = 'Mor';
        elseif minIdx == 2
            nRes = 'PM';
        elseif minIdx == 3
            nRes = 'PPM*';
        end
        fprintf('{K=%d, M=%d, run=%d}: Morhac Time: %g, PM Time: %g, PPM Time: %g %s\n', ...
            K, M, ii, tMorhacRun, tPMRun, tPPMRun, nRes)
    end
end