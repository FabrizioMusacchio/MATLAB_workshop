%% Program: dataRead01
%  version/date : version 01, 191020
%  author(s)    : Fabrizio Musacchio, DZNE Bonn, Germany
%% DESCRIPTION
% This is my very first and super-cool MATLAB script :-D
%% PRE-INITIALIZATION
clear;
%clc;
warning 'off'; echo off; close all;
%% MAIN ROUTINE 
fprintf(1,'reading and processing a data file...\n')

IN = readtable('PatchClampData.xlsx');
current = IN.I;  % PatchClamp current [pA]
time    = IN.time;  % time [ms]

currentClean = denoise(time,current,10);
BGestimate   = max(currentClean);
currentClean = currentClean-BGestimate;
current      = current-BGestimate;

ticTimeElapseStart = tic;
% Fit a curve to the data: 
%   Definitions for Gaussian-fit:
    ft = fittype( 'gauss8' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
%     
%   % Definitions for Fouerie series-fit:
%     ft = fittype( 'fourier4' );
%     opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
%     opts.Display = 'Off';
    
  % Definitions for Smoothspline-fit:
%     ft = fittype( 'smoothingspline' );
%     opts = fitoptions( 'Method', 'SmoothingSpline' );
%     opts.Normalize = 'on';
%     opts.SmoothingParam = 0.7;

  % Fit model to data:
    [yFit, gof] = fit( time, currentClean, ft, opts );

ticTimeElapsed = toc(ticTimeElapseStart);
fprintf(1,'CPU time %8.2f s)\n', ticTimeElapsed);

figure(10);clf
   hold on 
   plot(time, current, '-c' )
   plot(time, currentClean, '-k', 'LineWidth',2 )
   plot(time, feval(yFit, time), '--m' , 'LineWidth',2 )
   


   le = legend('raw data','denoised data','data fit', 'Location', 'SE');
   set(le, 'box', 'off')
   
   box on
   
   xlabel('time [ms]')
   ylabel('current [pA]')
   title('Measured PatchClamp Current')
   
   print( '-dpng', '-r600', ['myDataResults02.png']);

fprintf(1,'done.\n')
%% SAVE RESULTS INTO FILE
fprintf(1,'saving results...\n')

% Create and open txt-File using fopen+fprintf:
  filename = 'resultsLog.txt';
  fidLog = fopen(filename, 'w', 'n', 'UTF-8');
  if fidLog>0
      fprintf(1, 'Created txt file (%s)\n', filename)
  end
% Write data into file
  fprintf(fidLog, 'Hello World.\n My results:\n');
  for i=1:numel(time)
      fprintf(fidLog, '%3.10f\t %e\n', time(i), ...
                   currentClean(i) );
  end

% Close file (important!):
  fclose(fidLog);
  
% Write xlsx-File using table + writetable:
  filename = 'resultsLog.xlsx';
  TableHeader = [{'time'} {'current'}];
  TableArray  = table( time, currentClean, ...
                       'VariableNames',TableHeader);

  writetable(TableArray,filename);  
  
fprintf(1,'done.\n')
%% END
fprintf(1,'I am done\n')