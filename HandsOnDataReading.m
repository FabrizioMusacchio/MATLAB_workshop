%% CLEAR EVERYTHING
clear
%% DATAREADING
IN      = readtable('PatchClampData.xlsx');
time    = IN.time;
current = IN.I;

%% DATA PROCESSING

currentClean = denoise(time, current, 10) -max(current);

% Fitting:
    ft = fittype( 'gauss8' );
    yFit = fit(time, currentClean, ft);
    yFitEval = feval(yFit, time);

%% PLOTS

figure(1);clf
  hold on
  plot(time, current-max(current), '-k')
  plot(time, currentClean, '-g', 'LineWidth',4 )
  plot(time, yFitEval, '-c', 'LineWidth',4 )

%% ENDINGS

