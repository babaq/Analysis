function varargout = MainRawData(varargin)
% MAINRAWDATA M-file for MainRawData.fig
%      MAINRAWDATA, by itself, creates a new MAINRAWDATA or raises the existing
%      singleton*.
%
%      H = MAINRAWDATA returns the handle to a new MAINRAWDATA or the handle to
%      the existing singleton*.
%
%      MAINRAWDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINRAWDATA.M with the given input arguments.
%
%      MAINRAWDATA('Property','Value',...) creates a new MAINRAWDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainRawData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainRawData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainRawData

% Last Modified by GUIDE v2.5 05-May-2009 11:46:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainRawData_OpeningFcn, ...
                   'gui_OutputFcn',  @MainRawData_OutputFcn, ...
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


% --- Executes just before MainRawData is made visible.
function MainRawData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainRawData (see VARARGIN)

% Choose default command line output for MainRawData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



%%% Init MainRawData GUI
RData = 0;
setappdata(handles.Main_RawData,'RData',RData);
% Positioning Main Window
scnsize = get(0,'ScreenSize');
set(hObject,'Position',[1,scnsize(4),200,250]);
% Init Channal and Stimuli
global RawData;

if isfield(RawData,'Snip')
    ch_n = RawData.Snip.chn;
else
    ch_n = RawData.Wave.chn;
end
ccn = cell(1,ch_n);
for i=1:ch_n
    ccn{i}=num2str(i);
end
set(handles.ch_n,'String',ccn);

sti_n = RawData.Mark.stimuli;
cst = cell(1,sti_n);
for i=1:sti_n
    cst{i}=num2str(i);
end
set(handles.sti_n,'String',cst);

set(handles.exname,'String',RawData.Mark.extype);

clear RawData;

% UIWAIT makes MainRawData wait for user response (see UIRESUME)
% uiwait(handles.Main_RawData);


% --- Outputs from this function are returned to the command line.
function varargout = MainRawData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close Main_RawData.
function Main_RawData_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Main_RawData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

global RawData;

rawdata = getappdata(handles.Main_RawData,'RData');
selection = questdlg('Do you want to save Raw Data ?',...
                     'Save Raw Data ...',...
                     'Yes','No','No');
if strcmp(selection,'Yes')
    if isstruct(rawdata)
        filename=[RawData.Dinf.tank,'__',RawData.Dinf.block,'__',RawData.Mark.extype,'_RawData'];
        filename=fullfile(RawData.OutputDir,filename);
        save(filename,'rawdata');
    else
        disp('No Complete Data To Save !');
        warndlg('No Complete Data To Save !','Warnning');
    end
end


% Clear Global Data
clear global RawData;

delete(hObject);





% --- Executes on button press in b_show.
function b_show_Callback(hObject, eventdata, handles)
% hObject    handle to b_show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global RawData;

rawdata = getappdata(handles.Main_RawData,'RData');

contents = get(handles.extent_n,'String');
extent = contents{get(handles.extent_n,'Value')};

if ~isstruct(rawdata) % Calculate PreProcessed RawData
    rawdata = PreProcess(RawData,str2double(extent),0,0);
    setappdata(handles.Main_RawData,'RData',rawdata);
end


% Show Result
contents = get(handles.ch_n,'String');
ch = contents{get(handles.ch_n,'Value')};

contents = get(handles.sti_n,'String');
sti = contents{get(handles.sti_n,'Value')};

RawData_Draw(rawdata,extent,ch,sti);

clear RawData;





% --- Executes on selection change in ch_n.
function ch_n_Callback(hObject, eventdata, handles)
% hObject    handle to ch_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch_n contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch_n


% --- Executes during object creation, after setting all properties.
function ch_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in sti_n.
function sti_n_Callback(hObject, eventdata, handles)
% hObject    handle to sti_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns sti_n contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sti_n


% --- Executes during object creation, after setting all properties.
function sti_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sti_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in extent_n.
function extent_n_Callback(hObject, eventdata, handles)
% hObject    handle to extent_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Reset RawData
RData = 0;
setappdata(handles.Main_RawData,'RData',RData);

% Hints: contents = get(hObject,'String') returns extent_n contents as cell array
%        contents{get(hObject,'Value')} returns selected item from extent_n


% --- Executes during object creation, after setting all properties.
function extent_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to extent_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
