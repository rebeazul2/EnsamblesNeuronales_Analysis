%% --------------------------------Rebeca Hernández Soto, INB-UNAM, Agosto-2019------------------------------------------
%%                      Incialmente se selecciona la senial LFP que se requiere analizar en formato
%%                                            .mat, tal como se señala en las instrucciones
%Intrucciones: Para la matriz proporcionada en clase, el canal uno (fila 1) tiene el
%tiempo, en el resto de las filas se encuentra los demas canales.

clc, close all


disp('Pattern analysis LFP by REBECA HDEZS Agosto 2019')

[baseFileName,folder] = uigetfile('*.mat','SELECT LFP FILE (MAT) .mat');   % Seleccionar el archivo .mat

fullFileName = fullfile(folder, baseFileName);                             % Indicamos como guardar las variables
tempt = load (fullFileName);                                               % Abrimos el registro del LFP
fn = fieldnames(tempt);                                                    % Abrimos registro
MySignalLFP = tempt.(fn{1});                                               % Llamamos el registro de la carpeta

disp('Signal Duration (ms)')
disp(size(MySignalLFP,2)*(1000/25000))                                     % 25 000 es la Frecuencia de muestreo para la señal de la tarea

promptAR = {'High-Pass (Hz)','Low-Pass (Hz)',...
                     'Sampling Frequency (Hz)','Window to analyse (ms)',...
                     'Select Signal to show','Order to filter',...
                     'MeanPeakDistance','STD to detect peaks',...
                     'Burst Duration','Segments Duration (ms)'};           % Titulo de los datos a llenar
dlg_titleAR ='LFP-Analysis';                                               % Titulo de la tabla de datos a llenar
num_linesAR = 1;                                                           % Numero de lineas de la la linea a llenar en la tabla
defAR = {'1','350','25000','10000','2','2','2500','5','500','25'};         % Valores sugeridos
answerAR = inputdlg(promptAR,dlg_titleAR,num_linesAR,defAR);               % Definiendo la variable de variables
Handles.AR = [str2num(answerAR{1}),str2num(answerAR{2}),...
                        str2num(answerAR{3}),str2num(answerAR{4}),...
                        str2num(answerAR{5}),str2num(answerAR{6}),...
                        str2num(answerAR{7}),str2num(answerAR{8}),...
                        str2num(answerAR{9}),str2num(answerAR{10})];       % Convirtiendo a numeros las variables antes definidas
clear promptAFe dlg_titleAFe num_linesAFe defAFe answerAFe

MySignalLFP = downsample(MySignalLFP(Handles.AR(5),:),5);
Handles.AR(3) = Handles.AR(3)/5;
Signal = (Handles.AR(5));                                                  % Se abre la senial seleccionada en la ventana emergente
TimeSelected =((Handles.AR(4)) * (Handles.AR(3)))/1000;


[b,a] = butter((Handles.AR(6)),(Handles.AR(1))/((Handles.AR(3))/2),'low'); % almacenamos una variable b y otra a para el filtro pasa altas
y = filter(b,a,MySignalLFP(1:TimeSelected));                               % realizamos el filtro de la senial
[b,a] = butter((Handles.AR(6)),(Handles.AR(2))/((Handles.AR(3))/2),'high');% Realizamos el filtro pasa bajas 
filtered = filter(b,a,y);
% filtered = filtered.*-1;                                                 % Invierte el trazo original                                              


figure (1)
subplot(3,1,1)
plot(MySignalLFP(1:TimeSelected));
title('Signal Selected')
xlabel('Time'); grid on;

subplot(3,1,2)
plot(filtered(1:TimeSelected));
title('Filtered Signal')
xlabel('Time'); grid on;

subplot(3,1,3)
plot(filtered(1:TimeSelected));
title('Peak detection')
findpeaks(filtered,'MinPeakHeight',0.04, 'MinPeakDistance', (Handles.AR(7)))

[yupper] = envelope(filtered);
[yupper] = envelope(yupper);
umbral=mean(yupper)+ Handles.AR(8)*std(yupper); 
TimeVector = linspace(0,size(filtered,2)*(1000/Handles.AR(3)),...
             size(filtered,2));
[pks,locs] = findpeaks(yupper,TimeVector,'MinPeakHeight',umbral,...
             'MinPeakDistance',Handles.AR(7));

findpeaks(yupper,TimeVector,'MinPeakHeight',umbral,'MinPeakDistance',...
     Handles.AR(7));                                                         % Aqui podemos visualizar la busqueda de los picos con la función findpeaks, con distancias minimas
title('Convolution')
figure(2)

for Picos = 1: size(locs,2)
    if TimeVector(end) < (locs(Picos)+ Handles.AR(9))
        continue
    end
    Rafaguitas(Picos,:) = filtered(TimeVector >= locs(Picos) &...
    TimeVector <= locs(Picos)+ Handles.AR(9));
    subplot(3,1,1)
    plot(Rafaguitas(Picos,:))
    hold on
    pause(0.01)
    title('Burst')
end

RafaguitasConcated = reshape(Rafaguitas',...
[1, (size(Rafaguitas,1)*size(Rafaguitas,2))]);
subplot(3,1,2)
plot(RafaguitasConcated,'-')
title('Bursts found concatenated')


Segmentitos= reshape(RafaguitasConcated', [Handles.AR(3)*(Handles.AR(10)/1000), ...
    size(RafaguitasConcated,2)/(Handles.AR(3)*(Handles.AR(10)/1000))]);    %0.025=25 ms
Segmentitos= Segmentitos';

for t = 1: size(Segmentitos,1)
    subplot(3,1,3)
    plot(Segmentitos(t,:))
    hold on
    pause (0.01)
end
    

for m = 1:size(Segmentitos,1)
    for n= 1:size(Segmentitos,1)
        [Correlations,lag] =xcorr(Segmentitos(m,:),Segmentitos(n,:),1,'normalized');
        CorrelationsValue (n,m)= Correlations(lag == 0);
    end
end

clearvars -except CorrelationsValue                                        %Borra la memoria del workspace

figure (3)
imagesc(CorrelationsValue)


    
    
    
    
    