function varargout = MainRF_dBar(varargin)
% MAINRF_DBAR M-file for MainRF_dBar.fig
%      MAINRF_DBAR, by itself, creates a new MAINRF_DBAR or raises the existing
%      singleton*.
%
%      H = MAINRF_DBAR returns the handle to a new MAINRF_DBAR or the handle to
%      the existing singleton*.
%
%      MAINRF_DBAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINRF_DBAR.M with the given input arguments.
%
%      MAINRF_DBAR('Property','Value',...) creates a new MAINRF_DBAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainRF_dBar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainRF_dBar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainRF_dBar

% Last Modified by GUIDE v2.5 20-Apr-2009 17:00:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainRF_dBar_OpeningFcn, ...
                   'gui_OutputFcn',  @MainRF_dBar_OutputFcn, ...
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


% --- Executes just before MainRF_dBar is made visible.
function MainRF_dBar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainRF_dBar (see VARARGIN)

% Choose default command line output for MainRF_dBar
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% Init MainRF_dBar GUI
MData = 0;
setappdata(handles.figure1,'MData',MData);
% Positioning Main Window
scnsize = get(0,'ScreenSize');
set(hObject,'Position',[1,scnsize(4),42,31]);
% Init Channal,Sortcode and Stimuli
global RFData;

ch_n = RFData.Snip.chn;
ccn = cell(1,ch_n+1);
ccn{1} = 'ALL';
for i=1:ch_n
    ccn{i+1}=num2str(i);
end
set(handles.ch_n,'String',ccn);

set(handles.sort_n,'String',{'MUA'});

if strcmp(RFData.Mark.extype,'RF_sdBar')
    set( handles.sti_n,'String',{ num2str( RFData.Mark.ckey{4,2} ) } );
else % RF_mdBar
    set( handles.sti_n,'String',{'ALL'});
end

set(handles.stiname,'String',RFData.Mark.extype);

clear RFData;

% UIWAIT makes MainRF_dBar wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainRF_dBar_OutputFcn(hObject, eventdata, handles) 
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

global RFData;

MapData = getappdata(handles.figure1,'MData');
selection = questdlg('Do you want to save RFMap Data ?',...
                     'Save RFMap Data ...',...
                     'Yes','No','No');              
if strcmp(selection,'Yes')
    if iscell(MapData)
        filename=[RFData.Dinf.tank,' __ ',RFData.Dinf.block,' __ ',RFData.Mark.extype,'_RFMap'];
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

if ~iscell(mapdata) % Calculate RF Map Only Once Unless Delay Changed
    DataSet = PreProcess(RFData,0,str2double(delay),1);
    mapdata = RFMap_dBar(DataSet,RFData.Mark.ckey{end,2});
    setappdata(handles.figure1,'MData',mapdata);
end


% Show Result
isfit = get(handles.fit,'Value');

contents = get(handles.ch_n,'String');
ch = contents{get(handles.ch_n,'Value')};

contents = get(handles.sort_n,'String');
sort = contents{get(handles.sort_n,'Value')};

contents = get(handles.sti_n,'String');
condition = contents{get(handles.sti_n,'Value')};

RFMap_dBar_Draw(mapdata,RFData,ch,sort,condition,delay,isfit);

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


% --- Executes on selection change in ch_n.
function ch_n_Callback(hObject, eventdata, handles)
% hObject    handle to ch_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Refresh Sort_n of Selected Ch
global RFData;

ch_n = get(hObject,'Value')-1;
if ch_n==0 % ALL
    set(handles.sort_n,'String',{'MUA'});
    % Only All Directions in All Ch
    if strcmp(RFData.Mark.extype,'RF_mdBar')
        set(handles.sti_n,'String',{'ALL'});
    end
else 
    sort_n = RFData.Snip.sortn(ch_n);
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
    
    % Refresh All Directions in RF_mdBar Mode
    if strcmp(RFData.Mark.extype,'RF_mdBar')
        sti_n = RFData.Mark.key{3,2}; 
        cst = cell(1,sti_n+1);
        cst{1} = 'ALL';
        for i=1:sti_n
            t=(i-1)*360/sti_n;
            cst{i+1}=num2str(t);
        end
        set(handles.sti_n,'String',cst);
    end
end

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
