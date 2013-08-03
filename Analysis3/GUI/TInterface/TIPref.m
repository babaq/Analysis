function varargout = TIPref(varargin)
% TIPREF MATLAB code for TIPref.fig
%      TIPREF by itself, creates a new TIPREF or raises the
%      existing singleton*.
%
%      H = TIPREF returns the handle to a new TIPREF or the handle to
%      the existing singleton*.
%
%      TIPREF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIPREF.M with the given input arguments.
%
%      TIPREF('Property','Value',...) creates a new TIPREF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TIPref_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TIPref_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TIPref

% Last Modified by GUIDE v2.5 29-Apr-2013 15:03:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TIPref_OpeningFcn, ...
    'gui_OutputFcn',  @TIPref_OutputFcn, ...
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

% --- Executes just before TIPref is made visible.
function TIPref_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TIPref (see VARARGIN)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load TInterface Preferences
tip = Analysis.Base.loadvar('TInterface','TIPref.mat');
if ~isempty(tip)
    setpref(tip,handles);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose default command line output for TIPref
handles.output = [];

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
            case 'title'
                set(hObject, 'Name', varargin{index+1});
            case 'string'
                set(handles.text1, 'String', varargin{index+1});
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);
    
    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
        (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes TIPref wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = TIPref_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.figure1);

% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pref = getpref(handles);
Analysis.Base.savevar('TInterface',pref,'TIPref');
handles.output = pref;

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = [];

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cancel_Callback(hObject, eventdata, handles);


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    cancel_Callback(hObject, eventdata, handles);
end

if isequal(get(hObject,'CurrentKey'),'return')
    ok_Callback(hObject, eventdata, handles);
end


% --- Get all preference values from UI.
function pref = getpref(handles)
pref.esformat = get(handles.esformat,'String');
pref.readoptions = get(handles.readoptions,'String');
pref.rootpath = get(handles.rootpath,'String');
pref.isreadspikewave = get(handles.isreadspikewave,'Value');
pref.ismergechannel = get(handles.ismergechannel,'Value');
pref.isparseeventseries = get(handles.isparseeventseries,'Value');
pref.isparsecell = get(handles.isparsecell,'Value');

% --- Set all preference values to UI.
function setpref(pref,handles)
set(handles.esformat,'String',pref.esformat);
set(handles.readoptions,'String',pref.readoptions);
set(handles.rootpath,'String',pref.rootpath);
set(handles.isreadspikewave,'Value',pref.isreadspikewave);
set(handles.ismergechannel,'Value',pref.ismergechannel);
set(handles.isparseeventseries,'Value',pref.isparseeventseries);
set(handles.isparsecell,'Value',pref.isparsecell);

% --- Executes on button press in isreadspikewave.
function isreadspikewave_Callback(hObject, eventdata, handles)
% hObject    handle to isreadspikewave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isreadspikewave


function esformat_Callback(hObject, eventdata, handles)
% hObject    handle to esformat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of esformat as text
%        str2double(get(hObject,'String')) returns contents of esformat as a double


% --- Executes during object creation, after setting all properties.
function esformat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to esformat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ismergechannel.
function ismergechannel_Callback(hObject, eventdata, handles)
% hObject    handle to ismergechannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ismergechannel


% --- Executes on button press in isparseeventseries.
function isparseeventseries_Callback(hObject, eventdata, handles)
% hObject    handle to isparseeventseries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isparseeventseries


% --- Executes on button press in isparsecell.
function isparsecell_Callback(hObject, eventdata, handles)
% hObject    handle to isparsecell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isparsecell


function readoptions_Callback(hObject, eventdata, handles)
% hObject    handle to readoptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of readoptions as text
%        str2double(get(hObject,'String')) returns contents of readoptions as a double


% --- Executes during object creation, after setting all properties.
function readoptions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to readoptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function rootpath_Callback(hObject, eventdata, handles)
% hObject    handle to rootpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rootpath as text
%        str2double(get(hObject,'String')) returns contents of rootpath as a double


% --- Executes during object creation, after setting all properties.
function rootpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rootpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
