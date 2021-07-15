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
fprintf(1,'creating several oscillation and generting artificial time series...\n')


% Parameters:
    dt=0.01;        % step-size
    t=0:dt:5;       % time-vector in [s]
    f_array = [1 2 4 10];
    A_array = [1.5 2.5 1.5 2];
      
% Plot individual oscillations:
    figure(2);clf
      hold on
      ySum = zeros(1,numel(t));
      for i=1:numel(f_array)
         y=A_array(i).*sin(f_array(i)*pi*2*t);
         ySum = ySum+y;
         plot(t,y) 
      end
     
      box on
      print( '-dpng', '-r600', ['myPlotForLoop3.png']);

% Add some noise to the summed oscillations:
    noise          = 3.0*randn(1, numel(ySum));
    ySum_withNoise = ySum+noise;
      
% Plot the sum of oscillations:
    figure(3);clf
       hold on
       plot(t,ySum_withNoise,'-c') 
       plot(t,ySum,'-k') 
       
       box on
       
       print( '-dpng', '-r600', ['myPlotForLoop2 ySum.png']);
      
fprintf(1,'done.\n')
%% SPECTRAL ANALYSIS WITH NOISE
fprintf(1,'spectral analysis with noise...\n')

% Calculate some parameters for the Fast Fourier Transformation (FFT):
  Fs =numel(t)/t(end); % Sampling frequency, i.e., how many sample did we take within 1 s? 
  T = 1/Fs;            % Sampling period       
  L = numel(t);        % Length of signal, here: 501
  f = Fs*(0:(L/2))/L;  % Calculate the frequency domain

% Do the FFT:
  Y = fft(ySum_withNoise);      % FFT
  %Y = fft(ySum);                % FFT
  P2 = abs(Y/L);                % Two-sided amplitude spectrum
  P1 = P2(1:floor(L/2)+1);
  P1(2:end-1) = 2*P1(2:end-1);  % Single-sided amplitude spectrum
  
% Plot the signal and the spectrum into a figure with two subplots:
  figure(3);clf
      subplot(2,1,1)
        hold on
        plot(t,ySum_withNoise,'-c') 
        plot(t,ySum,'-k') 
        title('sum of oscillations')
        xlabel('t [s]')
        ylabel('y_{sum}(t)')
        
        box on
        le = legend('noisy data', 'no noise', 'Location', 'NE');
        set(le, 'box', 'off')
        
        title('Noisy data')
        
        
      subplot(2,1,2)
        hold on
        plot(f,P1, '-k', 'LineWidth',1.5)

        title('Single-Sided Amplitude Spectrum P1 of y_{sum}(t)')
        xlabel('f (Hz)')
        ylabel('|P1(f)|')
        
        le = legend('noisy data', 'Location', 'NE');
        
        print( '-dpng', '-r600', ['myPlotForLoop4.png']);
  

fprintf(1,'done.\n')
%% SPECTRAL ANALYSIS WITH NOISE AND TREND
fprintf(1,'spectral analysis with noise and trend...\n')

% Add a linear trend to the summed oscillations:
%     m=0;
    m=1.5;
    b=5;
    yTrend = m*t+b;
    ySum_withNoise = ySum_withNoise+yTrend;



% Do the FFT:
  Y = fft(ySum_withNoise);      % FFT
  %Y = fft(ySum);                % FFT
  P2 = abs(Y/L);                % Two-sided amplitude spectrum
  P1 = P2(1:floor(L/2)+1);
  P1(2:end-1) = 2*P1(2:end-1);  % Single-sided amplitude spectrum
  
% Plot the signal and the spectrum into a figure with two subplots:
  figure(3);clf
      subplot(2,1,1)
        hold on
        plot(t,ySum_withNoise,'-c') 
        plot(t,ySum,'-k') 
        title('sum of oscillations')
        xlabel('t [s]')
        ylabel('y_{sum}(t)')
        
        box on
        le = legend('noisy data', 'pure signal', 'Location', 'NE');
        set(le, 'box', 'off')
        
        title('Noisy data with linear trend')
        
        
      subplot(2,1,2)
        hold on
        plot(f,P1, '-k', 'LineWidth',1.5)

        title('Single-Sided Amplitude Spectrum P1 of y_{sum}(t)')
        xlabel('f (Hz)')
        ylabel('|P1(f)|')
        
        le = legend('noisy data', 'Location', 'NE');
        
        print( '-dpng', '-r600', ['myPlotForLoop4.png']);
  

fprintf(1,'done.\n')
%% SPECTRAL ANALYSIS WITH NOISE AND TREND AND DETRENDING
fprintf(1,'spectral analysis with noise and trend and detrending...\n')

% Detrend your data:
%     ySum_withNoise = detrend(ySum_withNoise);
    %ySum_withNoise = ySum_withNoise-mean(ySum_withNoise);
    yFit = fit(t',ySum_withNoise','poly1');
    ySum_withNoiseDetrended = ySum_withNoise-feval(yFit, t)';


