function varargout = Analysis(varargin)
% ANALYSIS M-file for Analysis.fig
%      ANALYSIS, by itself, creates a new ANALYSIS or raises the existing
%      singleton*.
%
%      H = ANALYSIS returns the handle to a new ANALYSIS or the handle to
%      the existing singleton*.
%
%      ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS.M with the given input arguments.
%
%      ANALYSIS('Property','Value',...) creates a new ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Analysis

% Last Modified by GUIDE v2.5 15-Jan-2013 16:11:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Analysis_OpeningFcn, ...
    'gui_OutputFcn',  @Analysis_OutputFcn, ...
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


% --- Executes just before Analysis is made visible.
function Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Analysis (see VARARGIN)

% Choose default command line output for Analysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%%% Init Options
Options = Options_Callback(hObject, eventdata, handles);

% set application data
Dinf = struct;
Data = struct;
setappdata(hObject,'Dinf',Dinf);
setappdata(hObject,'Data',Data);

% Connect Server when "Analysis" start !
if (invoke(handles.activex5,'ConnectServer','Local','Alex-Joyce'))
    Datainfo.server = 'Local';
    setappdata(hObject,'Dinf',Datainfo);
    disp('Server "Local" Connected As "Alex-Joyce" ! ');
else
    disp('Server "Local" Connection Failed ! ');
    errordlg('Server "Local" Connection Failed ! ','No Server Connected');
end

% Set default Output Dir
set(handles.activex7,'Path',Options.outputdir);
set(handles.activex7,'Path',Options.outputdir);

% Set Data Table default size
set(handles.dtable,'Data',cell(7,6));

% UIWAIT makes Analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Analysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%-------------------Menu Callback---------------------%
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile({'*.mat';'*.csv';'*.nsn';'*.*'},'MultiSelect', 'on','Open Exported Data',get(handles.activex7,'Path'));
if ~isequal(filename, 0)
    Data = ReadData(filename,pathname);
    setappdata(handles.figure1,'Data',Data);
else
    disp('No Data File Opened !');
    errordlg('No Data File Opened !','Data Open Error ');
end

function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DataSet = getappdata(handles.figure1,'Data');
DataSet.Method = 'NoMethod !';
DataSet.OutputDir = get(handles.activex7,'Path');

if isempty(eventdata)
    selection = questdlg('Do you want to save this DataSet ?',...
        'Save Data ...',...
        'Yes','No','No');
else
    selection = eventdata{1};
end

if strcmp(selection,'Yes')
    if isfield(DataSet,'Dinf') && isfield(DataSet,'Snip')
        filename=[DataSet.Dinf.tank,'__',DataSet.Dinf.block,'__',DataSet.Snip.spevent];
        filename=fullfile(DataSet.OutputDir,filename);
        save(filename,'DataSet');
    else
        disp('No Complete Data To Save !');
        warndlg('No Complete Data To Save !','Warnning');
    end
end

function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Save_Callback(hObject, eventdata, handles);
% Close Tanks and Server when "Analysis" Exit !
invoke(handles.activex5,'CloseTank');
invoke(handles.activex5,'ReleaseServer');
invoke(handles.activex6,'CloseConnection');

% close the figure
delete(handles.figure1);

