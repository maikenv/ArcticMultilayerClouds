function linecolor = colordg(n);
%COLORDG - Provides a choice of 15 colors for a line plot
%The first seven colors are the same as Matlab's predefined
%values for the PLOT command, i.e.
%
% 'b','g','r','c','m','y','k'
%
%Syntax: linecolor = colordg(n);
%
%Input: N , integer between 1 and 15, giving the following colors
%
% 1 BLUE
% 2 GREEN (pale)
% 3 RED
% 4 CYAN
% 5 MAGENTA (pale)
% 6 YELLOW (pale)
% 7 BLACK
% 8 TURQUOISE
% 9 GREEN (dark)
% 10 YELLOW (dark)
% 11 ORANGE
% 12 MAGENTA (dark)
% 13 GREY
% 14 BROWN (pale)
% 15 BROWN (dark)
%
%Output: LINECOLOR (1 x 3 RGB vector)
%
%Examples:
% 1) h = line(x,y,'Color',colordg(11)); %Picks the orange color
% 2) colordg demo %Creates a figure displaying the 15 colors
% 3) axes; set(gca,'ColorOrder',(colordg(1:15)));
% Overrides the default ColorOrder for the current axes only
% 4) figure; set(gcf,'DefaultAxesColorOrder',(colordg(1:15)));
% Overrides the default ColorOrder for all axes of the current
% figure
% 5) set(0,'DefaultAxesColorOrder',(colordg(1:15)));
% Sets the default ColorOrder for all axes to be created during
% the current matlab session. You may wish to insert this
% command into your startup.m file.
%
%See also: PLOT, LINE, AXES

%Author: Denis Gilbert, Ph.D., physical oceanography
%Maurice Lamontagne Institute, Dept. of Fisheries and Oceans Canada
%Web: http://www.qc.dfo-mpo.gc.ca/iml/
%August 2000; Last revision: 26-Sep-2003
%edited by Stefanie Semper in October 2013 (adding more colors)

if nargin == 0
   error('Must provide an input argument to COLORDG')
end

colorOrder = ...
[ 0 0 1 % 1 BLUE
   0 1 0 % 2 GREEN (pale)
   1 0 0 % 3 RED
   0 1 1 % 4 CYAN
   1 0 1 % 5 MAGENTA (pale)
   1 1 0 % 6 YELLOW (pale)
   0 0 0 % 7 BLACK
   0 0.75 0.75 % 8 TURQUOISE
   0 0.5 0 % 9 GREEN (dark)
   0.75 0.75 0 % 10 YELLOW (dark)
   1 0.50 0.25 % 11 ORANGE
   0.75 0 0.75 % 12 MAGENTA (dark)
   0.7 0.7 0.7 % 13 GREY
   0.8 0.7 0.6 % 14 BROWN (pale)
   0.6 0.5 0.4 % 15 BROWN (dark)
   0.5 0.5 0.0 % 16 OLIVE GREEN
   0.0 0.5 0.5 % 17 PETROL BLUE
   0.5 0.0 0.5 % 18 PURPLE (dark)
   0.82 0.41 0.12 % 19 CHOCOLATE
   0.5 1.0 0.0 % 20 CHARTREUSE (neon green)	
   0.39 0.58 0.93 % 21 CORNFLOWER (light blue)
   0.94 0.97 1 % 22 ALICE BLUE
   1    0.92 0.8 % 23 BLANCHED ALMOND (rosa)   
   0.54 0.17 0.89 % 24 BLUE VIOLET
   1    0.55 0 % 25 DARK ORANGE
   0.55 0    0 % 26 DARK RED
   0.56 0.74 0.56 % 27 DARK SEA GREEN  
   0.68 1    0.18 % 28 GREEN YELLOW
   1    0.84 0    % 29 GOLD
   0.1  0.1  0.44 % 30 MIDNIGHT BLUE
	];


if isnumeric(n) & n >= 1 & n <= 30
    linecolor = colorOrder(n,:);
elseif strcmp(n,'demo')
    %GENERATE PLOT to display a sample of the line colors
    figure, axes;
    %PLOT N horizontal lines
    for n=1:length(colorOrder)
        h(n) = line([0 1],[n n],'Color',colorOrder(n,:));
    end
    set(h,'LineWidth',5)
    set(gca,'YLim',[0 n+1],'YTick',[1:n],'XTick',[])
    ylabel('Color Number');
else
    error('Invalid input to colordg');
end

%------------- END OF CODE -------------- 
