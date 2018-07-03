function [ output_args ] = p_bar_cancel()
%% p_bar_cancel %%
% Eastern Nazarene College Earthquake Forcasting
%   This function is the callback for the cancel button in the progress bar
%   popup when Update_Graph is being run. It sets the global stop_flag to true. 
% This script and all of its components were written by Caleb Vatral

global stop_flag; %initialize the global variable
stop_flag = true; %set the flag to true

end