function BatchExport_Callback(hObject, eventdata, handles)
% hObject    handle to BatchExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[exfilename,expathname] = uigetfile({'*.mat';'*.*'},'MultiSelect', 'off','Export All Data In Experiment',get(handles.activex7,'Path'));
if exfilename~=0 % get Experiment Info
    t1 = findstr('_',exfilename);
    t2 = findstr('.',exfilename);
    f = exfilename(1:t2(end)-1); % Experiment File Name
    id = exfilename(t1(end)+1:t2(end)-1); % Experiment ID
    Experiment = load(fullfile(expathname,exfilename));
    Experiment = Experiment.(f);
    SessionIndex = SessionList(Experiment);
    Subjects = Experiment.Subjects;
    Subjectn = length(Subjects);
    
    % Get Batch Tank Path, Block Type and Event Name
    preoptions = getappdata(handles.figure1,'Options'); % Original Options used to recover after batch
    tankpath = uigetdir(preoptions.ttankdir,'Select DataTank Directory');
    prompt = {'Block Type :','Spike Event :','Wave Event :'};
    dlg_title = 'Batch Block Type and Event Name';
    num_lines = 1;
    def = {'ALL','SP01_O','FP01'};
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
    temp = inputdlg(prompt,dlg_title,num_lines,def,options);
    blocktype = temp{1};
    spevent = temp{2};
    wvevent = temp{3};
    
    if tankpath~=0
        options = preoptions; % Current Options used to batch
        options.spikewave = 1; % Always export spike wave data
        setappdata(handles.figure1,'Options',options); % Set current batch options
        
        % Batch each subject
        for s = 1:Subjectn
            currentsubject = Subjects{s}.Name;
            currenttank = Subjects{s}.DataSet;
            set(handles.activex7,'Path',fullfile(expathname,currentsubject)); % set output dir to current subject folder
            % Select current subject datatank
            set(handles.activex2,'ActiveTank',fullfile(tankpath,currenttank));
            activex2_TankChanged(hObject, eventdata, handles);
            % Get all block names of current tank, so we can export them all
            b=1;
            blocks = []; % clear previous tank blocks;
            while true
                block = invoke(handles.activex5,'QueryBlockName',b);
                if isempty(block)
                    break;
                else
                    blocks{b} = block;
                    b = b+1;
                end
            end
            blockn = length(blocks);
            
            % retrieving all batch event data of each block of current tank
            for b = 1:blockn
                currentblock = blocks{b};
                t = findstr(')',currentblock);
                currentsession = currentblock(1:t(end)); % get block session from block name
                t = findstr('-',currentblock);
                currentblockid = currentblock(t(end)+1:end); % get block id from block name
                % select current block and get correct Mark data
                set(handles.activex3,'ActiveBlock',currentblock);
                if(activex3_BlockChanged(hObject, eventdata, handles))
                    if strcmpi(blocktype,'ALL')
                        isexport = 1;
                    else
                        DataSet = getappdata(handles.figure1,'Data'); % Current DataSet
                        if strcmpi(blocktype,DataSet.Mark.extype)
                            isexport = 1;
                        else
                            isexport = 0;
                        end
                    end
                    
                    if isexport
                        % select and get current block batch events data
                        set(handles.activex4,'ActiveEvent',spevent);
                        activex4_ActEventChanged(hObject, eventdata, handles);
                        set(handles.activex4,'ActiveEvent',wvevent);
                        activex4_ActEventChanged(hObject, eventdata, handles);
                        
                        disp(['Exporting --> ',currentsubject,'__',currenttank,'__',currentblock,' ...']);
                        DataSet = getappdata(handles.figure1,'Data'); % Current DataSet
                        
                        sub = cellfun(@(x)strcmp(x,currentsubject),SessionIndex(:,1));
                        ses = cellfun(@(x)strcmp(x.session,currentsession),SessionIndex(:,3));
                        sindex = sub&ses;
                        
                        % get unit info of each block
                        unitinfo = cell(DataSet.Snip.chn,max(DataSet.Snip.sortn));
                        for ch=1:DataSet.Snip.chn
                            for sort=1:DataSet.Snip.sortn(ch)
                                st = DataSet.Snip.snip{ch,sort}.spike;
                                ISI = isist(st);
                                spikewave = DataSet.Snip.snip{ch,sort}.spikewave{2};
                                meanspikewave = mean(spikewave,2);
                                unitinfo{ch,sort}=spikewaveinfo(meanspikewave,sort,DataSet.Snip.fs,min(ISI));
                            end
                        end
                        
                        % get current block info
                        bid_n = str2double(currentblockid);
                        SessionIndex{sindex,3}.block{bid_n}.id = bid_n;
                        SessionIndex{sindex,3}.block{bid_n}.extype = DataSet.Mark.extype;
                        SessionIndex{sindex,3}.block{bid_n}.key = DataSet.Mark.key;
                        SessionIndex{sindex,3}.block{bid_n}.ckey = DataSet.Mark.ckey;
                        SessionIndex{sindex,3}.block{bid_n}.unitinfo = unitinfo;
                        % export data
                        Save_Callback(hObject, {'Yes'}, handles);
                    end
                else
                    disp(['Batch Export Skipping On Error Block --> ',currentsubject,'__',currenttank,'__',currentblock]);
                end
            end
        end
        
        % save sessionindex file
        f = ['SessionIndex__',id,'__',blocktype,'__',spevent];
        eval([f,' = SessionIndex;']);
        save(fullfile(expathname,f),f);
        % recover to original options
        setappdata(handles.figure1,'Options',preoptions);
    else
        disp('No DataTank Directory Selected !');
        errordlg('No DataTank Directory Selected !','DataTank Directory Error');
    end
else
    disp('No Experiment File Opened !');
    errordlg('No Experiment File Opened !','Experiment File Error');
end

function Options = Options_Callback(hObject, eventdata, handles)
% hObject    handle to Options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Options = Options_Analysis;
setappdata(handles.figure1,'Options',Options);

function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
About_Analysis;

function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Help_Analysis;



