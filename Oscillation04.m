%% Program: myFirstScript
%  version/date : version 01, 191020
%  author(s)    : Fabrizio Musacchio, DZNE Bonn, Germany
%% DESCRIPTION
% This is my very first and super-cool MATLAB script :-D
%% PRE-INITIALIZATION
clear;
%clc;
warning 'off'; echo off; close all;
%% MAIN ROUTINE 
fprintf(1,'creating a theoretical signal curve...\n')

rng(6)  % random number generation (used inside fit- function and butterworth filter)

% Parameters:
  dt=0.01;        % step-size
  t=0:dt:5;       % time-vector in [s]
  Fs =numel(t)/t(end); % Sampling frequency, i.e., how many sample did we take within 1 s? 
  T = 1/Fs;            % Sampling period       
  L = numel(t);        % Length of signal, here: 501
  f = Fs*(0:(L/2))/L;  % Calculate the frequency domain

  
% Let's generate a theoretical curve:
  a1 =-0.5;
  a2 =-2;
  b1=3.1;
  c1=0.9;
  b2=2.5;
  c2=0.2;
  yGauss = a1*exp(-( (t-b1)/(c1) ).^2) +  a2*exp(-( (t-b2)/(c2) ).^2);
  
% Plots: 
figure(9);clf
  hold on
  plot(t, yGauss,'-c', 'LineWidth', 2.0)
  
  le = legend('original function','Location', 'SE');
  set(le, 'box', 'off')
  box on
  
  xlabel('t [s]')
  ylabel('f(t)')
  title('ideal theortical curve ')
  
  print( '-dpng', '-r600', ['theoreticalCurve06.png']);
  
fprintf(1,'done.\n')
%% FITTING THE THEORETICAL CURVE
fprintf(1,'fitting the signal curve with a model function...\n')  

% Fit the generated curve:
  % define the fittype:
    ft = fittype( 'a1*exp(-( (t-b1)/(c1) ).^2) +  a2*exp(-( (t-b2)/(c2) ).^2);', 'independent', 't', 'dependent', 'y' );
  % set fitoptions:
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [-0.5 -2 0.4 0.9 0.3 0.45]; % initial-guess values
                      %  a1 a2  b1  b2  c1  c2
  % Fit model to data:
    [yFit, gof] = fit( t', yGauss', ft, opts );
    
    
figure(9);clf
  hold on
  plot(t, yGauss,'-c', 'LineWidth', 2.0)
  plot(t, feval(yFit, t), '--k', 'LineWidth', 2.0)
  
  le = legend('original function','fit', 'Location', 'SE');
  set(le, 'box', 'off')
  box on
  
  xlabel('t [s]')
  ylabel('f(t)')
  title('ideal theortical curve ')
  
  print( '-dpng', '-r600', ['theoreticalCurve06.png']);
    
  
fprintf(1,'done.\n')
%% FITTING THE THEORETICAL CURVE WITH NOISY
fprintf(1,'fitting noisy signal with a model function...\n')  

% Add some noise:
  noise          = 0.15*randn(1, numel(yGauss));
  yGaussNoise    = yGauss+noise;

% Fit model to data:
  [yFit, gof] = fit( t', yGaussNoise', ft, opts );
    
    
figure(9);clf
  hold on
  plot(t, yGaussNoise,'-y', 'LineWidth', 1.0)
  plot(t, yGauss,'-c', 'LineWidth', 2.0)
  plot(t, feval(yFit, t), '--k', 'LineWidth', 2.0)
  
  le = legend('noisy signal','original function','fit', 'Location', 'SE');
  set(le, 'box', 'off')
  box on
  
  xlabel('t [s]')
  ylabel('f(t)')
  title('ideal theortical curve ')
  
  print( '-dpng', '-r600', ['theoreticalCurve06.png']);
    
  
fprintf(1,'done.\n')
%% FITTING THE THEORETICAL CURVE WITH NOISY + DENOISING
fprintf(1,'fitting noisy +denoised signal with a model function...\n')  

% Denoise:
  ButterworthCutoffFreq = 3;  
  ButterworthOrder      = 5;     
  fNorm = ButterworthCutoffFreq / (Fs/2);   
  [B,A] = butter(ButterworthOrder, fNorm, 'low'); % 'low'
  yGauss_Cleaned = filtfilt(B, A, yGaussNoise );


% Fit model to data:
  [yFit, gof] = fit( t', yGauss_Cleaned', ft, opts );
    
    
figure(9);clf
  hold on
  plot(t, yGaussNoise,'-y', 'LineWidth', 1.0)
  plot(t, yGauss_Cleaned,'-r', 'LineWidth', 1.0)
  plot(t, yGauss,'-c', 'LineWidth', 2.0)
  plot(t, feval(yFit, t), '--k', 'LineWidth', 2.0)
  
  le = legend('noisy signal', 'denoised signal','original function','fit', 'Location', 'SE');
  set(le, 'box', 'off')
  box on
  
  xlabel('t [s]')
  ylabel('f(t)')
  title('ideal theortical curve ')
  
  print( '-dpng', '-r600', ['theoreticalCurve06.png']);
    
  
fprintf(1,'done.\n')
%% Extract some data features:
fprintf(1,'extracting some features from the fitted model curve...\n')  

yFitEval = feval(yFit, t);

yPeakIdx = find(yFitEval==min(yFitEval)); % Find peak-index
yPeak = yFitEval(yPeakIdx);
tPeak = t(yPeakIdx);
fprintf(1, 'Peak amplitude is %2.2f at t=%2.2f s\n', yPeak, tPeak)

plot(tPeak, yPeak,'or')

fprintf(1,'done.\n')
%% END
fprintf(1,'done. END\n')