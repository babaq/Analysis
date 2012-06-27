function varargout = MainFPhase(varargin)
% MAINFPHASE M-file for MainFPhase.fig
%      MAINFPHASE, by itself, creates a new MAINFPHASE or raises the existing
%      singleton*.
%
%      H = MAINFPHASE returns the handle to a new MAINFPHASE or the handle to
%      the existing singleton*.
%
%      MAINFPHASE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINFPHASE.M with the given input arguments.
%
%      MAINFPHASE('Property','Value',...) creates a new MAINFPHASE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainFPhase_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainFPhase_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainFPhase

% Last Modified by GUIDE v2.5 17-Oct-2008 22:09:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainFPhase_OpeningFcn, ...
                   'gui_OutputFcn',  @MainFPhase_OutputFcn, ...
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


% --- Executes just before MainFPhase is made visible.
function MainFPhase_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainFPhase (see VARARGIN)

% Choose default command line output for MainFPhase
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% Init MainFPhase GUI
PData = 0;
setappdata(handles.figure1,'PData',PData);
% Positioning Main Window
scnsize = get(0,'ScreenSize');
set(hObject,'Position',[1,scnsize(4),41,21]);
% Init Channal,Sort and Stimuli
global FPData;

ch_n = FPData.Snip.chn;
ccn = cell(1,ch_n);
for i=1:ch_n
    ccn{i}=num2str(i);
end
set(handles.ch_n,'String',ccn);

sort_n = FPData.Snip.sortn(1);
if sort_n==0 % no sort
    cso = {'NO SORT !'};
elseif sort_n==1 % single unit
    cso = {'SU'};
else
    cso = cell(1,sort_n+1);
    cso{1}='MUA';
    for i=1:sort_n
        cso{i+1}=['SU',num2str(i)];
    end
end
set(handles.sort_n,'String',cso);


if FPData.Mark.stimuli==1
    set( handles.sti_n,'String',{ '1' } );
else
    sti_n = FPData.Mark.stimuli;
    cst = cell(1,sti_n+1);
    cst{1} = 'ALL';
    for i=1:sti_n
        cst{i+1}=num2str(i);
    end
    set(handles.sti_n,'String',cst);
end

set(handles.stiname,'String',FPData.Mark.extype);

clear FPData;

% UIWAIT makes MainFPhase wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainFPhase_OutputFcn(hObject, eventdata, handles) 
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
global FPData;

contents = get(handles.method,'String');
method = contents{get(handles.method,'Value')};

fpdData = getappdata(handles.figure1,'PData');
selection = questdlg(['Do you want to save ',method,' Data ?'],...
                     'Save Data ...',...
                     'Yes','No','No');              
if strcmp(selection,'Yes')
    if iscell(fpdData)
        filename=[FPData.Dinf.tank,'__',FPData.Dinf.block,'__',FPData.Mark.extype,'__',method];
        filename=fullfile(FPData.OutputDir,filename);
        save(filename,'fpdData');
    else
        disp('No Complete Data To Save !');
        warndlg('No Complete Data To Save !','Warnning');
    end
end

% Clear Global Data
clear global FPData;

delete(hObject);





% --- Executes on button press in show.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FPData;

fpddata = getappdata(handles.figure1,'PData');

contents = get(handles.delay_n,'String');
delay = contents{get(handles.delay_n,'Value')};

contents = get(handles.bin_n,'String');
bin = contents{get(handles.bin_n,'Value')};

contents = get(handles.method,'String');
method = contents{get(handles.method,'Value')};

if ~iscell(fpddata)
    DataSet = PreProcess(FPData,0,str2double(delay),0);
    if strcmp(method,'FPD')
        fpddata = FPD(DataSet,str2double(bin));
    else
        fpddata = FPH(DataSet,str2double(bin));
    end
    setappdata(handles.figure1,'PData',fpddata);
end


% Show Result
contents = get(handles.ch_n,'String');
ch = contents{get(handles.ch_n,'Value')};

contents = get(handles.sort_n,'String');
sort = contents{get(handles.sort_n,'Value')};

contents = get(handles.sti_n,'String');
sti = contents{get(handles.sti_n,'Value')};

if strcmp(method,'FPD')
    FPD_Draw(fpddata,FPData,delay,bin,ch,sort,sti);
else
    FPH_Draw(fpddata,FPData,delay,bin,ch,sort,sti);
end

clear FPData;




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


% --- Executes on selection change in ch_n.
function ch_n_Callback(hObject, eventdata, handles)
% hObject    handle to ch_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FPData;

ch_n = get(hObject,'Value');
sort_n = FPData.Snip.sortn(ch_n);
if sort_n==0 % no sort
    cso = {'NO SORT !'};
elseif sort_n==1 % single unit
    cso = {'SU'};
else
    cso = cell(1,sort_n+1);
    cso{1}='MUA';
    for i=1:sort_n
        cso{i+1}=['SU',num2str(i)];
    end
end
set(handles.sort_n,'String',cso);
set(handles.sort_n,'Value',1);

clear FPData;

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


% --- Executes on selection change in method.
function method_Callback(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PData = 0;
setappdata(handles.figure1,'PData',PData);

% Hints: contents = get(hObject,'String') returns method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method


% --- Executes during object creation, after setting all properties.
function method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


