function [ output_args ] = edit_scale( d_Object,d_cap_Object,H_Object,dvalue,d_cap_value,Hvalue,quiver_Object,normalize_Object,axis_Object,figure_Object,button_Object )
%% Edit Scale %%
% Eastern Nazarene College Earthquake Forcasting
%   This is a function to take user input for the scale of the graph and if
%   it is valid, pass it back to the main GUI to update the graph. It first
%   sets up a prompt to take the user inputs. Then it filters and cleans
%   the input. Then, if valid, it passes it to Update_graph
% This script and all of its components were written by Caleb Vatral

%% Variable Initializations
global y_min y_max z_min z_max tick_scale num_contour; %initialize the global variables
y_min_new = y_min; %set our working variables (used for default value in the prompt)
y_max_new = y_max; %to the global variables to start
z_min_new = z_min;
z_max_new = z_max;
tick_new = tick_scale;
contour_new = num_contour;
success = false; %While loop variable. We set to true if the user input is valid
status = zeros(1,6); %Matrix to handle bad input errors later on

%% Prompt Generation and Error Handling
try %we put it in a try to handle any weird matlab errors
%%% While Loop %%%
% We run this loop once to start and then while there are errors in the
% user input or until cancel is clicked.
% It first generates the prompt for user input.
% Next it checks to see that the user inputed a valid int for all prompts.
% Then it checks to see if the dimensions make physical sense.
% If all of the above are met, then we break the loop and pass the data
% back to the main GUI
%%%%%%%%%%%%%%%%%%
while success==false
    %% Prompt Generation
    prompt = {'Enter y minimum:','Enter y maximum:','Enter z minimum:','Enter z maximum:', 'Enter tick mark scale:', 'Enter number of contours:'};
                %Prompts for the user in the popup
    dlg_title = 'Edit Graph Scale'; %Title of the popup
    num_lines = 1; %We only take one line of input from the user
    defaultans = {num2str(y_min_new), num2str(y_max_new), num2str(z_min_new), num2str(z_max_new), num2str(tick_new), num2str(contour_new)};
                %Default values in the fields are either:
                %1. What is already on the axis (used during prompt generation
                %2. What the user previously entered (used when there is an error
    answer = inputdlg(prompt,dlg_title,[1, length(dlg_title)+40],defaultans); %generate the prompt using the above
    
    %% Error Handling for Empty and Incorrect Input
    input_error = false; %variable for stopping program if there is an input error
    if isempty(answer)==1 %check if cancel was clicked
        return; %If so, return to the main GUI with no change to the variables
    end
    %%% For Loop %%%
    % We run the loop over each of the user input questions
    % First we check if every question was answered
    % If not, then we throw an error and continue to the next while loop
    % iteration
    % Next we store all the inputs to our working variables
    % If the input is the wrong data type, then we throw an error and
    % continue to the next while loop iteration
    %%%%%%%%%%%%%%%%
    for i=1:6
        if isempty(answer{i})==1 %Check if the input is empty
            h=errordlg('You must answer all questions','Error'); %Throws an error popup
            uiwait(h); %Waits for user to acknowledge error before continuing
            input_error = true; %Causes the while to continue past data analysis and run again
                                %allows the user to fix the errors in the input
            break; %if there is an error, we don't need to check the rest of the values
        else %if its not empty, try to store the value to our working variable
            %%% Switch %%%
            % We switch using the for loop variable. If we get to here, the
            % input is not empty, so we attempt to store it to our working
            % variable. We cast the string input to a double, then the
            % double to an int. Non-numeric input results in an error popup
            % and valid input gets converted stored.
            %%%%%%%%%%%%%%
            switch i
                case 1 %Each case corresponds to a question in the prompt
                    y_min_new = cell2mat(answer(1)); %converts the cell to a string
                    [y_min_new, status(i)] = str2num(y_min_new); %converts the string to an double, 
                                                                 %status(i) stores 1 for success or 0 
                                                                 %for failure we use it
                                                                 %later to check for
                                                                 %inputs of non-numbers
                    y_min_new = int64(y_min_new); %converts double to int
                case 2 %Subsequent cases are the same as above for each remaining question
                    y_max_new = cell2mat(answer(2));
                    [y_max_new, status(i)] = str2num(y_max_new);
                    y_max_new = int64(y_max_new);
                case 3
                    z_min_new = cell2mat(answer(3));
                    [z_min_new, status(i)] = str2num(z_min_new);
                    z_min_new = int64(z_min_new);
                case 4
                    z_max_new = cell2mat(answer(4));
                    [z_max_new, status(i)] = str2num(z_max_new);
                    z_max_new = int64(z_max_new);
                case 5
                    tick_new = cell2mat(answer(5));
                    [tick_new, status(i)] = str2num(tick_new);
                    tick_new = int64(abs(tick_new));
                case 6
                    contour_new = cell2mat(answer(6));
                    [contour_new, status(i)] = str2num(contour_new);
                    contour_new = int64(abs(contour_new));
            end
           
        end
    end
    %%% For Loop %%%
    % Loops through the status vector to check if any of the user
    % inputs were non-numbers. If so, we throw an error and
    % continue to the next iteration of the while loop
    %%%%%%%%%%%%%%%%
    if input_error==false
        for j=1:6 
            if status(j)==0 %0 means that the input was not successfully converted
                            %This means the input was not a number
                h = errordlg('All inputs must be integers','Error'); %Error Popup
                uiwait(h); %Wait for user acknowledgment of error before continuing
                input_error = true;
            end
        end
    end
    %% Dimension Error Handling
    if input_error==false % if we make it past any errors with data types in the input
                          % then we run this to check if the inputs make
                          % physical sense.
        if ((y_min_new(1) >= y_max_new(1)) || (z_min_new(1)>=z_max_new(1))) 
                          %check if min is greater than max
            h=errordlg('Max value must be greater than min value','Error'); %error popup
            uiwait(h); %wait for user to acknowledge error before continuing
        else %runs only if there are no errors
            success = true; %this will break the while
        end
    end
end
% we should only reach this if there are no errors
% set the global variables to successful user inputs
% We have to convert back to a double for use in PotentialFunction
y_min = double(y_min_new);
y_max = double(y_max_new);
z_min = double(z_min_new);
z_max = double(z_max_new);
tick_scale = double(tick_new);
num_contour = double(contour_new);
% passes the new values to Update graph
Update_Graph(d_Object,d_cap_Object,H_Object,dvalue,d_cap_value,Hvalue,quiver_Object,normalize_Object,axis_Object,figure_Object,button_Object);
            
catch %Should never reach this
      %If we do, there was a matlab proccessing error
      %Would only result from an input that we have not checked against
    h = errordlg('There was an error','Error');
    uiwait(h);
end

end
