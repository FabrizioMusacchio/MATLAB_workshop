%% Program: myFirstScript
%  version/date : version 01, 191020
%  author(s)    : Fabrizio Musacchio, DZNE Bonn, Germany
%% DESCRIPTION
% This is my very first and super-cool MATLAB script :-D

%% MAIN ROUTINE 
fprintf(1,'I start...\n')


% Parameters:
    dt=0.01;        % step-size
    t=0:dt:5;       % time-vector in [s]
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
      print( '-dpng', '-r600', ['myPlotForLoop2.png']);

% Plot the sum of oscillations:
    figure(3);clf
       hold on
       plot(t,ySum) 
       
      print( '-dpng', '-r600', ['myPlotForLoop2 ySum.png']);
        
fprintf(1,'I am done\n')
%% END
fprintf(1,'I am done\n')