%------------------ActiveX CallBacks--------------------%
function activex1_ServerChanged(hObject, eventdata, handles)
% hObject    handle to activex1 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)

invoke(handles.activex5,'CloseTank');
invoke(handles.activex5,'ReleaseServer');
ActServer = get(handles.activex1,'ActiveServer');

if invoke(handles.activex5,'ConnectServer',ActServer,'Alex-Joyce')
    Datainfo.server = ActServer;
    setappdata(handles.figure1,'Dinf',Datainfo);
    disp(['Server "',ActServer,'" Connected As "Alex-Joyce"! ']);
else
    disp(['Server "',ActServer,'" Connection Failed ! ']);
    errordlg(['Server "',ActServer,'" Connection Failed ! '],'No Server Connected');
end

set(handles.activex2,'UseServer',ActServer);
Refresh(handles.activex2);

function activex2_TankChanged(hObject, eventdata, handles)
% hObject    handle to activex2 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)

invoke(handles.activex5,'CloseTank');
ActTank = get(handles.activex2,'ActiveTank');

if (invoke(handles.activex5,'OpenTank',ActTank,'R'))
    Datainfo = getappdata(handles.figure1,'Dinf');
    
    % Get Meanningful Tank name
    temp=findstr(ActTank,'\');
    Datainfo.tank = ActTank(temp(end)+1:end);
    
    setappdata(handles.figure1,'Dinf',Datainfo);
    disp(['Tank "',ActTank,'" Opened !']);
else
    disp(['Tank "',ActTank,'" Open Failed !']);
    errordlg(['Tank "',ActTank,'" Open Failed !'],'No Tank Opened');
end

set(handles.activex3,'UseTank',ActTank);
Refresh(handles.activex3);

function hresult=activex3_BlockChanged(hObject, eventdata, handles)
% hObject    handle to activex3 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)

ActTank = get(handles.activex2,'ActiveTank');
ActBlock = get(handles.activex3,'ActiveBlock');

if(invoke(handles.activex5,'SelectBlock',ActBlock))
    disp(['Block "',ActBlock,'" Selected !']);
    
    set(handles.activex4,'UseTank',ActTank);
    set(handles.activex4,'UseBlock',ActBlock);
    Refresh(handles.activex4);
    
    Datainfo = getappdata(handles.figure1,'Dinf');
    Datainfo.block = ActBlock;
    setappdata(handles.figure1,'Dinf',Datainfo);
    
    invoke(handles.activex5,'CreateEpocIndexing');
    ProcessMark(handles,Datainfo);
    hresult = 1;
else
    disp(['Block "',ActBlock,'" Select Failed !']);
    hresult = 0;
end

function ProcessMark(handles,Datainfo)
% Get Marker Data
CMark = TTMark(handles.activex5);
% Decode MarkHead Information
CMark = MarkHead(CMark);
% Check Marker
if (strcmp(CMark.hresult,'S_OK'))
    DataSet.Dinf = Datainfo;
    DataSet.Mark = CMark;
    setappdata(handles.figure1,'Data',DataSet);
    
    keyn = size(CMark.key,1);
    ckeyn = size(CMark.ckey,1);
    row = max(keyn,ckeyn);
    data = cell(row,5);
    data(1:keyn,1:2)=CMark.key;
    data(1:ckeyn,4:5)=CMark.ckey;
    set(handles.extable,'Data',data);
else
    disp('Marker Error !');
    set(handles.extable,'Data',{'Marker Error !'});
end
set(handles.dtable,'Data',cell(7,6));

function activex4_ActEventChanged(hObject, eventdata, handles)
% hObject    handle to activex4 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)

ActEvent = get(handles.activex4,'ActiveEvent');
Options = getappdata(handles.figure1,'Options');


%======================get/set Spike/Info==========================%
S1 = findstr('S',ActEvent);
if (~isempty(S1) && (S1(1) == 1))
    
    ProcessSnip(handles,ActEvent,Options);
end


%=======================get/set LFP or Wave/Info===========================%
S1 = findstr('F',ActEvent);
S2 = findstr('W',ActEvent);
if ((~isempty(S1) && (S1(1) == 1)) || (~isempty(S2) && (S2(1) == 1)))
    
    ProcessWave(handles,ActEvent,Options);
end

function ProcessSnip(handles,ActEvent,Options)
% Get snip data
CSnip = TTSnip(handles.activex5,ActEvent,Options);
ch_n = CSnip.chn;
maxsort_n = max(CSnip.sortn);

%_______________Save Snip Data/Show Snip Info_________________%
DataSet = getappdata(handles.figure1,'Data');
DataSet.Snip = CSnip;
setappdata(handles.figure1,'Data',DataSet);


