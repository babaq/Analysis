function varargout = VLab(varargin)
% VLAB MATLAB code for VLab.fig
%      VLAB, by itself, creates a new VLAB or raises the existing
%      singleton*.
%
%      H = VLAB returns the handle to a new VLAB or the handle to
%      the existing singleton*.
%
%      VLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VLAB.M with the given input arguments.
%
%      VLAB('Property','Value',...) creates a new VLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VLab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VLab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VLab

% Last Modified by GUIDE v2.5 16-Oct-2014 16:54:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VLab_OpeningFcn, ...
    'gui_OutputFcn',  @VLab_OutputFcn, ...
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


% --- Executes just before VLab is made visible.
function VLab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VLab (see VARARGIN)

% Choose default command line output for VLab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load VLab Preferences
vlp = Analysis.Base.loadvar('VLab','VLPref.mat');
if ~isempty(vlp)
    setpref(vlp,handles);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UIWAIT makes VLab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VLab_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Get all preference values from UI.
function pref = getpref(handles)
pref.datapath = get(handles.dpath,'String');
pref.dataname = get(handles.dname,'String');
pref.exportpath = get(handles.epath,'String');
pref.isprepare = get(handles.ispre,'Value');
pref.datafile = get(handles.data,'String');
pref.ismlb = get(handles.ismlb,'Value');

% --- Set all preference values to UI.
function setpref(pref,handles)
set(handles.dpath,'String',pref.datapath);
set(handles.dname,'String',pref.dataname);
set(handles.epath,'String',pref.exportpath);
set(handles.ispre,'Value',pref.isprepare);
set(handles.data,'String',pref.datafile);
set(handles.ismlb,'Value',pref.ismlb);


function showdatafile(handles)
dp = get(handles.dpath,'String');
dn = get(handles.dname,'String');
d = struct2table(dir(fullfile(dp,dn)));

var = d.Properties.VariableNames;
d = varfun(@Analysis.Base.trystr2double,d);
d.Properties.VariableNames = var;
d = sortrows(d,'datenum','descend');

if isempty(d)
    name = 'No Match Files';
else
    name = d.name;
end
set(handles.data,'String',name);
set(handles.data,'Value',1);



function dpath_Callback(hObject, eventdata, handles)
% hObject    handle to dpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

showdatafile(handles)

% Hints: get(hObject,'String') returns contents of dpath as text
%        str2double(get(hObject,'String')) returns contents of dpath as a double


% --- Executes during object creation, after setting all properties.
function dpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in data.
function data_Callback(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from data


% --- Executes during object creation, after setting all properties.
function data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dname_Callback(hObject, eventdata, handles)
% hObject    handle to dname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

showdatafile(handles)

% Hints: get(hObject,'String') returns contents of dname as text
%        str2double(get(hObject,'String')) returns contents of dname as a double


% --- Executes during object creation, after setting all properties.
function dname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pref = getpref(handles);
Analysis.Base.savevar('VLab',pref,'VLPref');


% --- Executes on button press in readdata.
function readdata_Callback(hObject, eventdata, handles)
% hObject    handle to readdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global block;
contents = get(handles.data,'String');
if isempty(eventdata)
    fidx = get(handles.data,'Value');
else
    fidx = eventdata.filelistindex;
end
dfile = contents{fidx};
block = Analysis.IO.VLabIO.ReadVLBlock(fullfile(get(handles.dpath,'String'),dfile));
if get(handles.ispre,'Value')
    block = Analysis.IO.VLabIO.Prepare(block);
end


% --- Executes on button press in ispre.
function ispre_Callback(hObject, eventdata, handles)
% hObject    handle to ispre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of ispre


% --- Executes on button press in exportdata.
function exportdata_Callback(hObject, eventdata, handles)
% hObject    handle to exportdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global block;
if ~isempty(block)
    Analysis.IO.VLabIO.ExportBlock( block,get(handles.epath,'String'),...
        'isprepare',false,'ismlb',get(handles.ismlb,'Value') );
else
    warning('No Data to Export, Read First.');
    warndlg('No Data to Export, Read First.');
end



function epath_Callback(hObject, eventdata, handles)
% hObject    handle to epath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epath as text
%        str2double(get(hObject,'String')) returns contents of epath as a double


% --- Executes during object creation, after setting all properties.
function epath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in analysis.
function analysis_Callback(hObject, eventdata, handles)
% hObject    handle to analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Analysis;


% --- Executes on button press in ismlb.
function ismlb_Callback(hObject, eventdata, handles)
% hObject    handle to ismlb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ismlb


% --------------------------------------------------------------------
function dt_Callback(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function edlt_Callback(hObject, eventdata, handles)
% hObject    handle to edlt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.data,'String');
ed.filelistindex = 0;
for i=1:length(contents)
    ed.filelistindex = i;
    readdata_Callback(hObject, ed, handles);
    exportdata_Callback(hObject, eventdata, handles);
end
