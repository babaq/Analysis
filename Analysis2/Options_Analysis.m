function varargout = Options_Analysis(varargin)
% OPTIONS_ANALYSIS M-file for Options_Analysis.fig
%      OPTIONS_ANALYSIS by itself, creates a new OPTIONS_ANALYSIS or raises the
%      existing singleton*.
%
%      H = OPTIONS_ANALYSIS returns the handle to a new OPTIONS_ANALYSIS or the handle to
%      the existing singleton*.
%
%      OPTIONS_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTIONS_ANALYSIS.M with the given input arguments.
%
%      OPTIONS_ANALYSIS('Property','Value',...) creates a new OPTIONS_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Options_Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Options_Analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Options_Analysis

% Last Modified by GUIDE v2.5 16-Mar-2011 16:30:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Options_Analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @Options_Analysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Options_Analysis is made visible.
function Options_Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Options_Analysis (see VARARGIN)


%%% Init Options from option file
hr = exist('Analysis\Options.mat','file');
if hr ~=0 
    Optionfile = load('Analysis\Options.mat');
    Options = Optionfile.Options;
    
    % display saved options
    set(handles.spikewave,'Value',Options.spikewave);
    set(handles.outputdir,'String',Options.outputdir);
    set(handles.ttankdir,'String',Options.ttankdir);
else
    Options =0;
end


% Choose default command line output for Options_Analysis
handles.output = Options;

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title'
          set(hObject, 'Name', varargin{index+1});
         case 'string'
          set(handles.title, 'String', varargin{index+1});
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes Options_Analysis wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Options_Analysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.figure1);




% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get all option values and save into option file
Options = getoptions(handles);
path = fileparts(which('Analysis.m'));
save(fullfile(path,'Options.mat'),'Options');


% --- Get all option values.
function Options = getoptions(handles)
Options.spikewave = get(handles.spikewave,'Value');
Options.outputdir = get(handles.outputdir,'String');
Options.ttankdir = get(handles.ttankdir,'String');


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get all option values
handles.output = getoptions(handles);

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);




% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ok_Callback(hObject, eventdata, handles);


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
ckey = get(hObject,'CurrentKey');
if isequal(ckey,'escape') || isequal(ckey,'return')
    ok_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in spikewave.
function spikewave_Callback(hObject, eventdata, handles)
% hObject    handle to spikewave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of spikewave



function outputdir_Callback(hObject, eventdata, handles)
% hObject    handle to outputdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputdir as text
%        str2double(get(hObject,'String')) returns contents of outputdir as a double


% --- Executes during object creation, after setting all properties.
function outputdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in output.
function output_Callback(hObject, eventdata, handles)
% hObject    handle to output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

outputdir = uigetdir('E:\','Select Result Output Directory');
set(handles.outputdir,'String',outputdir);



function ttankdir_Callback(hObject, eventdata, handles)
% hObject    handle to ttankdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ttankdir as text
%        str2double(get(hObject,'String')) returns contents of ttankdir as a double


% --- Executes during object creation, after setting all properties.
function ttankdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttankdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ttank.
function ttank_Callback(hObject, eventdata, handles)
% hObject    handle to ttank (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ttankdir = uigetdir('E:\','Select TDT Tank Directory');
set(handles.ttankdir,'String',ttankdir);
