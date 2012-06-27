function varargout = MainPSTH(varargin)
% MAINPSTH M-file for MainPSTH.fig
%      MAINPSTH, by itself, creates a new MAINPSTH or raises the existing
%      singleton*.
%
%      H = MAINPSTH returns the handle to a new MAINPSTH or the handle to
%      the existing singleton*.
%
%      MAINPSTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINPSTH.M with the given input arguments.
%
%      MAINPSTH('Property','Value',...) creates a new MAINPSTH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainPSTH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainPSTH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainPSTH

% Last Modified by GUIDE v2.5 18-Jul-2008 19:49:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainPSTH_OpeningFcn, ...
                   'gui_OutputFcn',  @MainPSTH_OutputFcn, ...
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


% --- Executes just before MainPSTH is made visible.
function MainPSTH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainPSTH (see VARARGIN)

% Choose default command line output for MainPSTH
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



%%% Init MainPSTH GUI
PData = 0;
setappdata(handles.figure1,'PData',PData);
% Positioning Main Window
scnsize = get(0,'ScreenSize');
set(hObject,'Position',[1,scnsize(4),41,21]);
% Init Channal,Sort and Stimuli
global PSTHData;

ch_n = PSTHData.Snip.chn;
ccn = cell(1,ch_n);
for i=1:ch_n
    ccn{i}=num2str(i);
end
set(handles.ch_n,'String',ccn);
ch_n_Callback(handles.ch_n, eventdata, handles);

if PSTHData.Mark.stimuli==1
    set( handles.sti_n,'String',{ '1' } );
else
    sti_n = PSTHData.Mark.stimuli;
    cst = cell(1,sti_n+1);
    cst{1} = 'ALL';
    for i=1:sti_n
        cst{i+1}=num2str(i);
    end
    set(handles.sti_n,'String',cst);
end

set(handles.exname,'String',PSTHData.Mark.extype);

clear PSTHData;

% UIWAIT makes MainPSTH wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainPSTH_OutputFcn(hObject, eventdata, handles) 
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
global PSTHData;

psthData = getappdata(handles.figure1,'PData');
selection = questdlg('Do you want to save PSTH Data ?',...
                     'Save PSTH Data ...',...
                     'Yes','No','No');              
if strcmp(selection,'Yes')
    if iscell(psthData)
        filename=[PSTHData.Dinf.tank,'__',PSTHData.Dinf.block,'__',PSTHData.Mark.extype,'_PSTH'];
        filename=fullfile(PSTHData.OutputDir,filename);
        save(filename,'psthData');
    else
        disp('No Complete Data To Save !');
        warndlg('No Complete Data To Save !','Warnning');
    end
end

% Clear Global Data
clear global PSTHData;

delete(hObject);





% --- Executes on button press in b_show.
function b_show_Callback(hObject, eventdata, handles)
% hObject    handle to b_show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PSTHData;

psthdata = getappdata(handles.figure1,'PData');

contents = get(handles.delay_n,'String');
delay = contents{get(handles.delay_n,'Value')};

contents = get(handles.bin_n,'String');
bin = contents{get(handles.bin_n,'Value')};

if ~iscell(psthdata)
    PSTHData = PreProcess(PSTHData,0,str2double(delay),1);
    psthdata = CalcPSTH(PSTHData,str2double(bin));
    setappdata(handles.figure1,'PData',psthdata);
end


% Show Result
contents = get(handles.ch_n,'String');
ch = contents{get(handles.ch_n,'Value')};

contents = get(handles.sort_n,'String');
sort = contents{get(handles.sort_n,'Value')};

contents = get(handles.sti_n,'String');
sti = contents{get(handles.sti_n,'Value')};

PSTH_Draw(psthdata,PSTHData,delay,bin,ch,sort,sti);

clear PSTHData;





% --- Executes on selection change in ch_n.
function ch_n_Callback(hObject, eventdata, handles)
% hObject    handle to ch_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PSTHData;

ch_n = get(hObject,'Value');
sort_n = PSTHData.Snip.sortn(ch_n);
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
set(handles.sort_n,'Value',1);

clear PSTHData;

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


% --- Executes on selection change in delay_n.
function delay_n_Callback(hObject, eventdata, handles)
% hObject    handle to delay_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PData = 0;
setappdata(handles.figure1,'PData',PData);

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


% --- Executes on selection change in bin_n.
function bin_n_Callback(hObject, eventdata, handles)
% hObject    handle to bin_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PData = 0;
setappdata(handles.figure1,'PData',PData);

% Hints: contents = get(hObject,'String') returns bin_n contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bin_n


% --- Executes during object creation, after setting all properties.
function bin_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bin_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

