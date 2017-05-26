function [ output_args ] = Update_Graph( d_Object,d_cap_Object,H_Object,dvalue,d_cap_value,Hvalue,quiver_Object,normalize_Object,axis_Object,figure_Object,button_Object )
%% Update Graph %%
%Eastern Nazarene College Earthquake Forcasting
%   This function takes the values from the main GUI and updates the plot
%   based on the new values. It first takes the values from the GUI
%   elements and stores them. Then it calculates the piezomagnetic
%   potential and plots it. Then it calculates the associated vector field
%   and plots it.
%This script and all of its components were written by Caleb Vatral

%% Constant Definitions
global stop_flag;
stop_flag = false;
global d_last d_cap_last h_last %global variables to store last value for use in error handling
global y_min y_max z_min z_max tick_scale num_contour % global variables to define the plot size
%   We get constant values from the siders
try %we run everything in a try to catch unspecified errors
d = get(d_Object,'Value');
D = get(d_cap_Object,'Value');
H = get(H_Object,'Value');
q = get(quiver_Object,'Value');
q_n = get(normalize_Object,'Value');

if d>=D %handles dimension errors. d>D is not physically sensible
    dimension_warning = errordlg('Value of "d" cannot be greater than value of "D". Dimensions will be reset to the last successful values','Dimension Error');
                % generates an error dialog
    uiwait(dimension_warning); %wait until user acknowledges the error
    set(d_Object, 'Value', d_last); %reset sliders to last successful value
    set(d_cap_Object, 'Value', d_cap_last);
    set(H_Object, 'Value', h_last);
    return;
end

%we set the value of the text GUI elements to reflect the slider values
set(dvalue,'String',d);
set(d_cap_value,'String',D);
set(Hvalue,'String',H);

%there were no errors, so we set these slider values as the last success
d_last = d;
d_cap_last = D;
h_last = H;
%% Populate The Potential Vector
scale_size_y = y_max - y_min; % define how big the graph's x axis is
scale_size_z = z_max - z_min; % define how big the graph's y axis is
W = zeros(scale_size_z, scale_size_y); %initialize matrix of Z values for graph
p_bar = waitbar(0,'Calculating...','CreateCancelBtn','p_bar_cancel()'); %popup with progressbar
steps = scale_size_y*scale_size_z; %calculate number of calculations to run
i=0; %initialize counter for progress bar
% this block disables each GUI component while calculations are running
set(d_Object,'Enabled',0);
set(d_cap_Object,'Enabled',0);
set(H_Object,'Enabled',0);
set(quiver_Object,'Enable','off');
set(normalize_Object,'Enable','off');
set(button_Object,'Enable','off');
%%% For Loop %%%
% We loop through each of the y and z values that the user defined and
% generate the piezomagnetic potential at that point.
%%%%%%%%%%%%%%%%
for y=y_min:y_max %loop through and evaluate the function on these intervals
   for z=z_min:z_max
       W(z-z_min+1,y-y_min+1) = PotentialFunction(y,z, d, D, H); 
            % W(z,y) makes sure y is on the x-axis and z is on the y-axis
            % We subtract the z and y min to normalize the start value to 0,
            % then add 1 because matlab indicies start at 1
       i=i+1; %increment counter
       waitbar(i/steps,p_bar); %update progressbar
       if stop_flag==true %check iif cancel button was pressed
           break; %if it was, break the loop
       end
   end
end
if stop_flag==true %check iif cancel button was pressed
    delete(p_bar); %delete the progressbar
    h=warndlg('Calculation Stopped','Alert'); %altert the user that canel worked
    uiwait(h);
    %re-enable the gui objects
    set(d_Object,'Enabled',1);
    set(d_cap_Object,'Enabled',1);
    set(H_Object,'Enabled',1);
    set(quiver_Object,'Enable','on');
    set(button_Object,'Enable','on');
    if (q ==  1)
        set(normalize_Object,'Enable','on');
    end
    return; %if it was return without updating
end
waitbar(i/steps,p_bar,'Finishing Up...') % the calculation finished, so we tell the user
                                         % that we are finishing while we
                                         % draw the graphs
%% Generate Contour Plot
y=y_min:y_max; %define axis scale
z=z_min:z_max; %define axis scale
contour(axis_Object,y,z,W,num_contour) % plot the contour
set(axis_Object,'XTick',y_min:tick_scale:y_max,'XTickLabel',y_min:tick_scale:y_max) %sets axis tick marks
set(axis_Object,'YTick',z_min:tick_scale:z_max,'YTickLabel',z_min:tick_scale:z_max) %sets axis tick marks
title(axis_Object,'Piezomagnetic Potential for Infinitely Long Uniform Strike Slip Fault') %plot title
xlabel(axis_Object,'Distance From Epicenter in the Y Direction (km)') %x axis label
ylabel(axis_Object,'Distance From Epicenter in the Z Direction (km)') %y axis label
co = colorbar(axis_Object,'FontSize',11); %display the colorbar and change the font
co.Label.String = 'Magnetic Potential (T*km)'; %Label the colorbar
hold(axis_Object,'on') %Hold the current axis for generation of the quiver plot

%% Gradient and Quiver Plot
if (q ==  1) %if quiver checkbox is ticked in GUI
    [DY,DZ] = gradient(W); %generate the associated magnetic field, B = -grad(W)
                           %the necessary negative sign handled in the normalization
    if q_n == 1 %if normalize checkbox is ticked in GUI
        norm_dy = -1*DY./sqrt(DY.^2+DZ.^2); %normalizes the length of each arrow so that they are all the same length, but
        norm_dz = -1*DZ./sqrt(DY.^2+DZ.^2); %still point in the correct direction
    else % if it is unchecked, we do nothing to the vectors
        norm_dy = DY;
        norm_dz = DZ;
    end
    arrow_factor = 5; %limits the number of arrows that are shown. Higher numbers mean less arrows
    arrow_scale = .35; %multiplier of arrow length
    quiver(axis_Object,y(1:arrow_factor:end,1:arrow_factor:end),z(1:arrow_factor:end,1:arrow_factor:end),norm_dy(1:arrow_factor:end,1:arrow_factor:end),norm_dz(1:arrow_factor:end,1:arrow_factor:end),'AutoScaleFactor',arrow_scale)
                % generate the field lines based on the above data
end
hold(axis_Object,'off') % stops plotting on current axis
drawnow; % displays the changes that we plotted
%re-enable the gui objects
set(d_Object,'Enabled',1);
set(d_cap_Object,'Enabled',1);
set(H_Object,'Enabled',1);
set(quiver_Object,'Enable','on');
set(button_Object,'Enable','on');
if (q ==  1)
    set(normalize_Object,'Enable','on');
end
delete(p_bar); %after everything is done, delete the progressbar
catch %Should never reach this
      %If we do, there was a matlab proccessing error
    delete(p_bar);
    h = errordlg('There was an error','Error');
    uiwait(h);
end
end

