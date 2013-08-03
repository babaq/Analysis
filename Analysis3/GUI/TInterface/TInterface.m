function varargout = TInterface(varargin)
% TINTERFACE MATLAB code for TInterface.fig
%      TINTERFACE, by itself, creates a new TINTERFACE or raises the existing
%      singleton*.
%
%      H = TINTERFACE returns the handle to a new TINTERFACE or the handle to
%      the existing singleton*.
%
%      TINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TINTERFACE.M with the given input arguments.
%
%      TINTERFACE('Property','Value',...) creates a new TINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TInterface

% Last Modified by GUIDE v2.5 15-Jan-2013 23:25:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TInterface_OpeningFcn, ...
    'gui_OutputFcn',  @TInterface_OutputFcn, ...
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


% --- Executes just before TInterface is made visible.
function TInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TInterface (see VARARGIN)

% Choose default command line output for TInterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import Analysis.IO.TDTIO.TTank.* Analysis.Core.* Analysis.Base.*
% Connect TTank Server when started
if ConnectServer(handles.activex1,'Local','TInterface')
    disp('TTank Server "Local" Connected in "TInterface".');
else
    disp('TTank Server "Local" Connection Failed.');
    errordlg('TTank Server "Local" Connection Failed.','No Server Connected');
end
handles.activex3.SingleClickSelect = 1;
handles.activex4.SingleClickSelect = 1;
handles.activex4.HideDetails = 0;
handles.activex5.SingleClickSelect = 1;
handles.activex5.HideDetails = 0;
% load TInterface Preferences
tip = loadvar('TInterface','TIPref.mat');
if isempty(tip)
    errordlg('TInterface preferences file do not exist. set in main menu before any usage.',...
        'Preferences file not found.');
else
    setappdata(hObject,'Preferences',tip);
