%% STARTING
% First, we clear the workspace:
  clear
%% VERY FIRST STEP
fprintf(1, 'Hello world.\n')
%% Cell #1: CALCULATION 
% Main calculations:
  dt=0.01;      % time step in [s]
  t=0:dt:1;     % time vector in [s]
  % frequencies (Hz):
    f =50;
    f2=4;
  % Amplitudes:
    A1=3;
    A2=1;
  y =A1*sin(2*pi*f*t);
  y2=A2*sin(2*pi*f2*t);
  
% Sum of oscillations:
  ySum = y+y2;

% Add some noise:
  noise = 4*randn(1, numel(t));
  ySumNoisy = ySum + noise;
  
% Add a trend:
  m = 10;
  b = 5; 
  trend = m*t + b;
  ySumNoisyTrend = ySum + noise + trend;
  
% Remove the trend:
  yFit = fit(t', ySumNoisyTrend', 'poly1' );
  yFitEval = feval(yFit, t);
  
  ySumNoisyNoTrend = ySumNoisyTrend - yFitEval';
  
  
%% Cell #2: PLOTS
% Plots:
a='Hello';

figure(1);clf
    plot(t,y,'-k')
    hold on
    plot(t,y2,'--g')
    
figure(2);clf
    plot(t,ySumNoisy,'-k')
    hold on
    plot(t,ySumNoisyTrend,'-g')
    plot(t,ySumNoisyNoTrend,'--r')
    plot(t,ySum,'-c')
    
%% ENDINGS