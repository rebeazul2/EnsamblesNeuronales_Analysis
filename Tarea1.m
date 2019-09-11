%% Tarea 1 CALCULAR LA SIMILITUD ENTRE VECTORES 
clc, close all
%load('C:\Users\rebea\Documents\Clase_Carrillo_3er_Semestre\Rasterbin.mat')
% Cargar la matriz con la funciòn load o en el workspace
Raster = Rasterbin;
shg
figure(1)

    ax1 = subplot(2,2,1); imagesc(Rasterbin,[0,1]); 
    colormap(ax1, [1 1 1; 0 0 0]); title('Raster Plot')
    Coactividad = sum(Rasterbin);
    subplot(2,2,3); plot(Coactividad,'r')
    title ('Coactividad -sum-')
%Reproducir función para la matriz Raster bin: cos(?)=a·b/?a?·?b?

LongitudMatriz =  size(Rasterbin,2);

for PrimeraCorrida=1:LongitudMatriz
    for SegundaCorrida=1:LongitudMatriz
      ProductoPunto1=Raster(:,PrimeraCorrida);                                                                   % Con esta funcion tenemos al primer Vector 
      ProductoPunto2=Raster(:,SegundaCorrida);                                                                  %Con esta funcion tenemos al segundo Vector 
      DotProduct=dot( ProductoPunto1,ProductoPunto2);                                                     %Producto punto
      LongVec= sqrt(sum( ProductoPunto1)*sum(ProductoPunto2));                                    %producto de la longitud del vector
      AnguloSimilitudMatriz(PrimeraCorrida,SegundaCorrida)=DotProduct/LongVec;
    end
end

ax2 = subplot(2,2,2); imagesc(AnguloSimilitudMatriz); 
colormap (ax2,parula)
c = colorbar 
c.Label.String = 'Indice similitud';
title ('Matriz similitud')


% Para umbralizar la matriz a 0.5 con la finalidad de ver ciertos estados
ax3 = subplot(2,2,4); imagesc(AnguloSimilitudMatriz>0.5); 
colormap (ax3, [1 1 1; 0 0 0])
d = colorbar 
d.Label.String = 'Indice de similitud binaria';
title ('Matriz similitud -binaria > 0.5-')




