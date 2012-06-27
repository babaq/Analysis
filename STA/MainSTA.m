function varargout = MainSTA(varargin)
% MAINSTA M-file for MainSTA.fig
%      MAINSTA, by itself, creates a new MAINSTA or raises the existing
%      singleton*.
%
%      H = MAINSTA returns the handle to a new MAINSTA or the handle to
%      the existing singleton*.
%
%      MAINSTA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINSTA.M with the given input arguments.
%
%      MAINSTA('Property','Value',...) creates a new MAINSTA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainSTA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainSTA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainSTA

% Last Modified by GUIDE v2.5 30-Mar-2011 21:43:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainSTA_OpeningFcn, ...
                   'gui_OutputFcn',  @MainSTA_OutputFcn, ...
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


% --- Executes just before MainSTA is made visible.
function MainSTA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainSTA (see VARARGIN)

% Choose default command line output for MainSTA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



%%% Init MainSTA GUI
SData = 0;
setappdata(handles.figure1,'SData',SData);
% Positioning Main Window
scnsize = get(0,'ScreenSize');
set(hObject,'Position',[1,scnsize(4),43,30]);
% Init Channal,Sortcode and Stimuli
global STAData;

ch_n = STAData.Snip.chn;
ccn1 = cell(1,ch_n+1);
ccn2 = cell(1,ch_n);
for i=1:ch_n
    ccn1{i+1}=num2str(i);
    ccn2{i}=num2str(i);
end
ccn1{1} = 'Each';
set(handles.ch_n1,'String',ccn1);
set(handles.ch_n2,'String',ccn2);

ch_n2_Callback(handles.ch_n2, eventdata, handles);

if STAData.Mark.stimuli==1
    set( handles.sti_n,'String',{ '1' } );
else
    sti_n = STAData.Mark.stimuli;
    cst = cell(1,sti_n+1);
    cst{1} = 'ALL';
    for i=1:sti_n
        cst{i+1}=num2str(i);
    end
    set(handles.sti_n,'String',cst);
end

set(handles.stiname,'String',STAData.Mark.extype);

clear STAData;

% UIWAIT makes MainSTA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainSTA_OutputFcn(hObject, eventdata, handles) 
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
global STAData;

staData = getappdata(handles.figure1,'SData');
selection = questdlg('Do you want to save STA Data ?',...
                     'Save STA Data ...',...
                     'Yes','No','No');          
if strcmp(selection,'Yes')
    if iscell(staData)
        filename=[STAData.Dinf.tank,'__',STAData.Dinf.block,'__',STAData.Mark.extype,'_STA'];
        filename=fullfile(STAData.OutputDir,filename);
        save(filename,'staData');
    else
        disp('No Complete Data To Save !');
        warndlg('No Complete Data To Save !','Warnning');
    end
end

% Clear Global Data
clear global STAData;

delete(hObject)





% --- Executes on button press in show.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global STAData;

stadata = getappdata(handles.figure1,'SData');

contents = get(handles.delay_n,'String');
delay = contents{get(handles.delay_n,'Value')};

contents = get(handles.hseg_n,'String');
hseg = contents{get(handles.hseg_n,'Value')};

ch_n1 = get(handles.ch_n1,'Value')-1;

if ~iscell(stadata)
    STAData = PreProcess(STAData,0,str2double(delay),1);
    stadata = CalcSTA(STAData,str2double(hseg),0,str2double(delay),ch_n1);
    setappdata(handles.figure1,'SData',stadata);
end


% Show Result
ch_n2 = get(handles.ch_n2,'Value');

contents = get(handles.sort_n,'String');
sort = contents{get(handles.sort_n,'Value')};

contents = get(handles.sti_n,'String');
sti = contents{get(handles.sti_n,'Value')};

STA_Draw(stadata,STAData,delay,hseg,ch_n1,ch_n2,sort,sti);

clear STAData;




% --- Executes on selection change in ch_n1.
function ch_n1_Callback(hObject, eventdata, handles)
% hObject    handle to ch_n1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SData = 0;
setappdata(handles.figure1,'SData',SData);

% Hints: contents = get(hObject,'String') returns ch_n1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch_n1


% --- Executes during object creation, after setting all properties.
function ch_n1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch_n1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in hseg_n.
function hseg_n_Callback(hObject, eventdata, handles)
% hObject    handle to hseg_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SData = 0;
setappdata(handles.figure1,'SData',SData);

% Hints: contents = get(hObject,'String') returns hseg_n contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hseg_n


% --- Executes during object creation, after setting all properties.
function hseg_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hseg_n (see GCBO)
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
SData = 0;
setappdata(handles.figure1,'SData',SData);

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



% --- Executes on selection change in ch_n2.
function ch_n2_Callback(hObject, eventdata, handles)
% hObject    handle to ch_n2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global STAData;

ch_n = get(hObject,'Value');
sort_n = STAData.Snip.sortn(ch_n);
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

clear STAData;

% Hints: contents = get(hObject,'String') returns ch_n2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch_n2


% --- Executes during object creation, after setting all properties.
function ch_n2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch_n2 (see GCBO)
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
