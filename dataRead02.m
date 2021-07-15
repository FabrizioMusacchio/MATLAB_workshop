%% Program: dataRead02
%  version/date : version 01, 191020
%  author(s)    : Fabrizio Musacchio, DZNE Bonn, Germany
%% DESCRIPTION
% This is my very first and super-cool MATLAB script :-D
%% PRE-INITIALIZATION
clear;
%clc;
warning 'off'; echo off; close all;
%% REAT DATA
fprintf(1,'reading data file...\n')

IN = readtable('PeakTestData.xlsx');
time    = IN.time;  % time [s]
traces= table2array(IN(:,2:end));
tracesN = size(traces,2);

fprintf(1,'done.\n')
%% PROCESS DATA
fprintf(1,'processing a data file...\n')

figure(13);clf
  hold on
  tracesCleaned = zeros(size(traces));
  
  Tearly = [];
  Tlate  = [];
  Aearly = [];
  Alate  = [];
  
  for i=1:tracesN
      plot(time, traces(:,i) , '-c' )
      
      tracesCleaned(:,i) = denoise(time, traces(:,i), 5);
      plot(time, tracesCleaned(:,i) , '-k' )

      ft = fittype( 'gauss2' );
      opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
      opts.Display = 'Off';
      [yFit, gof] = fit( time, tracesCleaned(:,i), ft, opts );
      plot(time, feval(yFit, time), '-m' , 'LineWidth',1.25 )
      
      yFitEval = feval(yFit, time);
      idxMax = find(yFitEval==max(yFitEval));
      fprintf(1,'Peak=%2.2f at t=%2.2f s\n',yFitEval(idxMax), time(idxMax) )
      plot(time(idxMax), yFitEval(idxMax), '.k', 'MarkerSize', 20)
      

      if time(idxMax)>=6
          plot(time, feval(yFit, time), '-b' , 'LineWidth',1.25 )
          
          Tlate = [Tlate time(idxMax)];
          Alate = [Alate yFitEval(idxMax)];
      else
          plot(time, feval(yFit, time), '-r' , 'LineWidth',1.25 )
          Tearly = [Tearly time(idxMax)];
          Aearly = [Aearly yFitEval(idxMax)];
      end
       
  end
  
  print( '-dpng', '-r600', ['PeakTestResults.png']);
  
fprintf(1,'done.\n')
%% STATISTICAL ANALYIS
fprintf(1,'doing some statistics...\n')

figure(14);clf
  hold on
  boxplot([Aearly' Alate'])
  plot(ones(numel(Aearly),1), Aearly, 'ok', 'MarkerSize', 5 )
  plot(ones(numel(Alate),1).*2, Alate, 'ok', 'MarkerSize', 5 )
  
  xlim([0 3]) 
  ylim([2.5 5.0])
  ylabel('Peaks [a.u.]')
  
  set(gca,'XTick', 1:2);
  set(gca,'XTickLabel', [{'early peaks'} {'late peaks'} ]);
  xtickangle(45)
  
  ax = gca;
  ax.LineWidth = 1.5;
  
  [h, p] = ttest2(Aearly, Alate);
  
  if h==1
     text(0.45,3,['significant difference, p=' num2str(p,'%2.3e')], 'FontSize', 12  ) 
  else
     text(0.45,3,['no significant difference, p=' num2str(p,'%1.3f')], 'FontSize', 12  ) 
  end

  print( '-dpng', '-r600', ['statisticsResults.png']);
  
fprintf(1,'done.\n')
%% STATISTICAL ANALYIS (BETTER PLOT)
fprintf(1,'making beautiful plots...\n')

fig=figure('Visible','on');clf
  %set(fig,'Visible','off')
  set(fig,'PaperUnits','centimeters',...
          'PaperType','A4','PaperSize',[  8 11.5 ],...
          'PaperOrientation', 'Portrait')
  set(fig,'PaperPosition',[0.0 0.0 [8 11.5] ]); %[left, bottom, width, height]

  hold on
  boxplot([Aearly' Alate'])
  plot(ones(numel(Aearly),1), Aearly, 'ok', 'MarkerSize', 5 )
  plot(ones(numel(Alate),1).*2, Alate, 'ok', 'MarkerSize', 5 )
  
  ylim([2.5 5.0])
  ylabel('Peaks [a.u.]')
  title('Significance Test')
  
  set(gca,'XTick', 1:2);
  set(gca,'XTickLabel', [{'early peaks'} {'late peaks'} ]);
  xtickangle(45)
  
  ax = gca;
  ax.LineWidth = 1.5;
  
  [h, p] = ttest2(Aearly, Alate);
  
  if h==1
     text(0.75,3,['significant difference,' ], 'FontSize', 10  ) 
     text(0.75,2.9,['p=' num2str(p,'%2.3e')], 'FontSize', 10  ) 
  else
     text(0.75,3,['no significant difference,' ], 'FontSize', 10  ) 
     text(0.75,2.9,['p=' num2str(p,'%1.3f')], 'FontSize', 10  ) 
  end

  print( '-dpdf', '-r600', ['statisticsResults2.pdf']);

  fprintf(1,'done.\n')
%% CLUSTER USING MACHINE LEARNING APPROACHES

Data2Cluster = [  [Tearly Tlate]' [Aearly Alate]' ];
k=2;
idx = kmeans(Data2Cluster,k);

figure(16);clf
  plot(Data2Cluster(idx==1,1),Data2Cluster(idx==1,2),'r.','MarkerSize',12)
  hold on
  plot(Data2Cluster(idx==2,1),Data2Cluster(idx==2,2),'b.','MarkerSize',12)
  
  le = legend('Cluster 1 (early)','Cluster 2 (late)', 'Location','SW');
  set(le, 'box', 'off')
  
  xlabel('peak times')
  ylabel('peak amplitudes')
  title('Clustering with kmeans')
  
  print( '-dpng', '-r600', ['statisticsResultsKMEANS.png']);
  
  
%% END
fprintf(1,'I am done\n')