sdata = get(handles.dtable,'Data');
sdata(:,1:4)={''};
sdata{1,1} = 'Event';
sdata{1,2} = ActEvent;
sdata{2,1} = 'Fs';
sdata{2,2} = CSnip.fs;
sdata{3,1} = 'SpikeNumber';
sdata(4:3+ch_n,1:maxsort_n) = CSnip.snipn;
if Options.spikewave
    sdata{4+ch_n,1} = 'SpikeSample';
    sdata{4+ch_n,2} = CSnip.swn;
end
set(handles.dtable,'Data',sdata);

function ProcessWave(handles,ActEvent,Options)
% Get wave data
CWave = TTWave(handles.activex5,ActEvent,Options);

%_______________Save Wave Data/Show Wave Info_________________%
DataSet = getappdata(handles.figure1,'Data');
DataSet.Wave = CWave;
setappdata(handles.figure1,'Data',DataSet);


wdata = get(handles.dtable,'Data');
wdata{1,5} = 'Event';
wdata{1,6} = ActEvent;
wdata{2,5} = 'Fs';
wdata{2,6} = CWave.fs;
wdata{3,5} = 'WaveNumber';
wdata{3,6} = length(CWave.wave{1}.wave);
set(handles.dtable,'Data',wdata);



%---------------------UI CallBacks------------------------%
% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Exit_Callback(hObject, eventdata, handles);
% Hint: delete(hObject) closes the figure

% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(hObject,'Value') == 0)
    if invoke(handles.activex6,'GetSysMode')==3
        invoke(handles.activex6,'SetSysMode',0);
        invoke(handles.activex6,'CloseConnection');
    end
    
else
    if invoke(handles.activex6,'ConnectServer',get(handles.activex1,'ActiveServer'))
        if invoke(handles.activex6,'GetSysMode')<2
            invoke(handles.activex6,'SetSysMode',3);
        end
    else
        disp('TDT OpenWorkbench Server Not Ready !');
        errordlg('TDT OpenWorkbench Not Ready !','No Connection');
    end
end

% --- Executes on button press in preview.
function preview_Callback(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == 0)
    if invoke(handles.activex6,'GetSysMode')==2
        invoke(handles.activex6,'SetSysMode',0);
        invoke(handles.activex6,'CloseConnection');
    end
    
else
    if invoke(handles.activex6,'ConnectServer',get(handles.activex1,'ActiveServer'))
        if invoke(handles.activex6,'GetSysMode')<2
            invoke(handles.activex6,'SetSysMode',2);
        end
    else
        disp('TDT OpenWorkbench Server Not Ready !');
        errordlg('TDT OpenWorkbench Not Ready !','No Connection');
    end
end

% --- Executes on button press in off_analysis.
function off_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to off_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DataSet = getappdata(handles.figure1,'Data');

if ( isfield(DataSet,'Mark') || ( isfield(DataSet,'Snip') || isfield(DataSet,'Wave') ) )
    
    contents = get(handles.method,'String');
    
    if isempty(eventdata)
        DataSet.Method = contents{get(handles.method,'Value')};
    else
        DataSet.Method = eventdata{1};
    end
    
    DataSet.OutputDir = get(handles.activex7,'Path');
    
    MethodGate(DataSet,eventdata(2:end));
else
    disp('Needed Data Incomplete !');
    errordlg('Needed Data Incomplete !','Data Error');
end

% --- Executes on button press in on_analysis.
function on_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to on_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Dinf.server = get(handles.activex1,'ActiveServer');
Dinf.tank = get(handles.activex2,'ActiveTank');

if invoke(handles.activex6,'ConnectServer',Dinf.server)
    if invoke(handles.activex6,'GetSysMode')>1
        if ~strcmp(Dinf.tank,'')
            Dinf.block = invoke(handles.activex5,'GetHotBlock');
            if ~strcmp(Dinf.block,'')
                %BIsim;
                %BIData();
                BrainInterface(Dinf);
            else
                disp('Selected Tank Not the Active one, Reselect !');
                warndlg('Selected Tank Not the Active one, Reselect !','Tank Not Active');
            end
        else
            disp('Select the Online Tank to begin !');
            warndlg('Select the Online Tank to begin !','No Tank Selected');
        end
    else
        disp('TDT OpenWorkbench Not Running !');
        warndlg('TDT OpenWorkbench Not Running !','Not Active');
    end
else
    disp('TDT OpenWorkbench Server Not Ready !');
    warndlg('TDT OpenWorkbench Not Ready !','No Connection');
end

% --- Executes on selection change in method.
function method_Callback(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
