function varargout = ReduccionDimensional(varargin)
% REDUCCIONDIMENSIONAL MATLAB code for ReduccionDimensional.fig

% Edit the above text to modify the response to help ReduccionDimensional

% Last Modified by GUIDE v2.5 11-Sep-2019 18:14:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ReduccionDimensional_OpeningFcn, ...
                   'gui_OutputFcn',  @ReduccionDimensional_OutputFcn, ...
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


% --- Executes just before ReduccionDimensional is made visible.
function ReduccionDimensional_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ReduccionDimensional (see VARARGIN)

% Choose default command line output for ReduccionDimensional
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ReduccionDimensional wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ReduccionDimensional_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1

if get(handles.radiobutton1,'Value') == 1
    set(handles.radiobutton2,'Value',0);
end

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton2

if get(handles.radiobutton2,'Value') == 1
    set(handles.radiobutton1,'Value', 0);
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Abrir archivo
global Spikes Coactividad
[archivo, ubicacion]=uigetfile('.mat');
cd(ubicacion)
x=load(archivo);
xx=cellfun(@double,struct2cell(x),'uni',false);
Spikes=xx{1};

clc,
ax1 = figure(1);
subplot(211)
imagesc(Spikes,[0,1]); 
colormap(ax1, [1 1 1; 0 0 0]);
title('Raster')
Coactividad = sum(Spikes);

subplot(212);
plot(Coactividad,'r')
pks = findpeaks(Coactividad);
findpeaks(Coactividad)
title ('Picos de coactividad')

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton3
if get(handles.radiobutton3,'Value') == 1
    set(handles.radiobutton4,'Value',0);
end

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton4
if get(handles.radiobutton4,'Value') == 1
    set(handles.radiobutton3,'Value',0);
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Ejecutar analisis
global Spikes Coactividad

% Reducción dimensional
if get(handles.radiobutton1,'Value')==1 %tSNE
    Y = tsne(Spikes','Algorithm','exact','Distance','euclidean');
    
    if get(handles.radiobutton3,'Value')==1 % Clustering jerárquico
        MatrizDistancias = pdist(Spikes');
        MatrizDistancias2 = squareform(MatrizDistancias);
        MatrizDistancias3 = linkage(MatrizDistancias2,'ward');
        
        figure(2)
        clf
        subplot(211)
        scatter(Y(:,1),Y(:,2),50,'fill')
        title('TSNE')
        subplot(212)
        dendrogram(MatrizDistancias3,0,'Orientation','left') %Variar el valor
        title('Dendograma de Similitud')
        
        respuesta=inputdlg('Seleccionar el número de grupos');
        f=str2num(respuesta{1});
        
        idz=cluster(MatrizDistancias3,'MaxClust',f);
        
        clf
        subplot(311)
        scatter(Y(:,1),Y(:,2),100,idz,'fill')
        title('TSNE-Clustering jerárquico')
        B = rand(f,3);
        colormap(B)

        for i = 1:f
            r =  idz == i;
            for ii = 1:length(Coactividad)
                if r (ii) == 1
                    rr(i,ii) = Coactividad(ii);
                else 
                    rr(i,ii) = min(Coactividad);
                end
            end
        end

        subplot(312)
        for t=1:f
            plot(rr(t,:),'Color',B(t,:))
            hold on
        end
        title('Correspondencia de lugar')
        
        subplot(313)
        dendrogram(MatrizDistancias3,0,'Orientation','left')
        title('Dendograma de Similitud')

    elseif get(handles.radiobutton4,'Value')==1; %k-means
        
        figure(2)
        clf
        scatter(Y(:,1),Y(:,2),100,'fill')
        title('TSNE')
        
        respuesta=inputdlg('Seleccionar el número de grupos');
        f=str2num(respuesta{1});
        
        idz = kmeans ([Spikes'],f);
        
        figure(2)
        clf
        subplot(211)
        scatter(Y(:,1),Y(:,2),100,idz,'fill')
        title('TSNE-Kmeans')
        R = rand(f,3);
        colormap(R)

        for i = 1:f
            r =  idz == i;
            for ii = 1:length(Coactividad)
                if r (ii) == 1
                    rr(i,ii) = Coactividad(ii);
                else 
                    rr(i,ii) = min(Coactividad);
                end
            end
        end

        subplot(212)
        for t=1:f
            plot(rr(t,:),'Color',R(t,:))
            hold on
        end
        title('Correspondencia de lugar')
    end
    
elseif get(handles.radiobutton2,'Value')==1 %PCA
    [~,espigasPCA] = pca(Spikes');
    Componente1 = espigasPCA(:,1);
    Componente2 = espigasPCA(:,2);
%     Componente3 = espigasPCA(:,3);

    if get(handles.radiobutton3,'Value')==1 % Clustering jerárquico
        MatrizDistancias = pdist(Spikes');
        MatrizDistancias2 = squareform(MatrizDistancias);
        MatrizDistancias3 = linkage(MatrizDistancias2,'ward');
        
        figure(2)
        clf
        subplot(211)
        scatter(Componente1,Componente2,50,'fill')
        title('PCA')
        subplot(212)
        dendrogram(MatrizDistancias3,0,'Orientation','left') %Variar el valor
        title('Dendograma de Similitud')
        
        respuesta=inputdlg('Seleccionar el número de grupos');
        f=str2num(respuesta{1});
        
        idz=cluster(MatrizDistancias3,'MaxClust',f);
        
        clf
        subplot(311)
        scatter(Componente1,Componente2,100,idz,'fill')
        title('PCA-Clustering jerárquico')
        B = rand(f,3);
        colormap(B)

        for i = 1:f
            r =  idz == i;
            for ii = 1:length(Coactividad)
                if r (ii) == 1
                    rr(i,ii) = Coactividad(ii);
                else 
                    rr(i,ii) = min(Coactividad);
                end
            end
        end

        subplot(312)
        for t=1:f
            plot(rr(t,:),'Color',B(t,:))
            hold on
        end
        title('Correspondencia de lugar')
        
        subplot(313)
        dendrogram(MatrizDistancias3,0,'Orientation','left')
        title('Dendograma de Similitud')

    elseif get(handles.radiobutton4,'Value')==1; %k-means
        
        figure(2)
        clf
        scatter(Componente1,Componente2,100,'fill')
        title('PCA')
        
        respuesta=inputdlg('Seleccionar el número de grupos');
        f=str2num(respuesta{1});
        
        idz = kmeans (Spikes',f);
        
        figure(2)
        clf
        subplot(211)
        scatter(Componente1,Componente2,100,idz,'fill')
        title('PCA-Kmeans')
        R = rand(f,3);
        colormap(R)

        for i = 1:f
            r =  idz == i;
            for ii = 1:length(Coactividad)
                if r (ii) == 1
                    rr(i,ii) = Coactividad(ii);
                else 
                    rr(i,ii) = min(Coactividad);
                end
            end
        end

        subplot(212)
        for t=1:f
            plot(rr(t,:),'Color',R(t,:))
            hold on
        end
        title('Correspondencia de lugar')
    end

end
