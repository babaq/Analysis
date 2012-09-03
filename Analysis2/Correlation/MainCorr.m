function varargout = MainCorr(varargin)
% MAINCORR M-file for MainCorr.fig
%      MAINCORR, by itself, creates a new MAINCORR or raises the existing
%      singleton*.
%
%      H = MAINCORR returns the handle to a new MAINCORR or the handle to
%      the existing singleton*.
%
%      MAINCORR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINCORR.M with the given input arguments.
%
%      MAINCORR('Property','Value',...) creates a new MAINCORR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainCorr_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainCorr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainCorr

% Last Modified by GUIDE v2.5 08-Sep-2009 21:12:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainCorr_OpeningFcn, ...
                   'gui_OutputFcn',  @MainCorr_OutputFcn, ...
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


% --- Executes just before MainCorr is made visible.
function MainCorr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainCorr (see VARARGIN)

% Choose default command line output for MainCorr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



%%% Init MainCorr GUI
CData = 0;
setappdata(handles.figure1,'CData',CData);
% Positioning Main Window
scnsize = get(0,'ScreenSize');
set(hObject,'Position',[1,scnsize(4),62,28]);
% Init Channal,Sort and Stimuli
global CorrData;

if isfield(CorrData,'Snip')
    ch_n = CorrData.Snip.chn;
else
    errordlg('NO DATA TO SHOW !','Data Error');
    return;
end

ccn = cell(1,ch_n);
for i=1:ch_n
    ccn{i}=num2str(i);
end
set(handles.ch_n1,'String',ccn);
set(handles.ch_n2,'String',ccn);
ch_n1_Callback(handles.ch_n1, eventdata, handles);
ch_n2_Callback(handles.ch_n2, eventdata, handles);

if CorrData.Mark.stimuli==1
    set( handles.sti_n,'String',{ '1' } );
else
    sti_n = CorrData.Mark.stimuli;
    cst = cell(1,sti_n+1);
    cst{1} = 'ALL';
    for i=1:sti_n
        cst{i+1}=num2str(i);
    end
    set(handles.sti_n,'String',cst);
end
set(handles.exname,'String',CorrData.Mark.extype);

clear CorrData;

% UIWAIT makes MainCorr wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainCorr_OutputFcn(hObject, eventdata, handles) 
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
global CorrData;

CData = getappdata(handles.figure1,'CData');
selection = questdlg('Do you want to save Correlation Data ?',...
                     'Save Correlation Data ...',...
                     'Yes','No','No');                
if strcmp(selection,'Yes')
    if CData~=0
        filename=[CorrData.Dinf.tank,'__',CorrData.Dinf.block,'__',CorrData.Mark.extype,'_Corr'];
        filename=fullfile(CorrData.OutputDir,filename);
        save(filename,'CData');
    else
        disp('No Complete Data To Save !');
        warndlg('No Complete Data To Save !','Warnning');
    end
end

% Clear Global Data
clear global CorrData;

delete(hObject);





% --- Executes on button press in corr.
function corr_Callback(hObject, eventdata, handles)
% hObject    handle to corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CorrData;


contents = get(handles.delay_n,'String');
delay = contents{get(handles.delay_n,'Value')};

contents = get(handles.lag_n,'String');
lag = contents{get(handles.lag_n,'Value')};

contents = get(handles.bin_n,'String');
bin = contents{get(handles.bin_n,'Value')};

ch_n1 = get(handles.ch_n1,'Value');
ch_n2 = get(handles.ch_n2,'Value');

contents = get(handles.sort_n1,'String');
sort1 = contents{get(handles.sort_n1,'Value')};

contents = get(handles.sort_n2,'String');
sort2 = contents{get(handles.sort_n2,'Value')};

if strcmp(get(handles.show,'Visible'),'off')
    ppds = PreProcess(CorrData,0,str2double(delay),1);
    cdata = CalcCorr(ppds,str2double(lag),str2double(bin),...
                        ch_n1,sort1,ch_n2,sort2,0);
    setappdata(handles.figure1,'CData',cdata);
    set(handles.show,'Visible','on');
end

clear CorrData;


% --- Executes on button press in show.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CorrData;

cdata = getappdata(handles.figure1,'CData');


contents = get(handles.delay_n,'String');
delay = contents{get(handles.delay_n,'Value')};

contents = get(handles.lag_n,'String');
lag = contents{get(handles.lag_n,'Value')};

contents = get(handles.bin_n,'String');
bin = contents{get(handles.bin_n,'Value')};

contents = get(handles.ch_n1,'String');
ch_1 = contents{get(handles.ch_n1,'Value')};

contents = get(handles.ch_n2,'String');
ch_2 = contents{get(handles.ch_n2,'Value')};

contents = get(handles.sort_n1,'String');
sort1 = contents{get(handles.sort_n1,'Value')};

contents = get(handles.sort_n2,'String');
sort2 = contents{get(handles.sort_n2,'Value')};

contents = get(handles.sti_n,'String');
sti = contents{get(handles.sti_n,'Value')};

isfit = get(handles.fit,'Value');


Corr_Draw(cdata,CorrData,delay,lag,bin,...
          ch_1,sort1,ch_2,sort2,sti,1,isfit);
                    
clear CorrData;





% --- Executes on selection change in ch_n1.
function ch_n1_Callback(hObject, eventdata, handles)
% hObject    handle to ch_n1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CorrData;

ch_n = get(hObject,'Value');
sort_n = CorrData.Snip.sortn(ch_n);
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
set(handles.sort_n1,'String',cso);
set(handles.sort_n1,'Value',1);
set(handles.show,'Visible','off');
  
clear CorrData;
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


% --- Executes on selection change in sort_n1.
function sort_n1_Callback(hObject, eventdata, handles)
% hObject    handle to sort_n1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.show,'Visible','off');

% Hints: contents = get(hObject,'String') returns sort_n1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sort_n1


% --- Executes during object creation, after setting all properties.
function sort_n1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sort_n1 (see GCBO)
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
global CorrData;

ch_n = get(hObject,'Value');
sort_n = CorrData.Snip.sortn(ch_n);
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
set(handles.sort_n2,'String',cso);
set(handles.sort_n2,'Value',1);
set(handles.show,'Visible','off');
    
clear CorrData;
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


% --- Executes on selection change in sort_n2.
function sort_n2_Callback(hObject, eventdata, handles)
% hObject    handle to sort_n2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.show,'Visible','off');

% Hints: contents = get(hObject,'String') returns sort_n2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sort_n2


% --- Executes during object creation, after setting all properties.
function sort_n2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sort_n2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lag_n.
function lag_n_Callback(hObject, eventdata, handles)
% hObject    handle to lag_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.show,'Visible','off');

% Hints: contents = get(hObject,'String') returns lag_n contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lag_n


% --- Executes during object creation, after setting all properties.
function lag_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lag_n (see GCBO)
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
set(handles.show,'Visible','off');

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


% --- Executes on selection change in bin_n.
function bin_n_Callback(hObject, eventdata, handles)
% hObject    handle to bin_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.show,'Visible','off');

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


% --- Executes on button press in fit.
function fit_Callback(hObject, eventdata, handles)
% hObject    handle to fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fit
