%% Rebeca Hernández Soto, Tarea 2 parte II- INB-UNAM 02-09-2019
function read = DetectBurst3(signal,FM,ventanitas,retraso)

% signal : aquí se debe ingresar la señal del workspace que se desa analizar
% FM     : corresponde a la frecuencia de muestreo
% window : corresponde al fragmento en ms que queremos analizar
% retraso: Con esto enunciamos el tamaño del lag para las correlaciones en
% puntos de muestreo
TimeVector = linspace(0,size(signal,2)*(1000/FM),...
             size(signal,2));
windowsignal = ventanitas.*FM/1000;
NumWindow = (length(signal)/windowsignal).*size(signal,1); 
NumWindow2 = round(NumWindow); 
% Con esto designamos la 
% cantidad de ventanas de 25 ms (si ese es el tamaño de la ventana), que
% tienen los canales de la señal de entrada 
         
Posiciones = 1; % Este es un contador que nos permite situar por cada 
% vuelta los correlogramas en el plot, que se designan dentro del plot
for n = 1: size(signal,1)
  for m = 1:size(signal,1)
      [Correlations,lag] =xcorr(signal(m,:),signal(n,:),retraso,'normalized');
       CorrelationsValue (n,:,m)= Correlations;
       figure(1)    
       subplot(size(signal,1), size(signal,1),Posiciones)
       Posiciones =  Posiciones +1;
       plot(lag,CorrelationsValue(n,:,m))
       
  end
end


figure(2)
CorrMini = corr(reshape(signal(:,1:end-1),windowsignal,NumWindow2));
imagesc(CorrMini);
colorbar
colormap(parula)
title('Correlations between mini-burst')
end