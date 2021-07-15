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
fprintf(1,'I start...\n')

% Main program:
    dt=0.01;                 % step-size
    t=0:dt:1;                % time-vector in [s]
    f=1;                     % frequency in [Hz] = [1/s]
    y  =1.0*sin(1*f*pi*2*t); % my oscillation function
    y2 =1.0*sin(2*f*pi*2*t); % my oscillation function
    y3 =2.0*sin(4*f*pi*2*t); % my oscillation function
    y4 =2.5*sin(6*f*pi*2*t); % my oscillation function

% Plots:
    figure(1);clf
        plot(t,y)
        hold on
        plot(t,y2)
        plot(t,y3)
        plot(t,y4)
        title('oscillation(s) from 0 to 1 s')
        xlabel('t [s]')
        ylabel('y(t) = sin(2\pift)')
        
        legend('f=1 Hz, A=1', 'f=2 Hz, A=1', 'f=4 Hz, A=2', 'f=6 Hz, A=0.5', 'Location', 'NE')
        
        print( '-dpng', '-r600', ['myPlot.png']);
        
%% SUM OF OSCILLATIONS

% Main program:
    ySum1= y+y2;
    ySum2= y+y2+y3;
    ySum2= y+y2+y3;
    ySum4= y+y4;

% Plots:
    figure(2);clf
        plot(t,ySum1)
        hold on
        plot(t,ySum2)
        plot(t,ySum3)
        plot(t,ySum4)
        title('sum of oscillation from 0 to 1 s')
        xlabel('t [s]')
        ylabel('y_{sum}(t) ')
        
        legend('sum of f=1 Hz and f=2 Hz', 'sum of f=1 Hz, f=2 Hz and f=4 Hz', 'sum of f=1 Hz, f=2 Hz, f=4 Hz and f=6 Hz','Location', 'NE')
        
                
%% END
fprintf(1,'I am done\n')