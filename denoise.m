function fClean= denoise(x,y,CutoffFreq)
%% DESCRIPTIOn
%  My main denoising-function based on the Butterworth filter.
%
%   INPUT:      x           x-values 
%               y           data points
%               CutoffFreq  cutoff-frequency
% 
%   INPUT:      fClean      filtered/denoised data array
%% MAIN ALGORITHM

% Calculate samplerate:
  Fs =numel(x)/x(end); % Sampling frequency, i.e., how many sample did we take within 1 s? 
  T = 1/Fs;            % Sampling period       

% Create the filter:
  ButterworthCutoffFreq = CutoffFreq;  
  ButterworthOrder      = 5;     
  fNorm = ButterworthCutoffFreq / (Fs/2);   
  [B,A] = butter(ButterworthOrder, fNorm, 'low'); 
  
% Apply the filter:
  fClean = filtfilt(B, A, y);

end