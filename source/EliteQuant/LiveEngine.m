function varargout = LiveEngine(varargin)
% LIVEENGINE MATLAB code for LiveEngine.fig
%      LIVEENGINE, by itself, creates a new LIVEENGINE or raises the existing
%      singleton*.
%
%      H = LIVEENGINE returns the handle to a new LIVEENGINE or the handle to
%      the existing singleton*.
%
%      LIVEENGINE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LIVEENGINE.M with the given input arguments.
%
%      LIVEENGINE('Property','Value',...) creates a new LIVEENGINE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LiveEngine_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LiveEngine_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LiveEngine

% Last Modified by GUIDE v2.5 19-Oct-2017 23:25:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LiveEngine_OpeningFcn, ...
                   'gui_OutputFcn',  @LiveEngine_OutputFcn, ...
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


% --- Executes just before LiveEngine is made visible.
function LiveEngine_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LiveEngine (see VARARGIN)

% Choose default command line output for LiveEngine
handles.output = hObject;

% Update handles structure
%javaaddpath('D:\Workspace\EliteQuant_Matlab\source\jnacl-0.1.0.jar');
%javaaddpath('D:\Workspace\EliteQuant_Matlab\source\jeromq-0.4.2.jar');
import org.zeromq.ZMQ;

handles.ctx = ZMQ.context(1);
handles.socket = handles.ctx.socket(ZMQ.SUB);
handles.socket.connect('tcp://127.0.0.1:55559'); 
handles.socket.subscribe('');

handles.ctx2 = zmq.Ctx();
handles.socket2 = handles.ctx2.createSocket(ZMQ.PAIR);
handles.socket2.connect('tcp://127.0.0.1:55558'); 

config_yaml = yaml.ReadYaml('config.yaml');
handles.symbols = config_yaml.tickers;
handles.colNames = {'Bid Size', 'Bid', 'Ask Size', 'Ask', 'Last', 'Last Size'};
handles.msginTimer = timer('ExecutionMode','FixedRate',...
                'Period',0.1,...
                'TimerFcn',@(~,~) updateUI(handles));

guidata(hObject, handles);

% UIWAIT makes LiveEngine wait for user response (see UIRESUME)
% uiwait(handles.mainWindow);
set(handles.tblMarketData, 'ColumnName', handles.colNames);
set(handles.tblMarketData, 'RowName', handles.symbols);

start(handles.msginTimer);

% --- Outputs from this function are returned to the command line.
function varargout = LiveEngine_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in lbMessage.
function lbMessage_Callback(hObject, eventdata, handles)
% hObject    handle to lbMessage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbMessage contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbMessage


% --- Executes during object creation, after setting all properties.
function lbMessage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbMessage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbSymbol_Callback(hObject, eventdata, handles)
% hObject    handle to tbSymbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbSymbol as text
%        str2double(get(hObject,'String')) returns contents of tbSymbol as a double


% --- Executes during object creation, after setting all properties.
function tbSymbol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbSymbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbSize_Callback(hObject, eventdata, handles)
% hObject    handle to tbSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbSize as text
%        str2double(get(hObject,'String')) returns contents of tbSize as a double


% --- Executes during object creation, after setting all properties.
function tbSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSubmitOrder.
function btnSubmitOrder_Callback(hObject, eventdata, handles)
% hObject    handle to btnSubmitOrder (see GCB)O
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%q = str2num(char(get(handles.editq,'String')));
symbol = get(handles.tbSymbol,'String');
size = get(handles.tbSize,'String');
ostr = ['o|MKT|' symbol '|' size];
disp(ostr);
msg = zmq.Msg(uint8(ostr));
handles.socket2.send(msg,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Timer Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function updateUI(handles)
message = handles.socket.recv(1);
if ~isempty(message)
    msg = message;
    msg(msg==32) = 95;         % replace space with underscore
    msg = join(cellstr(native2unicode(msg)),'');
    v = strsplit(msg{1}, '|');
    
    if ((v{3} == '0') || (v{3} == '2') || (v{3} == '4'))  %  bid/ask/last price
        sym = strrep(v{1},'_',' ');
        idx = find(strcmp(handles.symbols, sym) == 1);
        if (~isempty(idx))
            handles.tblMarketData.Data{idx,5} = v{4};
        end
    end
end

message = handles.socket2.recv(1);
if ~isempty(message)
    msg = message.data;
    msg(msg==32) = 95;         % replace space with underscore
    msg = join(cellstr(native2unicode(msg)),'');
    
    tmpstr = get(handles.lbMessage, 'string');
    if (isempty(tmpstr))
        tmpstr = msg;
    else
        tmpstr(end+1,1) = msg;
    end
    set(handles.lbMessage, 'string', tmpstr);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End of Timer Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes when user attempts to close mainWindow.
function mainWindow_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mainWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure


%handles.socket.close();
%handles.ctx.close();
handles.socket2.termEndpoint('tcp://127.0.0.1:55558');
handles.socket2.close();
handles.ctx2.terminate();

% timerfind
stop(handles.msginTimer);
delete(handles.msginTimer);

delete(hObject);