end
% set application data
setappdata(hObject,'CurrentBlock',[]);
setappdata(hObject,'ReadedEvent',[]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UIWAIT makes TInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TInterface_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import Analysis.Base.*
block = getappdata(handles.figure1,'CurrentBlock');
tip = getappdata(handles.figure1,'Preferences');
if isempty(block)
    warning('NO Data Retrieved.');
    warndlg('NO Data Retrieved.','Warning');
elseif isempty(block.channelclustergroup)
    warning('NO Channel Data Retrieved.');
    warndlg('NO Channel Data Retrieved.','Warning');
else
    dialogtitle = 'Save Block';
    defaultname = fullfile(tip.rootpath,[block.source.tank,'__',block.name]);
    filterspec = '*.mat';
    [filename,pathname,filterindex] = uiputfile(filterspec,dialogtitle,defaultname);
    if ~isequal(filename,0) && ~isequal(pathname,0)
        if tip.ismergechannel
            block.channelclustergroup = MergeCCG(block.channelclustergroup);
        end
        if tip.isparsecell
            block.cellassemblegroup = ParseCAGccg(block.channelclustergroup);
        end
        save(fullfile(pathname,filename),'block');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function pref_Callback(hObject, eventdata, handles)
% hObject    handle to pref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tip = TIPref;
if ~isempty(tip)
    setappdata(handles.figure1,'Preferences',tip);
end

% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import Analysis.IO.TDTIO.TTank.*
% Close Tank and Server when exit
CloseTank(handles.activex1);
ReleaseServer(handles.activex1);
CloseConnection(handles.activex6);

% close the figure
delete(handles.figure1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function doc_Callback(hObject, eventdata, handles)
% hObject    handle to doc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exit_Callback(hObject, eventdata, handles)
% Hint: delete(hObject) closes the figure



% --------------------------------------------------------------------
function activex2_ServerChanged(hObject, eventdata, handles)
% hObject    handle to activex2 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import Analysis.IO.TDTIO.TTank.*

CloseTank(handles.activex1);
ReleaseServer(handles.activex1);
NewServer = eventdata.NewServer;

if ConnectServer(handles.activex1,NewServer,'TInterface')
    disp(['TTank Server "',NewServer,'" Connected in "TInterface".']);
else
    disp(['TTank Server "',NewServer,'" Connection Failed.']);
    errordlg(['TTank Server "',NewServer,'" Connection Failed.'],'No Server Connected');
end

handles.activex3.UseServer = NewServer;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function activex3_TankChanged(hObject, eventdata, handles)
% hObject    handle to activex3 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import Analysis.IO.TDTIO.TTank.*

CloseTank(handles.activex1);
ActTank = eventdata.ActTank;

if OpenTank(handles.activex1,ActTank,'R')
    disp(['TTank "',ActTank,'" Opened.']);
else
    disp(['TTank "',ActTank,'" Opened Failed.']);
    errordlg(['TTank "',ActTank,'" Open Failed.'],'No Tank Opened');
end

handles.activex4.UseServer = eventdata.ActServer;
handles.activex4.UseTank = ActTank;
handles.activex4.Refresh();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function activex4_BlockChanged(hObject, eventdata, handles)
% hObject    handle to activex4 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import Analysis.IO.TDTIO.TTank.* Analysis.Core.* Analysis.IO.TDTIO.*

ActServer = eventdata.ActServer;
ActTank = eventdata.ActTank;
ActBlock = eventdata.ActBlock;

if SelectBlock(handles.activex1,ActBlock,true)
    disp(['Block "',ActBlock,'" Selected.']);
    
    handles.activex5.UseServer = ActServer;
    handles.activex5.UseTank = ActTank;
    handles.activex5.UseBlock = ActBlock;
    handles.activex5.Refresh();
    % This is the new block object to read into
    blocksource.server = ActServer;
    temp = strfind(ActTank,'\');
    blocksource.tank = ActTank(temp(end)+1:end);
    cb = Block(ActBlock,blocksource);
    t1 = CurBlockStartTime(handles.activex1);
    t2 = CurBlockStopTime(handles.activex1);
    cb.startime = FancyTime(handles.activex1,t1,TGlobal.TimeFormat);
    cb.stoptime = FancyTime(handles.activex1,t2,TGlobal.TimeFormat);
    cb.duration = t2-t1;
    % set application data
    setappdata(handles.figure1,'CurrentBlock',cb);
    setappdata(handles.figure1,'ReadedEvent',[]);
else
    disp(['Block "',ActBlock,'" Selection Failed.']);
    errordlg(['Block "',ActBlock,'" Selection Failed.'],'No Block Selected');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function activex5_ActEventChanged(hObject, eventdata, handles)
% hObject    handle to activex5 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import Analysis.Core.* Analysis.Base.* Analysis.IO.TDTIO.*

ActEvent = eventdata.NewActEvent;
re = getappdata(handles.figure1,'ReadedEvent');
if isempty(strfind(re,ActEvent))
    setappdata(handles.figure1,'ReadedEvent',[ActEvent,'*',re]);
else
    return;
end
cb = getappdata(handles.figure1,'CurrentBlock');
tip = getappdata(handles.figure1,'Preferences');

edata = TTReadEvent(handles.activex1,ActEvent,tip);
if isa(edata,'EventSeries');
    cb.eventseriesgroup(end+1,1) = edata;
    if tip.isparseeventseries
        epi = ParseES(edata,tip.esformat);
        if ~isempty(epi)
            if isempty(epi.error)
                cb.config = catstruct(cb.config,epi);
            else
                errordlg(['EventSeries: ' ActEvent ' parse using ' tip.esformat ' format failed.'],...
                    epi.error);
            end
        else
            warning('EventSeries: %s can not be parsed using %s format.',ActEvent,tip.esformat);
        end
    end
end
if isa(edata,'ChannelCluster');
    cb.channelclustergroup(end+1,1) = edata;
end
if isa(edata,'EpochSeries');
    cb.epochseriesgroup(end+1,1) = edata;
end
if isa(edata,'CellAssemble');
    cb.cellassemblegroup(end+1,1) = edata;
end
setappdata(handles.figure1,'CurrentBlock',cb);
UpdateBInfo(handles);
UpdateEInfo(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function UpdateBInfo(handles)


% --------------------------------------------------------------------
function UpdateEInfo(handles)