% Do the FFT:
  Y = fft(ySum_withNoiseDetrended);      % FFT
  %Y = fft(ySum);                % FFT
  P2 = abs(Y/L);                % Two-sided amplitude spectrum
  P1 = P2(1:floor(L/2)+1);
  P1(2:end-1) = 2*P1(2:end-1);  % Single-sided amplitude spectrum
  
% Plot the signal and the spectrum into a figure with two subplots:
  figure(3);clf
      subplot(2,1,1)
        hold on
        plot(t,ySum_withNoise,'-c') 
        plot(t,ySum_withNoiseDetrended,'-g') 
        plot(t,ySum,'-k') 
        title('sum of oscillations')
        xlabel('t [s]')
        ylabel('y_{sum}(t)')
        
        box on
        le = legend('noisy data with trend ', 'detrended data','pure signal', 'Location', 'NE');
        set(le, 'box', 'off')
        
        title('Detrended noisy data with a linear trend')
        
        
      subplot(2,1,2)
        hold on
        plot(f,P1, '-k', 'LineWidth',1.5)

        title('Single-Sided Amplitude Spectrum P1 of y_{sum}(t)')
        xlabel('f (Hz)')
        ylabel('|P1(f)|')
        
        le = legend('noisy data', 'Location', 'NE');
        
        print( '-dpng', '-r600', ['myPlotForLoop4.png']);
  

fprintf(1,'done.\n')
%% SPECTRAL ANALYSIS WITH NOISE AND TREND AND DETRENDING AND DENOISING
fprintf(1,'spectral analysis with noise, trend, detrending and denoising...\n')

% Denoising:
% % Median-Filter via smoothdata + movmedian:
%   ySum_Cleaned = smoothdata(ySum_withNoiseDetrended,'movmedian',5);
% % Moving average filter:
%   mAvrgWindowSize = 5;
%   MovingAvrgCoeff = ones(1, mAvrgWindowSize)/mAvrgWindowSize;
%   ySum_Cleaned = filtfilt(MovingAvrgCoeff, 1, ySum_withNoiseDetrended );

% Butterworth Filter: 
  ButterworthCutoffFreq = [1 6]; 
%   ButterworthCutoffFreq = [13];
  ButterworthOrder      = 5;     
  fNorm = ButterworthCutoffFreq / (Fs/2);   
%   [B,A] = butter(ButterworthOrder, fNorm, 'low'); 
  [B,A] = butter(ButterworthOrder, fNorm, 'bandpass'); 
  ySum_Cleaned = filtfilt(B, A, ySum_withNoiseDetrended );

% % Low-Pass Filter:
%   LowPassCutoffFreq = 10;
%   ySum_Cleaned = lowpass(ySum_withNoiseDetrended, LowPassCutoffFreq, Fs); 


% Do the FFT:
  Y = fft(ySum_Cleaned);      % FFT
  %Y = fft(ySum);                % FFT
  P2 = abs(Y/L);                % Two-sided amplitude spectrum
  P1 = P2(1:floor(L/2)+1);
  P1(2:end-1) = 2*P1(2:end-1);  % Single-sided amplitude spectrum
  
  Y2 = fft(ySum_withNoiseDetrended); % FFT
  P22 = abs(Y2/L);                   % Two-sided amplitude spectrum
  P12 = P22(1:floor(L/2)+1);
  P12(2:end-1) = 2*P12(2:end-1);     % Single-sided amplitude spectrum
  
% Plot the signal and the spectrum into a figure with two subplots:
  figure(3);clf
      subplot(2,1,1)
        hold on
        plot(t,ySum_withNoiseDetrended, '-c', 'LineWidth',1.0)
        plot(t,ySum, '-k', 'LineWidth',1.5)
        plot(t,ySum_Cleaned, '-m', 'LineWidth',1.5)
        title('sum of oscillations')
        xlabel('t [s]')
        ylabel('y_{sum}(t)')
        
        box on
        le = legend('detrended noisy data', 'pure signal', 'detrended+denoised data','Location', 'NE');
        set(le, 'box', 'off')
        
        title('Detrended noisy data with a linear trend')
        
        
      subplot(2,1,2)
        hold on
        plot(f,P12, '-k', 'LineWidth',1.5)
        plot(f,P1, '-g', 'LineWidth',1.5)

        title('Single-Sided Amplitude Spectrum P1 of y_{sum}(t)')
        xlabel('f (Hz)')
        ylabel('|P1(f)|')
        
        le = legend('noisy data','denoised data', 'Location', 'NE');
        
        print( '-dpng', '-r600', ['myPlotForLoop4.png']);
  

fprintf(1,'done.\n')
%% END
fprintf(1,'done. END\n')