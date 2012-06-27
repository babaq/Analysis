function varargout = MainTC(varargin)
% MAINTC M-file for MainTC.fig
%      MAINTC, by itself, creates a new MAINTC or raises the existing
%      singleton*.
%
%      H = MAINTC returns the handle to a new MAINTC or the handle to
%      the existing singleton*.
%
%      MAINTC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINTC.M with the given input arguments.
%
%      MAINTC('Property','Value',...) creates a new MAINTC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainTC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainTC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainTC

% Last Modified by GUIDE v2.5 30-Mar-2011 12:20:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainTC_OpeningFcn, ...
                   'gui_OutputFcn',  @MainTC_OutputFcn, ...
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


% --- Executes just before MainTC is made visible.
function MainTC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainTC (see VARARGIN)

% Choose default command line output for MainTC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



%%% Init MainTC GUI
TData = 0;
setappdata(handles.figure1,'TData',TData);
% Positioning Main Window
scnsize = get(0,'ScreenSize');
set(hObject,'Position',[1,scnsize(4),42,21]);
% Init Channal and Sortcode
global TCData;

ch_n = TCData.Snip.chn;
ccn = cell(1,ch_n+1);
ccn{1} = 'ALL';
for i=1:ch_n
    ccn{i+1}=num2str(i);
end
set(handles.ch_n,'String',ccn);
set(handles.sort_n,'String',{'MU'});
set(handles.exname,'String',TCData.Mark.extype);

clear TCData;

% UIWAIT makes MainTC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainTC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

global TCData;

TData = getappdata(handles.figure1,'TData');
selection = questdlg('Do you want to save Tuning Data ?',...
                     'Save Tuning Data ...',...
                     'Yes','No','No'); 
if strcmp(selection,'Yes')
    if iscell(TData)
        filename=[TCData.Dinf.tank,'__',TCData.Dinf.block,'__',TCData.Mark.extype,'_Tuning'];
        filename=fullfile(TCData.OutputDir,filename);
        save(filename,'TData');
    else
        disp('No Complete Data To Save !');
        warndlg('No Complete Data To Save !','Warnning');
    end
end

% Clear Global Data
clear global TCData;

delete(hObject);





% --- Executes on button press in show.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TCData;

tdata = getappdata(handles.figure1,'TData');

contents = get(handles.delay_n,'String');
delay = contents{get(handles.delay_n,'Value')};

if ~iscell(tdata) % Calculate TuningCurve Only Once Unless Delay Changed
    TCData = PreProcess(TCData,0,str2double(delay),1);
    tdata = STC(TCData);
    setappdata(handles.figure1,'TData',tdata);
end


% Show Result
ispolar = get(handles.polar,'Value');
isfit = get(handles.fit,'Value');

contents = get(handles.ch_n,'String');
ch = contents{get(handles.ch_n,'Value')};

contents = get(handles.sort_n,'String');
sort = contents{get(handles.sort_n,'Value')};

STC_Draw(tdata,TCData,ch,sort,delay,ispolar,isfit);

clear TCData;





% --- Executes on selection change in ch_n.
function ch_n_Callback(hObject, eventdata, handles)
% hObject    handle to ch_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Refresh Sort_n of Selected Channal
global TCData;

ch_n = get(hObject,'Value')-1;
if ch_n==0 % ALL Channal
    set(handles.sort_n,'String',{'MU'});
else 
    sort_n = TCData.Snip.sortn(ch_n);
    if sort_n==0 % no sort
        cso = {'NOSORT'};
    elseif sort_n==1 % multi-unit
        cso = {'MU'};
    else
        cso = cell(1,sort_n+1);
        cso{1}='MU';
        for i=1:sort_n
            cso{i+1}=['SU',num2str(i)];
        end
    end
    set(handles.sort_n,'String',cso);
end
set(handles.sort_n,'Value',1);

clear TCData;

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


% --- Executes on selection change in sort_n.
function sort_n_Callback(hObject, eventdata, handles)
% hObject    handle to sort_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns sort_n contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sort_n


% --- Executes during object creation, after setting all properties.
function sort_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sort_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in delay_n.
function delay_n_Callback(hObject, eventdata, handles)
% hObject    handle to delay_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Reset TuningData
TData = 0;
setappdata(handles.figure1,'TData',TData);

% Hints: contents = get(hObject,'String') returns delay_n contents as cell array
%        contents{get(hObject,'Value')} returns selected item from delay_n


% --- Executes during object creation, after setting all properties.
function delay_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delay_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in polar.
function polar_Callback(hObject, eventdata, handles)
% hObject    handle to polar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of polar


% --- Executes on button press in fit.
function fit_Callback(hObject, eventdata, handles)
% hObject    handle to fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fit
