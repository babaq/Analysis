function varargout = MainRF_Grating(varargin)
% MAINRF_GRATING M-file for MainRF_Grating.fig
%      MAINRF_GRATING, by itself, creates a new MAINRF_GRATING or raises the existing
%      singleton*.
%
%      H = MAINRF_GRATING returns the handle to a new MAINRF_GRATING or the handle to
%      the existing singleton*.
%
%      MAINRF_GRATING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINRF_GRATING.M with the given input arguments.
%
%      MAINRF_GRATING('Property','Value',...) creates a new MAINRF_GRATING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainRF_Grating_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainRF_Grating_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainRF_Grating

% Last Modified by GUIDE v2.5 29-Apr-2011 15:21:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainRF_Grating_OpeningFcn, ...
    'gui_OutputFcn',  @MainRF_Grating_OutputFcn, ...
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


% --- Executes just before MainRF_Grating is made visible.
function MainRF_Grating_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainRF_Grating (see VARARGIN)

% Choose default command line output for MainRF_Grating
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



%%% Init MainRF_Grating GUI
MData = 0;
setappdata(handles.figure1,'MData',MData);
% Positioning Main Window
scnsize = get(0,'ScreenSize');
set(hObject,'Position',[1,scnsize(4),42,31]);
% Init Channal,Sortcode
global RFData;

if isfield(RFData,'Snip')
    ch_n = RFData.Snip.chn;
else
    ch_n = RFData.Wave.chn;
end
ccn = cell(1,ch_n+1);
ccn{1} = 'ALL';
for i=1:ch_n
    ccn{i+1}=num2str(i);
end
set(handles.ch_n,'String',ccn);
set(handles.sort_n,'String',{'MU'});
set(handles.stiname,'String',RFData.Mark.extype);

clear RFData;

% UIWAIT makes MainRF_Grating wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainRF_Grating_OutputFcn(hObject, eventdata, handles)
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

global RFData;

MapData = getappdata(handles.figure1,'MData');
selection = questdlg('Do you want to save RFMap Data ?',...
    'Save RFMap Data ...',...
    'Yes','No','No');
if strcmp(selection,'Yes')
    if iscell(MapData)
        filename=[RFData.Dinf.tank,'__',RFData.Dinf.block,'__',RFData.Mark.extype,'_RFMap_',MapData{end,1}.datatype];
        filename=fullfile(RFData.OutputDir,filename);
        save(filename,'MapData');
    else
        disp('No Complete Data To Save !');
        warndlg('No Complete Data To Save !','Warnning');
    end
end

% Clear Global Data
clear global RFData;

delete(hObject);





% --- Executes on button press in b_show.
function b_show_Callback(hObject, eventdata, handles)
% hObject    handle to b_show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global RFData;

mapdata = getappdata(handles.figure1,'MData');

contents = get(handles.delay_n,'String');
delay = contents{get(handles.delay_n,'Value')};
contents = get(handles.datatype,'String');
datatype = contents{get(handles.datatype,'Value')};

if ~iscell(mapdata) % Calculate RF Map Only Once Unless Delay and DataType Changed
    RFData = PreProcess(RFData,0,str2double(delay),0);
    mapdata = RFMap_Grating(RFData,datatype);
    setappdata(handles.figure1,'MData',mapdata);
end


% Show Result
isfit = get(handles.fit,'Value');
iscontour = get(handles.contour,'Value');

contents = get(handles.ch_n,'String');
ch = contents{get(handles.ch_n,'Value')};

contents = get(handles.sort_n,'String');
sort = contents{get(handles.sort_n,'Value')};

RFMap_Grating_Draw(mapdata,RFData,delay,ch,sort,isfit,iscontour);

clear RFData;





% --- Executes on selection change in delay_n.
function delay_n_Callback(hObject, eventdata, handles)
% hObject    handle to delay_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Reset RF Map Data
MData = 0;
setappdata(handles.figure1,'MData',MData);

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



% --- Executes on button press in fit.
function fit_Callback(hObject, eventdata, handles)
% hObject    handle to fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fit


% --- Executes on selection change in ch_n.
function ch_n_Callback(hObject, eventdata, handles)
% hObject    handle to ch_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Refresh Sort_n of Selected Channal
global RFData;

ch_n = get(hObject,'Value')-1;
if ch_n==0 % ALL Channal
    set(handles.sort_n,'String',{'MU'});
else
    sort_n = RFData.Snip.sortn(ch_n);
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

clear RFData;

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


% --- Executes on button press in contour.
function contour_Callback(hObject, eventdata, handles)
% hObject    handle to contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of contour


% --- Executes on selection change in datatype.
function datatype_Callback(hObject, eventdata, handles)
% hObject    handle to datatype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Reset RF Map Data
MData = 0;
setappdata(handles.figure1,'MData',MData);

% Hints: contents = get(hObject,'String') returns datatype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from datatype


% --- Executes during object creation, after setting all properties.
function datatype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datatype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
