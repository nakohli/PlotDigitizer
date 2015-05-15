function varargout = digitizer_rev6(varargin)
% DIGITIZER_REV6 MATLAB code for digitizer_rev6.fig
%      DIGITIZER_REV6, by itself, creates a new DIGITIZER_REV6 or raises the existing
%      singleton*.
%
%      H = DIGITIZER_REV6 returns the handle to a new DIGITIZER_REV6 or the handle to
%      the existing singleton*.
%
%      DIGITIZER_REV6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIGITIZER_REV6.M with the given input arguments.
%
%      DIGITIZER_REV6('Property','Value',...) creates a new DIGITIZER_REV6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before digitizer_rev6_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to digitizer_rev6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help digitizer_rev6

% Last Modified by GUIDE v2.5 05-May-2015 16:49:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @digitizer_rev6_OpeningFcn, ...
    'gui_OutputFcn',  @digitizer_rev6_OutputFcn, ...
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

% --- Executes just before digitizer_rev6 is made visible.
function digitizer_rev6_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to digitizer_rev6 (see VARARGIN)

% Choose default command line output for digitizer_rev6
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes digitizer_rev6 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

clc
clearvars -global

set(handles.axes1,'xtick',[],'ytick',[],'Box','on')
set(handles.axes3,'xtick',[],'ytick',[],'Box','on')
str=sprintf('Load image using the above toolbar.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')

global IMAGES options
IMAGES.original = [];
IMAGES.current = [];
IMAGES.filtered = [];
IMAGES.previous = [];
IMAGES.enhanced = [];
options.z.fac = 0.1;
options.erase = 0;
options.filterColor = [];
options.bg = [255 255 255];
options.angon = 0;
options.diston = 0;
options.FinalData = [];
options.scale.xminp=NaN;
options.scale.xmaxp=NaN;
options.scale.yminp=NaN;
options.scale.ymaxp=NaN;
options.plothands = NaN;
options.undoenable = 0;
options.undo = 0;
options.reset = 0;
options.filteron = 0;
options.erase=0;
options.addptson = 0;

set(handles.slider1,'Min',1,'Max',10,'Value',8);
options.z.val=get(handles.slider1,'Value');

set(handles.denoiseslider,'Min',1,'Max',5,'Value',2);
options.enhance.denoiseval=get(handles.denoiseslider,'Value');
set(handles.deblurslider,'Min',0.1,'Max',2,'Value',0.2);
options.enhance.deblurval=get(handles.deblurslider,'Value');

set(handles.ValueInput,'String','NaN')
set(handles.axischeckbox,'Visible','off')
set(handles.datacheckbox,'Visible','off')
set(handles.filterradio,'Visible','off')
set(handles.enhancedradio,'Visible','off')
set(handles.uipanel9,'Visible','off')
set(handles.uipanel10,'Visible','off')
set(handles.uipanel11,'Visible','off')
set(handles.uipanel12,'Visible','off')
set(handles.uipanel13,'Visible','off')
set(handles.uipanel14,'Visible','off')
set(handles.singleaxischeck,'Visible','off')

% --- Outputs from this function are returned to the command line.
function varargout = digitizer_rev6_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in toolbar icon folder open
function OpenImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to OpenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global IMAGES options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

[filename, pathname] = uigetfile( ...
    {'*.jpg;*.tif;*.gif;*.png;*.bmp', ...
    'All MATLAB Image Files (*.jpg,*.tif,*.gif,*.png,*.bmp)'; ...
    '*.jpg;*.jpeg', ...
    'JPEG Files (*.jpg,*.jpeg)'; ...
    '*.tif;*.tiff', ...
    'TIFF Files (*.tif,*.tiff)'; ...
    '*.gif', ...
    'GIF Files (*.gif)'; ...
    '*.png', ...
    'PNG Files (*.png)'; ...
    '*.bmp', ...
    'Bitmap Files (*.bmp)'; ...
    '*.*', ...
    'All Files (*.*)'}, ...
    'Select image file');
if isequal(filename,0) || isequal(pathname,0)
    set(handles.OpenImage,'State','off')
    return
else
    set(handles.OpenImage,'State','off')
    imagename = fullfile(pathname, filename);
end

IMAGES.original = imread(imagename);
IMAGES.current = IMAGES.original;
IMAGES.filtered = IMAGES.original;
IMAGES.previous = IMAGES.original;
IMAGES.enhanced = IMAGES.original;
IMAGES.binarymap = false(size(IMAGES.original,1),size(IMAGES.original,2));

MainPlotting(hObject, eventdata, handles)

str=sprintf('Set the scale using x/y min/max buttons.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')

set(handles.plottext,'Visible','off')
set(handles.zplottext,'Visible','off')
set(handles.imresetbutt,'Visible','on')
set(handles.xminbutt,'Visible','on')
set(handles.xmaxbutt,'Visible','on')
set(handles.yminbutt,'Visible','on')
set(handles.ymaxbutt,'Visible','on')
set(handles.enhance,'Visible','on')
set(handles.plotops,'Visible','on')
set(handles.uipanel9,'Visible','on')
set(handles.uipanel10,'Visible','on')
set(handles.uipanel11,'Visible','on')
set(handles.uipanel12,'Visible','on')
set(handles.singleaxischeck,'Visible','on')
set(handles.originalradio,'Value',1)

