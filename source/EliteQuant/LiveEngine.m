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

% Last Modified by GUIDE v2.5 28-Jan-2018 20:22:55

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

% Tab group
handles.tabManager = TabManager(hObject);
% Set-up a selection changed function on the create tab groups
tabGroups = handles.tabManager.TabGroups;
% for tgi=1:length(tabGroups)
%     set(tabGroups(tgi),'SelectionChangedFcn',@tabChangedCB)
% end

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

config_yaml = yaml.ReadYaml('server/config.yaml');
handles.symbols = config_yaml.tickers;
handles.msginTimer = timer('ExecutionMode','FixedRate',...
                'Period',0.1,...
                'TimerFcn',@(~,~) updateUI(handles));

% UIWAIT makes LiveEngine wait for user response (see UIRESUME)
% uiwait(handles.mainWindow);

%set(handles.tblMarketData, 'RowName', handles.symbols);
%set(handles.tblMarketData, 'data', {});
mktData = get(handles.tblMarketData,'Data');
mktData = {};
for i = 1:length(handles.symbols)
    mktData(end+1,1:15)={''}; 
    mktData(end,1) = handles.symbols(i);
end
set(handles.tblMarketData, 'data', mktData);

handles.tblLog.Data = {};
handles.tblOrder.Data = {};
handles.tblFill.Data = {};
handles.tblPosition.Data = {};
handles.tblAccount.Data = {};
handles.tblStrategy.Data = {};

guidata(hObject, handles);
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

%**********************************************************************%
%%------------------------ Callback ----------------------------------%%
%**********************************************************************%
% Called when a user clicks on a tab
function tabChangedCB(src, eventdata)
disp(['Changing tab from ' eventdata.OldValue.Title ' to ' eventdata.NewValue.Title ] );

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


% --- Executes on button press in btnPlaceOrder.
function btnPlaceOrder_Callback(hObject, eventdata, handles)
% hObject    handle to btnPlaceOrder (see GCB)O
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%q = str2num(char(get(handles.editq,'String')));
symbol = get(handles.tbSymbol,'String');
otype = get(handles.popupmenuordertype,'Value');
oflag = get(handles.popupmenuorderflag,'Value');

size = get(handles.tbSize,'String');

if (otype == 1)
    ostr = ['o|MKT|' symbol '|' size '|' int2str(oflag-1)];
else
    price = get(handles.tbPrice,'String');
    ostr = ['o|LMT|' symbol '|' size '|' price '|' int2str(oflag-1)];
end

disp(ostr);
msg = zmq.Msg(uint8(ostr));
handles.socket2.send(msg,1);

% --- Executes on selection change in popupmenuordertype.
function popupmenuordertype_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuordertype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuordertype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuordertype


% --- Executes during object creation, after setting all properties.
function popupmenuordertype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuordertype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuorderflag.
function popupmenuorderflag_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuorderflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuorderflag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuorderflag


% --- Executes during object creation, after setting all properties.
function popupmenuorderflag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuorderflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbPrice_Callback(hObject, eventdata, handles)
% hObject    handle to tbPrice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbPrice as text
%        str2double(get(hObject,'String')) returns contents of tbPrice as a double


% --- Executes during object creation, after setting all properties.
function tbPrice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbPrice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbOrderID_Callback(hObject, eventdata, handles)
% hObject    handle to tbOrderID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbOrderID as text
%        str2double(get(hObject,'String')) returns contents of tbOrderID as a double


% --- Executes during object creation, after setting all properties.
function tbOrderID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbOrderID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnCancelOrder.
function btnCancelOrder_Callback(hObject, eventdata, handles)
% hObject    handle to btnCancelOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

oid = get(handles.tbOrderID,'String');
ostr = ['c|' oid];

disp(ostr);
msg = zmq.Msg(uint8(ostr));
handles.socket2.send(msg,1);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
    
    % order grid: if exist order id, update; otherwise add one
    v = strsplit(msg{1}, '|');
    if (v{1} == 's')
        if isempty(handles.tblOrder.Data)
            handles.tblOrder.Data = {v{2}, '', '', v{3}};
        else
            oidx = find(not(cellfun('isempty', strfind(handles.tblOrder.Data(:,1),v{2}))));
            if isempty(oidx)  % add
                handles.tblOrder.Data = [{v{2}, '', '', char(OrderStatus(str2num(v{3})))}; handles.tblOrder.Data];
            else
                handles.tblOrder.Data{oidx, 4} = char(OrderStatus(str2num(v{3})));
            end
        end
    elseif (v{1}=='f')
        handles.tblFill.Data = [{v{2}, '', v{3}, v{4}, v{5}}; handles.tblFill.Data];
        oidx = find(not(cellfun('isempty', strfind(handles.tblOrder.Data(:,1),v{2}))));
        handles.tblOrder.Data{oidx, 4} = char(OrderStatus(6));
    end 
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



function tbName_Callback(hObject, eventdata, handles)
% hObject    handle to tbName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbName as text
%        str2double(get(hObject,'String')) returns contents of tbName as a double


% --- Executes during object creation, after setting all properties.
function tbName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenusectype.
function popupmenusectype_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenusectype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenusectype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenusectype


% --- Executes during object creation, after setting all properties.
function popupmenusectype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenusectype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenudirection.
function popupmenudirection_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenudirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenudirection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenudirection


% --- Executes during object creation, after setting all properties.
function popupmenudirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenudirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuexchange.
function popupmenuexchange_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuexchange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuexchange contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuexchange


% --- Executes during object creation, after setting all properties.
function popupmenuexchange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuexchange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuaccount.
function popupmenuaccount_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuaccount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuaccount contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuaccount


% --- Executes during object creation, after setting all properties.
function popupmenuaccount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuaccount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnStartStrategy.
function btnStartStrategy_Callback(hObject, eventdata, handles)
% hObject    handle to btnStartStrategy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnPauseStrategy.
function btnPauseStrategy_Callback(hObject, eventdata, handles)
% hObject    handle to btnPauseStrategy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnStopStrategy.
function btnStopStrategy_Callback(hObject, eventdata, handles)
% hObject    handle to btnStopStrategy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnClearStrategy.
function btnClearStrategy_Callback(hObject, eventdata, handles)
% hObject    handle to btnClearStrategy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
