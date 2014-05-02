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

% Last Modified by GUIDE v2.5 02-May-2014 13:07:59

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
pref.isorganize = get(handles.isorg,'Value');
pref.datafile = get(handles.data,'String');
pref.isfigvalid = get(handles.isfv,'Value');
pref.badstatus = get(handles.bs,'String');
pref.nivs = get(handles.nivs,'String');
pref.iscoredata = get(handles.iscoredata,'Value');

% --- Set all preference values to UI.
function setpref(pref,handles)
set(handles.dpath,'String',pref.datapath);
set(handles.dname,'String',pref.dataname);
set(handles.epath,'String',pref.exportpath);
set(handles.ispre,'Value',pref.isprepare);
set(handles.isorg,'Value',pref.isorganize);
set(handles.data,'String',pref.datafile);
set(handles.isfv,'Value',pref.isfigvalid);
set(handles.bs,'String',pref.badstatus);
set(handles.nivs,'String',pref.nivs);
set(handles.iscoredata,'Value',pref.iscoredata);


function showdatafile(handles)
dp = get(handles.dpath,'String');
dn = get(handles.dname,'String');
d = struct2table(dir(fullfile(dp,dn)));

var = d.Properties.VariableNames;
d = varfun(@Analysis.Base.trystr2double,d);
d.Properties.VariableNames = var;
d = sortrows(d,'datenum','descend');

set(handles.data,'String',d.name);



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

global block param data;
contents = get(handles.data,'String');
dfile = contents{get(handles.data,'Value')};
block = Analysis.IO.VLabIO.ReadVLBlock(fullfile(get(handles.dpath,'String'),dfile));
if get(handles.ispre,'Value')
    dl = '\s*,\s*';
    nivs = get(handles.nivs,'String');
    nivs = strsplit(strtrim(nivs),dl,'delimitertype','regularexpression');
    block = Analysis.IO.VLabIO.Prepare(block,'nivs',nivs);
end
if get(handles.isorg,'Value')
    dl = '\s*,\s*';
    bs = get(handles.bs,'String');
    bs = strsplit(strtrim(bs),dl,'delimitertype','regularexpression');
    [ param,data ] = Analysis.IO.VLabIO.Organize(block,bs,get(handles.isfv,'Value'));
end


% --- Executes on button press in ispre.
function ispre_Callback(hObject, eventdata, handles)
% hObject    handle to ispre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.ispre,'Value')
    set(handles.nivst,'Visible','on');
    set(handles.nivs,'Visible','on');
else
    set(handles.nivst,'Visible','off');
    set(handles.nivs,'Visible','off');
end
% Hint: get(hObject,'Value') returns toggle state of ispre


% --- Executes on button press in isorg.
function isorg_Callback(hObject, eventdata, handles)
% hObject    handle to isorg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.isorg,'Value')
    set(handles.isfv,'Visible','on');
    set(handles.bs,'Visible','on');
    set(handles.bst,'Visible','on');
else
    set(handles.isfv,'Visible','off');
    set(handles.bs,'Visible','off');
    set(handles.bst,'Visible','off');
end
% Hint: get(hObject,'Value') returns toggle state of isorg


% --- Executes on button press in exportdata.
function exportdata_Callback(hObject, eventdata, handles)
% hObject    handle to exportdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global block
if ~isempty(block)
    Analysis.IO.VLabIO.ExportBlock( block,get(handles.epath,'String'),...
        false,get(handles.iscoredata,'Value') );
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


% --- Executes on button press in isfv.
function isfv_Callback(hObject, eventdata, handles)
% hObject    handle to isfv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isfv



function bs_Callback(hObject, eventdata, handles)
% hObject    handle to bs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bs as text
%        str2double(get(hObject,'String')) returns contents of bs as a double


% --- Executes during object creation, after setting all properties.
function bs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nivs_Callback(hObject, eventdata, handles)
% hObject    handle to nivs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nivs as text
%        str2double(get(hObject,'String')) returns contents of nivs as a double


% --- Executes during object creation, after setting all properties.
function nivs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nivs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in iscoredata.
function iscoredata_Callback(hObject, eventdata, handles)
% hObject    handle to iscoredata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of iscoredata