MainPlotting(hObject, eventdata, handles)

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options
options.z.val=get(handles.slider1,'Value');

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global IMAGES options

inside=0;

if isfield(IMAGES,'current') && isempty(IMAGES.current)~=1
    xlim=get(handles.axes1,'XLim');
    ylim=get(handles.axes1,'YLim');
    pos=get(handles.axes1,'currentpoint');
    xdom=(xlim(2)-xlim(1))*((options.z.val-1)*(options.z.fac/10-1)/(10-1)+1);
    ydom=(ylim(2)-ylim(1))*((options.z.val-1)*(options.z.fac/10-1)/(10-1)+1);
    if      pos(1,1)>xlim(1) && ...
            pos(1,1)<xlim(2) && ...
            pos(1,2)>ylim(1) && ...
            pos(1,2)<ylim(2)
        inside=1;
    end
    if inside==1
        %         if strcmp( get(handles.figure1,'selectionType') , 'alt') && options.erase == 1
        %             str=sprintf('Erasing...');
        %             set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
        % %             set( handles.figure1 , 'Pointer' , 'circle' );
        % %             pos=get(handles.axes1,'currentpoint');
        %
        %         else
        set(gcf,'pointer','crosshair')
        axes(handles.axes3);
        imshow(IMAGES.current,[]);
        set(handles.axes3,...
            'xlim',[pos(1,1)-xdom/2,pos(1,1)+xdom/2],...
            'ylim',[pos(1,2)-ydom/2,pos(1,2)+ydom/2])
        hold on; plot([pos(1,1),pos(1,1)],...
            [pos(1,2)-ydom/2,pos(1,2)+ydom/2],'r-'); hold off
        hold on; plot([pos(1,1)-xdom/2,pos(1,1)+xdom/2],...
            [pos(1,2) pos(1,2)],'r-'); hold off
        %             if get(handles.datacheckbox,'Value')==1
        %                 try
        %                     options.ptsz=...
        %                         plot(options.ptscoords(:,1),options.ptscoords(:,2),'+b',...
        %                         options.ptscoords(:,1),options.ptscoords(:,2),'.b');
        %                     set(options.ptsz,'MarkerSize',10);
        %                 catch
        %                 end
        %             else
        %                 try
        %                     delete(options.ptsz)
        %                 catch
        %                 end
        %             end
        drawnow
        %         end
    else
        set(gcf,'pointer','arrow')
    end
    
    
end

% --- Executes on button press in xminbutt.
function xminbutt_Callback(hObject, eventdata, handles)
% hObject    handle to xminbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

