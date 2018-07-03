%% Run Simulation %%
% Eastern Nazarene College Earthquake Forcasting
%   This script graphs the magnetic potential generated at a point y,z
%   away from the fault line usign the Uniform Vertical Strike-Slip Fault
%   of Infinite Length as set forth by Sasai (1980)
% This script and all of its components were written by Caleb Vatral

%%  Initialize the UI
f = figure('Visible','off','Position',[0,0,1000,600], 'resize', 'off', 'MenuBar','none','Name','Piezomagnetic Potential Simulation','numbertitle','off');
%% Initialize Global Variables
global stop_flag; %flag to handle cancel button on progress bar
global d_last d_cap_last h_last %global variables to store last value for use in error handling
global y_min y_max z_min z_max tick_scale num_contour %global variables to store graph scale
stop_flag = false;
y_min = -50;
y_max = 50;
z_min = -30;
z_max = 70;
tick_scale = 10;
num_contour = 1000;
%% Initialize d Slider
dSlider = javax.swing.JSlider; % calling java slider because it looks and functions better than GUIDE
javacomponent(dSlider,[785,500,200,45]); % position the slider
set(dSlider, 'Value', 0, 'MajorTickSpacing',20, 'PaintLabels',true);  % with labels, no ticks
hdSlider = handle(dSlider, 'CallbackProperties'); % need a handle to work with GUI components
dtext = uicontrol('Style','text','String','"d" Value: ','Position',[785,550,60,15]); %label for slider
dvalue = uicontrol('Style','text','String','0','Position',[840,550,20,15]); %current slider value
d_last = 0; % set global variable to slider initial value
%% Initialize D Slider
d_cap_Slider = javax.swing.JSlider; % calling java slider because it looks and functions better
javacomponent(d_cap_Slider,[785,400,200,45]); % position the slider
set(d_cap_Slider, 'Value', 5, 'MajorTickSpacing',20, 'PaintLabels',true);  % with labels, no ticks
hd_cap_Slider = handle(d_cap_Slider, 'CallbackProperties'); % need a handle to work with GUI components
d_cap_text = uicontrol('Style','text','String','"D" Value: ','Position',[785,450,60,15]); %label for slider
d_cap_value = uicontrol('Style','text','String','5','Position',[840,450,20,15]); %current slider value
d_cap_last = 5; % set global variable to slider initial value
%% Initialize H Slider
HSlider = javax.swing.JSlider; % calling java slider because it looks and functions better
javacomponent(HSlider,[785,300,200,45]); % position the slider
set(HSlider, 'Value', 20, 'MajorTickSpacing',20, 'PaintLabels',true);  % with labels, no ticks
hHSlider = handle(HSlider, 'CallbackProperties'); % need a handle to work with GUI components
Htext = uicontrol('Style','text','String','"H" Value: ','Position',[785,350,60,15]); %label for slider
Hvalue = uicontrol('Style','text','String','20','Position',[840,350,20,15]); %current slider value
h_last = 20; % set global variable to slider initial value
%% Initialize Quiver Checkbox
quiver_box = uicontrol('Style','checkbox', 'String','Display Vector Field', 'Value',1,'Position',[[800,250,130,20]]);
        % checkbox to show quivers when checked and hide when unchecked
normalize_box = uicontrol('Style','checkbox', 'String','Normalize Vector Length', 'Value',1,'Position',[[800,220,150,20]]);
        % checkbox to normalize quivers when checked and not when unchecked
%% Initialize Scale Control
scale_edit = uicontrol('Style','pushbutton','String','Edit Graph Scale','Position',[800,170,100,40]);
        % create the button to edit the axis scale
%% Initialize the Plot
ha = axes('Units','Pixels','Position',[100,60,600,500]); % creates the axis to graph on
%% Callback Functions
% We must define all callback functions anonymously so that they are not
% called on ui creation
scale_edit.Callback = @(hjSlider,event) edit_scale(hdSlider,hd_cap_Slider,hHSlider,dvalue,d_cap_value,Hvalue,quiver_box,normalize_box,ha,f,scale_edit); % calls edit_scale when button is pressed
quiver_box.Callback = @(hjSlider,event) Update_Graph(hdSlider,hd_cap_Slider,hHSlider,dvalue,d_cap_value,Hvalue,quiver_box,normalize_box,ha,f,scale_edit); % call Update_Graph on change
normalize_box.Callback = @(hjSlider,event) Update_Graph(hdSlider,hd_cap_Slider,hHSlider,dvalue,d_cap_value,Hvalue,quiver_box,normalize_box,ha,f,scale_edit); % call Update_Graph on change
hdSlider.MouseReleasedCallback = @(hjSlider,event) Update_Graph(hdSlider,hd_cap_Slider,hHSlider,dvalue,d_cap_value,Hvalue,quiver_box,normalize_box,ha,f,scale_edit); % call Update_Graph on change
hd_cap_Slider.MouseReleasedCallback = @(hjSlider,event) Update_Graph(hdSlider,hd_cap_Slider,hHSlider,dvalue,d_cap_value,Hvalue,quiver_box,normalize_box,ha,f,scale_edit); % call Update_Graph on change
hHSlider.MouseReleasedCallback = @(hjSlider,event) Update_Graph(hdSlider,hd_cap_Slider,hHSlider,dvalue,d_cap_value,Hvalue,quiver_box,normalize_box,ha,f,scale_edit); % call Update_graph on change
%% Poplulate the Initial Plot
Update_Graph(hdSlider,hd_cap_Slider,hHSlider,dvalue,d_cap_value,Hvalue,quiver_box,normalize_box,ha,f,scale_edit); % call once to create the initial graph
f.Visible = 'on'; % set the axis to visible