str=sprintf('Click on a known minimum x location.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
set(handles.xminvtext,'Visible','off')
if isfield(options.plothands,'xminline')==1
    try
        delete(options.plothands.xminline)
    catch
    end
end
options.scale.xminp=NaN;
while isnan(options.scale.xminp)==1
    pti=impoint(handles.axes1);
    pt=pti.getPosition();
    options.scale.xminp=pt(1);
    drawnow
end
delete(pti)
axes(handles.axes1); hold on
ylim=get(handles.axes1,'YLim');
options.plothands.xminline=line([pt(1) pt(1)],[ylim(1) ylim(2)]);
set(options.plothands.xminline,'linestyle',':','color','r')
hold off
drawnow

options.scale.xminv=NaN;
set(handles.ValueInput,'Visible','on')
str='Enter known minimum x value in input box.';
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
while isnan(options.scale.xminv)==1
    drawnow
    uicontrol(handles.ValueInput)
    ValueInput_Callback(hObject, eventdata, handles);
    options.scale.xminv=str2double(get(handles.ValueInput,'String'));
end
set(handles.ValueInput,'String','NaN')
uicontrol(handles.ValueInput)
set(handles.ValueInput,'Visible','off')
set(handles.xminvtext,'Visible','on')
set(handles.xminvtext,'String',num2str(options.scale.xminv))
scaling(hObject, eventdata, handles)

% --- Executes on button press in xmaxbutt.
function xmaxbutt_Callback(hObject, eventdata, handles)
% hObject    handle to xmaxbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

str=sprintf('Click on a known maximum x location.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
set(handles.xmaxvtext,'Visible','off')

if isfield(options.plothands,'xmaxline')==1
    try
        delete(options.plothands.xmaxline)
    catch
    end
end
options.scale.xmaxp=NaN;
while isnan(options.scale.xmaxp)==1
    pti=impoint(handles.axes1);
    pt=pti.getPosition();
    options.scale.xmaxp=pt(1);
    drawnow
end
delete(pti)
axes(handles.axes1); hold on
ylim=get(handles.axes1,'YLim');
options.plothands.xmaxline=line([pt(1) pt(1)],[ylim(1) ylim(2)]);
set(options.plothands.xmaxline,'linestyle',':','color','r')
hold off
drawnow

options.scale.xmaxv=NaN;
set(handles.ValueInput,'Visible','on')
str='Enter known maximum x value in input box.';
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
while isnan(options.scale.xmaxv)==1
    drawnow
    uicontrol(handles.ValueInput)
    ValueInput_Callback(hObject, eventdata, handles);
    options.scale.xmaxv=str2double(get(handles.ValueInput,'String'));
end
set(handles.ValueInput,'String','NaN')
set(handles.ValueInput,'Visible','off')
set(handles.xmaxvtext,'Visible','on')
set(handles.xmaxvtext,'String',num2str(options.scale.xmaxv))
scaling(hObject, eventdata, handles)

% --- Executes on button press in yminbutt.
function yminbutt_Callback(hObject, eventdata, handles)
% hObject    handle to yminbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

str=sprintf('Click on a known minimum y location.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
set(handles.yminvtext,'Visible','off')

if isfield(options.plothands,'yminline')==1
    try
        delete(options.plothands.yminline)
    catch
    end
end
options.scale.yminp=NaN;
while isnan(options.scale.yminp)==1
    pti=impoint(handles.axes1);
    pt=pti.getPosition();
    options.scale.yminp=pt(2);
    drawnow
end
delete(pti)
axes(handles.axes1); hold on
xlim=get(handles.axes1,'XLim');
options.plothands.yminline=line([xlim(1) xlim(2)],[pt(2) pt(2)]);
set(options.plothands.yminline,'linestyle',':','color','r')
hold off
drawnow

options.scale.yminv=NaN;
set(handles.ValueInput,'Visible','on')
str='Enter known minimum y value in input box.';
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
while isnan(options.scale.yminv)==1
    drawnow
    uicontrol(handles.ValueInput)
    ValueInput_Callback(hObject, eventdata, handles);
    options.scale.yminv=str2double(get(handles.ValueInput,'String'));
end
set(handles.ValueInput,'String','NaN')
set(handles.ValueInput,'Visible','off')
set(handles.yminvtext,'Visible','on')
set(handles.yminvtext,'String',num2str(options.scale.yminv))
scaling(hObject, eventdata, handles)

% --- Executes on button press in ymaxbutt.
function ymaxbutt_Callback(hObject, eventdata, handles)
% hObject    handle to ymaxbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

str=sprintf('Click on a known maximum y location.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
set(handles.ymaxvtext,'Visible','off')

if isfield(options.plothands,'ymaxline')==1
    try
        delete(options.plothands.ymaxline)
    catch
    end
end
options.scale.ymaxp=NaN;
while isnan(options.scale.ymaxp)==1
    pti=impoint(handles.axes1);
    pt=pti.getPosition();
    options.scale.ymaxp=pt(2);
    drawnow
end
delete(pti)
axes(handles.axes1); hold on
xlim=get(handles.axes1,'XLim');
options.plothands.ymaxline=line([xlim(1) xlim(2)],[pt(2) pt(2)]);
set(options.plothands.ymaxline,'linestyle',':','color','r')
hold off
drawnow

options.scale.ymaxv=NaN;
set(handles.ValueInput,'Visible','on')
str='Enter known maximum y value in input box.';
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
while isnan(options.scale.ymaxv)==1
    drawnow
    uicontrol(handles.ValueInput)
    ValueInput_Callback(hObject, eventdata, handles);
    options.scale.ymaxv=str2double(get(handles.ValueInput,'String'));
end
set(handles.ValueInput,'String','NaN')
set(handles.ValueInput,'Visible','off')
set(handles.ymaxvtext,'Visible','on')
set(handles.ymaxvtext,'String',num2str(options.scale.ymaxv))
scaling(hObject, eventdata, handles)

% --- Callback to accept user text value inputs
function ValueInput_Callback(hObject, eventdata, handles)
% hObject    handle to ValueInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ValueInput as text
%        str2double(get(hObject,'String')) returns contents of ValueInput as a double

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

while 1
    if isempty(get(handles.ValueInput,'String'))==0
        return
    end
end

% --- Executes during object creation, after setting all properties.
function ValueInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ValueInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Calculates scaling based on user input axis min/max
function scaling(hObject, eventdata, handles)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options IMAGES

if get(handles.singleaxischeck,'Value') == 0
    
    if      isnan(options.scale.xminp)==1 || ...
            isnan(options.scale.xmaxp)==1 || ...
            isnan(options.scale.yminp)==1 || ...
            isnan(options.scale.ymaxp)==1
        str=sprintf('Set the scale using x/y min/max buttons as necessary.');
        set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
    else
        xp=[options.scale.xminp,options.scale.xmaxp];
        xv=[options.scale.xminv,options.scale.xmaxv];
        yp=[options.scale.yminp,options.scale.ymaxp];
        yv=[options.scale.yminv,options.scale.ymaxv];
        options.scale.xpq=get(handles.axes1,'XLim');
        options.scale.ypq=fliplr(get(handles.axes1,'YLim'));
        options.scale.xvq=interp1(xp,xv,options.scale.xpq,'linear','extrap');
        options.scale.yvq=interp1(yp,yv,options.scale.ypq,'linear','extrap');
        xrange=linspace(options.scale.xvq(1),options.scale.xvq(2),size(IMAGES.original,2));
        yrange=linspace(options.scale.yvq(1),options.scale.yvq(2),size(IMAGES.original,1));
        [options.scale.X,options.scale.Y] = meshgrid(xrange,fliplr(yrange));
        
        x0=interp1(options.scale.xvq,options.scale.xpq,0);
        y0=interp1(options.scale.yvq,options.scale.ypq,0);
        
        if x0>=options.scale.xpq(1) && x0<=options.scale.xpq(2)
            options.scale.xref=x0;
        else
            options.scale.xref=options.scale.xminp;
        end
        if y0<=options.scale.ypq(1) && y0>=options.scale.ypq(2)
            options.scale.yref=y0;
        else
            options.scale.yref=options.scale.yminp;
        end
        
        axes(handles.axes1)
        hold on; plot(options.scale.xref,options.scale.yref,'ro'); hold off
        
        str=sprintf('Scaling Complete. Continue by selecting a function.');
        set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
        set(handles.angbutt,'Visible','on')
        set(handles.distbutt,'Visible','on')
        set(handles.AutoTab,'Visible','on')
        set(handles.manselect,'Visible','on')
        set(handles.uipanel13,'Visible','on')
        set(handles.uipanel14,'Visible','on')
        
        options.angon=0;
        options.diston=0;
        
        set(handles.axischeckbox,'Visible','on')
        set(handles.axischeckbox,'Value',1)
        MainPlotting(hObject, eventdata, handles)
        
    end
    
else
    if      isnan(options.scale.xminp)==1 || ...
            isnan(options.scale.xmaxp)==1
        str=sprintf('Set the scale using x min/max buttons as necessary.');
        set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
    else
        xp=[options.scale.xminp,options.scale.xmaxp];
        xv=[options.scale.xminv,options.scale.xmaxv];
        yp=xp;%[options.scale.yminp,options.scale.ymaxp];
        yv=xv;%[options.scale.yminv,options.scale.ymaxv];
        options.scale.xpq=get(handles.axes1,'XLim');
        options.scale.ypq=fliplr(get(handles.axes1,'YLim'));
        options.scale.xvq=interp1(xp,xv,options.scale.xpq,'linear','extrap');
        options.scale.yvq=interp1(yp,yv,options.scale.ypq,'linear','extrap');
        xrange=linspace(options.scale.xvq(1),options.scale.xvq(2),size(IMAGES.original,2));
        yrange=linspace(options.scale.yvq(1),options.scale.yvq(2),size(IMAGES.original,1));
        [options.scale.X,options.scale.Y] = meshgrid(xrange,fliplr(yrange));
        
        x0=interp1(options.scale.xvq,options.scale.xpq,0);
        y0=interp1(options.scale.yvq,options.scale.ypq,0);
        
        if x0>=options.scale.xpq(1) && x0<=options.scale.xpq(2)
            options.scale.xref=x0;
        else
            options.scale.xref=options.scale.xminp;
        end
        if y0<=options.scale.ypq(1) && y0>=options.scale.ypq(2)
            options.scale.yref=y0;
        else
            options.scale.yref=options.scale.yminp;
        end
        
        axes(handles.axes1)
        hold on; plot(options.scale.xref,options.scale.yref,'ro'); hold off
        
        str=sprintf('Scaling Complete. Continue by selecting a function.');
        set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
        set(handles.angbutt,'Visible','on')
        set(handles.distbutt,'Visible','on')
        set(handles.AutoTab,'Visible','on')
        set(handles.manselect,'Visible','on')
        set(handles.uipanel13,'Visible','on')
        set(handles.uipanel14,'Visible','on')
        
        options.angon=0;
        options.diston=0;
        
        set(handles.axischeckbox,'Visible','on')
        MainPlotting(hObject, eventdata, handles)
    end
end

% --- Executes on button press in imresetbutt.
function imresetbutt_Callback(hObject, eventdata, handles)
% hObject    handle to imresetbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

options.reset=1;
if isfield(options, 'angon')
    if options.angon==1
        delete(options.plothands.angline1)
        delete(options.plothands.angline2)
        delete(options.plothands.angline3)
        delete(options.plothands.angline4)
        delete(options.plothands.angline5)
    end
    options.angon=0;
    set(handles.angbtext,'Visible','off')
    set(handles.angltext,'Visible','off')
end
if isfield(options, 'diston')
    if options.diston==1
        delete(options.plothands.distline)
    end
    options.diston=0;
    set(handles.disttext,'Visible','off')
    set(handles.distytext,'Visible','off')
    set(handles.distxtext,'Visible','off')
end

MainPlotting(hObject, eventdata, handles)

str=sprintf('Image reset. Continue by selecting a function.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')

options.reset = 0;

% --- Executes on button press in distbutt.
function distbutt_Callback(hObject, eventdata, handles)
% hObject    handle to distbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

if options.diston==1
    delete(options.plothands.distline)
end
set(handles.disttext,'Visible','off')
set(handles.distxtext,'Visible','off')
set(handles.distytext,'Visible','off')
options.diston=1;

str=sprintf('Select first point from plot.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
pt1i=impoint(handles.axes1);
pt1=pt1i.getPosition();

str=sprintf('Select second point from plot.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
pt2i=impoint(handles.axes1);
pt2=pt2i.getPosition();

options.x_diff=abs(pt1(1)-pt2(1));
options.y_diff=abs(pt1(2)-pt2(2));

options.x_diff=options.x_diff*...
    (options.scale.xvq(2)-options.scale.xvq(1))/(options.scale.xpq(2)-options.scale.xpq(1));
options.y_diff=options.y_diff*...
    (options.scale.yvq(2)-options.scale.yvq(1))/(options.scale.ypq(1)-options.scale.ypq(2));

options.dist=sqrt(options.x_diff^2+options.y_diff^2);

axes(handles.axes1);hold on
options.plothands.distline=plot([pt1(1),pt2(1)],[pt1(2),pt2(2)],'-g');
set(options.plothands.distline,'linewidth',2)
hold off
delete(pt1i)
delete(pt2i)

str=sprintf('mag=%0.2f',options.dist);
set(handles.disttext,'Visible','on','String',str)
str=sprintf('dx=%0.2f',options.x_diff);
set(handles.distxtext,'Visible','on','String',str)
str=sprintf('dy=%0.2f',options.y_diff);
set(handles.distytext,'Visible','on','String',str)

str=sprintf('Distance calculated. Select next function.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')

% --- Executes on button press in angbutt.
function angbutt_Callback(hObject, eventdata, handles)
% hObject    handle to angbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

if options.angon==1
    delete(options.plothands.angline1)
    delete(options.plothands.angline2)
    delete(options.plothands.angline3)
    delete(options.plothands.angline4)
    delete(options.plothands.angline5)
end
set(handles.angbtext,'Visible','off')
set(handles.angltext,'Visible','off')
options.angon=1;

str=sprintf('Select first point for first line from plot.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
pt1=impoint(handles.axes1);
str=sprintf('Select second point for first line from plot.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
pt2=impoint(handles.axes1);
str=sprintf('Select first point for second line from plot.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
pt3=impoint(handles.axes1);
str=sprintf('Select second point for second line from plot.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
pt4=impoint(handles.axes1);
pts=[pt1.getPosition();pt2.getPosition();pt3.getPosition();pt4.getPosition()];

axes(handles.axes1); hold on
options.plothands.angline1=plot([pts(1,1),pts(2,1)],[pts(1,2),pts(2,2)],'-b');
set(options.plothands.angline1,'linewidth',2)
options.plothands.angline2=plot([pts(3,1),pts(4,1)],[pts(3,2),pts(4,2)],'-b');
set(options.plothands.angline2,'linewidth',2)
hold off
delete(pt1)
delete(pt2)
delete(pt3)
delete(pt4)

xlim=get(handles.axes1,'XLim');
xel=xlim(1)*-10000;
xer=xlim(2)*10000;

axes(handles.axes1); hold on
m=(pts(2,2)-pts(1,2))/(pts(2,1)-pts(1,1));
options.plothands.angline3=plot([xel,xer],...
    [m*(xel-pts(1,1))+pts(1,2),m*(xer-pts(1,1))+pts(1,2)],'b--');
m=(pts(4,2)-pts(3,2))/(pts(4,1)-pts(3,1));
options.plothands.angline4=plot([xel,xer],...
    [m*(xel-pts(3,1))+pts(3,2),m*(xer-pts(3,1))+pts(3,2)],'b--');
hold off

innerds=[norm(pts(1,:)-pts(3,:),2),...
    norm(pts(1,:)-pts(4,:),2),...
    norm(pts(2,:)-pts(3,:),2),...
    norm(pts(2,:)-pts(4,:),2)];

axes(handles.axes1); hold on
if innerds(1)==min(innerds)
    options.plothands.angline5=plot([pts(1,1),pts(3,1)],[pts(1,2),pts(3,2)],'--b');
elseif innerds(2)==min(innerds)
    options.plothands.angline5=plot([pts(1,1),pts(4,1)],[pts(1,2),pts(4,2)],'--b');
elseif innerds(3)==min(innerds)
    options.plothands.angline5=plot([pts(2,1),pts(3,1)],[pts(2,2),pts(3,2)],'--b');
elseif innerds(4)==min(innerds)
    options.plothands.angline5=plot([pts(2,1),pts(4,1)],[pts(2,2),pts(4,2)],'--b');
end
hold off

options.theta = angle(pts);

str=sprintf('%0.2f',options.theta);
set(handles.angbtext,'Visible','on','String',str)
str=sprintf('%0.2f',180-options.theta);
set(handles.angltext,'Visible','on','String',str)

str=sprintf('Angle calculated. Select next function.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')

% --- Executes on button press in addptbutt.
function addptbutt_Callback(hObject, eventdata, handles)
% hObject    handle to addptbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global IMAGES options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

options.addptson = 1;
set(handles.slider1,'Value',10)
options.z.val=get(handles.slider1,'Value');
set(handles.axischeckbox,'Value',1)
str=sprintf('Continue selecting points from image. When finished, right-click to quit.');
set(handles.text1,'String',str,'FontSize',12,'FontWeight','bold')
str=sprintf('Active');
set(handles.text22,'String',str)
drawnow

options.pts = [];
i=1;
inside=0;
xlim=get(handles.axes1,'XLim');
ylim=get(handles.axes1,'YLim');
axes(handles.axes1); hold on

while 1
    
    waitforbuttonpress
    pos=get(handles.axes1,'currentpoint');
    if      pos(1,1)>xlim(1) && ...
            pos(1,1)<xlim(2) && ...
            pos(1,2)>ylim(1) && ...
            pos(1,2)<ylim(2)
        inside=1;
    end
    if strcmp(get(handles.figure1,'Selectiontype'),'normal')==1 && inside==1
        options.ptscoords(i,:) = round([pos(1,1),pos(1,2)]);
        options.pts{i}=...
            plot(options.ptscoords(i,1),options.ptscoords(i,2),'+b',...
            options.ptscoords(i,1),options.ptscoords(i,2),'or');
        set(options.pts{i},'MarkerSize',10);
        IMAGES.binarymap(options.ptscoords(i,2),options.ptscoords(i,1))=1;
        
    elseif strcmp(get(handles.figure1,'Selectiontype'),'alt')==1
        str=sprintf('Manual point selection complete. Contine by selecting a function.');
        set(handles.text1,'String',str,'FontSize',12,'FontWeight','bold')
        str=sprintf('Inactive');
        set(handles.text22,'String',str)
        break
    end
    
    inside=0;
    drawnow
    i=i+1;
end
hold off

set(handles.slider1,'Value',8)
options.z.val=get(handles.slider1,'Value');
set(handles.axischeckbox,'Value',0)

% --- Executes on button press in delptbutt.
function delptbutt_Callback(hObject, eventdata, handles)
% hObject    handle to delptbutt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global IMAGES options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

% --- Executes on button press in FilterColor.
function FilterColor_Callback(hObject, eventdata, handles)
% hObject    handle to FilterColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options IMAGES

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

set(handles.filterradio,'Visible','on')

str=sprintf('Click and drag in plot to draw a small bounding box around desired color.');
set(handles.text1,'String',str,'FontSize',12,'FontWeight','bold')
set(handles.slider1,'Value',10)
options.z.val=get(handles.slider1,'Value');
% region = imfreehand( handles.axes1 );
region = imrect(handles.axes1);
str=sprintf('Filtering...');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
drawnow
options.rectpos = getPosition(region);
mask = region.createMask(options.plothands.imcurrent);
options.filterColor = mask;

if isempty(options.filterColor)
    str=sprintf('Choose color first.');
    set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
else
    newImage = getColorPlot( IMAGES.current , options.filterColor );
    temp = rgb2gray( im2uint8( newImage ));
    temp = im2bw(temp,graythresh(temp));
    temp = bwmorph(imcomplement(temp),'skel');
    IMAGES.filtered = newImage .* repmat( temp , [1,1,3] ) ;
    for i = 1 : size( IMAGES.filtered , 1 )
        for j = 1 : size( IMAGES.filtered , 2 )
            if      ( IMAGES.filtered( i , j , 1 ) == 0 ) &&...
                    ( IMAGES.filtered( i , j , 2 ) == 0 ) &&...
                    ( IMAGES.filtered( i , j , 3 ) == 0 )
                IMAGES.filtered( i , j , : ) = [255,255,255];
            end
        end
    end
    
    options.filteron = 1;
    MainPlotting(hObject, eventdata, handles)
    options.filteron = 0;
end

data = floor(createPlotData( IMAGES.filtered , 1));
for i=1:size(data,1)
    if data(i,1)~=0 && data(i,2)~=0
        IMAGES.binarymap(data(i,1),data(i,2))=1;
    end
end

str=sprintf('Filtering complete. Continue by selecting a function. If satisfied, extract and export data.');
set(handles.text1,'String',str,'FontSize',12,'FontWeight','bold')

set(handles.slider1,'Value',8);
options.z.val=get(handles.slider1,'Value');

set(handles.ExtractPlotData,'Visible','on')

% --- Executes on button press in edgefilter.
function edgefilter_Callback(hObject, eventdata, handles)
% hObject    handle to edgefilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global IMAGES options

IMAGES.filtered = filterEdges(IMAGES.current);

options.filteron = 1;
MainPlotting(hObject, eventdata, handles)
options.filteron = 0;

data = floor(createPlotData( IMAGES.filtered , 1));
for i=1:size(data,1)
    if data(i,1)~=0 && data(i,2)~=0
        IMAGES.binarymap(data(i,1),data(i,2))=1;
    end
end

set(handles.filterradio,'Visible','on')
set(handles.ExtractPlotData,'Visible','on')

str=sprintf('Filtering complete. Continue by selecting a function. If satisfied, extract and export data.');
set(handles.text1,'String',str,'FontSize',12,'FontWeight','bold')

% --- Executes on button press in erase.
function erase_Callback(hObject, eventdata, handles)
% hObject    handle to erase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global options IMAGES

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


options.erase = 1;
str=sprintf('Active');
set(handles.erasetext,'String',str)
str=sprintf('Create rectangular region to delete. When finished, click on Erase to end function.');
region = imrect( handles.axes1 );
mask = region.createMask(options.plothands.imcurrent);
region.delete();
for i = 1 : size( mask , 1 )
    for j = 1 : size( mask , 2 )
        if mask( i , j ) == 1
            IMAGES.filtered( i , j , : )  = [255,255,255];
        end
    end
end
MainPlotting(hObject, eventdata, handles)
drawnow
set(handles.text1,'String',str,'FontSize',12,'FontWeight','bold')
options.erase=0;
str=sprintf('Inactive');
set(handles.erasetext,'String',str)
str=sprintf('Erasing complete. Continue by selecting a function.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')

IMAGES.binarymap = false( size( IMAGES.filtered,1) , size( IMAGES.filtered,2) );
data = floor(createPlotData( IMAGES.filtered , 1));
for i=1:size(data,1)
    if data(i,1)~=0 && data(i,2)~=0
        IMAGES.binarymap(data(i,1),data(i,2))=1;
    end
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase == 1
    set(handles.figure1,'selectionType' , 'normal' );
    % options.erase = 0;
    set( handles.figure1 , 'Pointer' , 'arrow' );
    str=sprintf('Continue erasing or click on Erase to finish.');
    set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
end

% --- Executes on button press in ExtractPlotData.
function ExtractPlotData_Callback(hObject, eventdata, handles)
% hObject    handle to ExtractPlotData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options IMAGES

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
end

str=sprintf('Data extracted and plot created.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')

options.Data=[];
options.DataScaled=[];
[row,col]=find(IMAGES.binarymap);
options.Data(:,1)=col;
options.Data(:,2)=row;
xtemp=options.scale.X.*IMAGES.binarymap;
ytemp=options.scale.Y.*IMAGES.binarymap;
options.DataScaled(:,1) = xtemp(xtemp~=0);
options.DataScaled(:,2) = ytemp(ytemp~=0);

set(handles.datacheckbox,'Value',1)
set(handles.filterradio,'Value',0)
if strcmp(get(handles.enhancedradio,'Visible'),'off')==1
    set(handles.originalradio,'Value',1)
else
    set(handles.enhancedradio,'Value',1)
end

% figure; imshow(logical(IMAGES.binarymap))
% figure; plot(options.DataScaled(:,1),options.DataScaled(:,2),'bo')

set(handles.export,'Visible','on')
set(handles.datacheckbox,'Visible','on')

MainPlotting(hObject, eventdata, handles)

% --- Executes on button press in export.
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

data = options.DataScaled;

[filename, pathname, filterindex] = uiputfile( ...
    {'*.mat','MAT-files (*.mat)'; ...
    '*.dat','data files (*.dat)'; ...
    '*.txt','text files (*.txt)'; ...
    '*.xlsx','Excel files (*.xlsx)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Save as');
Name = fullfile(pathname,filename);
if filterindex==1
    save(Name,'data')
elseif filterindex==2 || filterindex==3
    fileID = fopen(Name,'w');
    fprintf(fileID,'%6.3f\r\t%6.3f\r\n',data);
    fclose(fileID);
elseif filterindex==4
    xlswrite(Name,data)
end
if filterindex==0, return; end    %# or display an error message

% --- Executes on button press in denoise.
function denoise_Callback(hObject, eventdata, handles)
% hObject    handle to denoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global IMAGES options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

%lambda = filter size; integer value typically 1(no effect) to 5(heavy effect)

lambda = options.enhance.denoiseval;

str=sprintf('De-Noising...');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
drawnow

IMAGES.previous = IMAGES.current;
try
    IMAGES.current=medfilt2(IMAGES.current,[lambda,lambda]);
catch
    image_r=medfilt2(IMAGES.current(:,:,1),[lambda,lambda]);
    image_g=medfilt2(IMAGES.current(:,:,2),[lambda,lambda]);
    image_b=medfilt2(IMAGES.current(:,:,3),[lambda,lambda]);
    IMAGES.current=cat(3,image_r,image_g,image_b);
end
IMAGES.enhanced=IMAGES.current;

options.undoenable = 1;

str=sprintf('De-Noising Complete. Continue by selecting a function.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')

set(handles.enhancedradio,'Visible','on')
enhancedradio_Callback(hObject, eventdata, handles)
MainPlotting(hObject, eventdata, handles)

% --- Executes on button press in deblur.
function deblur_Callback(hObject, eventdata, handles)
% hObject    handle to deblur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global IMAGES options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

str=sprintf('De-Blurring...');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
drawnow
IMAGES.previous = IMAGES.current;

%radius = size of area of edge pixels to be sharpened
%amount = sharpening strength typically from 0(no effect) to 2(heavy effect)
IMAGES.current=imsharpen(IMAGES.current,...
    'radius',.1*mean([size(IMAGES.original,1),size(IMAGES.original,2)]),...
    'amount',options.enhance.deblurval);
IMAGES.enhanced=IMAGES.current;

str=sprintf('De-Blurring Complete. Continue by selecting a function.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')

options.undoenable = 1;

set(handles.enhancedradio,'Visible','on')
enhancedradio_Callback(hObject, eventdata, handles)
MainPlotting(hObject, eventdata, handles)

% --- Executes on slider movement.
function denoiseslider_Callback(hObject, eventdata, handles)
% hObject    handle to denoiseslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

options.enhance.denoiseval=get(handles.denoiseslider,'Value');

% --- Executes during object creation, after setting all properties.
function denoiseslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to denoiseslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function deblurslider_Callback(hObject, eventdata, handles)
% hObject    handle to deblurslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

options.enhance.deblurval=get(handles.deblurslider,'Value');

% --- Executes during object creation, after setting all properties.
function deblurslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deblurslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in ccwrotate.
function ccwrotate_Callback(hObject, eventdata, handles)
% hObject    handle to ccwrotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global IMAGES options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

IMAGES.previous = IMAGES.current;

IMAGES.current=imrotate(IMAGES.current,0.25,'bicubic','crop');
IMAGES.enhanced=IMAGES.current;

options.undoenable = 1;

set(handles.enhancedradio,'Visible','on')
enhancedradio_Callback(hObject, eventdata, handles)
MainPlotting(hObject, eventdata, handles)

str=sprintf('Continue by selecting a function.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')

% --- Executes on button press in cwrotate.
function cwrotate_Callback(hObject, eventdata, handles)
% hObject    handle to cwrotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global IMAGES options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

IMAGES.previous = IMAGES.current;

IMAGES.current=imrotate(IMAGES.current,-0.25,'bicubic','crop');
IMAGES.enhanced=IMAGES.current;

options.undoenable = 1;

set(handles.enhancedradio,'Visible','on')
enhancedradio_Callback(hObject, eventdata, handles)
MainPlotting(hObject, eventdata, handles)

str=sprintf('Continue by selecting a function.');
set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')

% --- Executes on button press in UndoLast.
function UndoLast_Callback(hObject, eventdata, handles)
% hObject    handle to UndoLast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

if options.undoenable==1
    options.undo = 1;
    MainPlotting(hObject, eventdata, handles)
    options.undo = 0;
    options.undoenable=0;
    str=sprintf('Continue by selecting a function.');
    set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
else
    str=sprintf('Only 1 undo step available. Continue by selecting a function.');
    set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
end

% --- Executes on button press in originalradio.
function originalradio_Callback(hObject, eventdata, handles)
% hObject    handle to originalradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of originalradio

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

set(handles.originalradio,'Value',1)
set(handles.enhancedradio,'Value',0)
set(handles.filterradio,'Value',0)

MainPlotting(hObject, eventdata, handles)
return

% --- Executes on button press in enhancedradio.
function enhancedradio_Callback(hObject, eventdata, handles)
% hObject    handle to enhancedradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enhancedradio

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

set(handles.originalradio,'Value',0)
set(handles.enhancedradio,'Value',1)
set(handles.filterradio,'Value',0)

MainPlotting(hObject, eventdata, handles)
return

% --- Executes on button press in filterradio.
function filterradio_Callback(hObject, eventdata, handles)
% hObject    handle to filterradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filterradio

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

set(handles.originalradio,'Value',0)
set(handles.enhancedradio,'Value',0)
set(handles.filterradio,'Value',1)

MainPlotting(hObject, eventdata, handles)
return

% --- Executes on button press in axischeckbox.
function axischeckbox_Callback(hObject, eventdata, handles)
% hObject    handle to axischeckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of axischeckbox

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

MainPlotting(hObject, eventdata, handles)

% --- Executes on button press in datacheckbox.
function datacheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to datacheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of datacheckbox

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global options

if options.erase==1
    options.erase=0;
    str=sprintf('Inactive');
    set(handles.erasetext,'String',str)
    return
end

MainPlotting(hObject, eventdata, handles)

% --- Executes to set current display depending on inputs.
function MainPlotting(hObject, eventdata, handles)
% hObject    handle to UndoLast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

global IMAGES options

if options.reset==1
    set(handles.originalradio,'Value',1)
    set(handles.enhancedradio,'Value',0)
    set(handles.filterradio,'Value',0)
elseif options.filteron==1
    set(handles.originalradio,'Value',0)
    set(handles.enhancedradio,'Value',0)
    set(handles.filterradio,'Value',1)
elseif options.erase==1
    set(handles.originalradio,'Value',0)
    set(handles.enhancedradio,'Value',0)
    set(handles.filterradio,'Value',1)
end

if get(handles.originalradio,'Value')==1
    IMAGES.current = IMAGES.original;
elseif get(handles.enhancedradio,'Value')==1
    if options.undo==1
        IMAGES.enhanced = IMAGES.previous;
        IMAGES.current = IMAGES.enhanced;
    else
        IMAGES.current = IMAGES.enhanced;
    end
elseif get(handles.filterradio,'Value')==1
    IMAGES.current = IMAGES.filtered;
end

axes(handles.axes1)
options.plothands.imcurrent=imshow(IMAGES.current);

hold on
if get(handles.axischeckbox,'Value')==1
    ylimits = get(handles.axes1,'YLim');
    options.plothands.xrefline = plot([options.scale.xref,...
        options.scale.xref],[ylimits(1),ylimits(2)]);
    set(options.plothands.xrefline,'linewidth',2,'color',[1,0,0])
    xlimits = get(handles.axes1,'XLim');
    options.plothands.yrefline = plot([xlimits(1),xlimits(2)],...
        [options.scale.yref,options.scale.yref]);
    set(options.plothands.yrefline,'linewidth',2,'color',[1,0,0])
else
    try
        delete(options.plothands.xrefline)
    catch
    end
end
if get(handles.datacheckbox,'Value')==1
    options.plothands.data =...
        plot(options.Data(:,1),options.Data(:,2),'bo');
else
    try
        delete(options.plothands.data)
    catch
    end
end
return

% --- Executes on button press in singleaxischeck.
function singleaxischeck_Callback(hObject, eventdata, handles)
% hObject    handle to singleaxischeck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of singleaxischeck

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

if get(handles.singleaxischeck,'Value')==0
    str=sprintf('Set the scale using x/y min/max buttons as necessary.');
    set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
    set(handles.uipanel11,'Visible','on')
    set(handles.uipanel12,'Visible','on')
else
    str=sprintf('Set the scale using x min/max buttons as necessary.');
    set(handles.text1,'String',str,'FontSize',14,'FontWeight','bold')
    set(handles.uipanel11,'Visible','off')
    set(handles.uipanel12,'Visible','off')
end
