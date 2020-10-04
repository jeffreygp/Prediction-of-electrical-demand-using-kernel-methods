% close all;
% clear all;
%  
% % Cargar=input('Procesar datos de fichero CSV(1/0) ? ');
% % if (Cargar==1)
% % %[num,text,raw]=xlsread('export_DemandaReal_Horaria_2019-03-31_12_32.csv');
% % [num,text,raw]=xlsread('Demanda_Real_Horaria.csv');
% % 
% % [n_rows,n_columns]=size(raw)
% % disp('Cada columna corresponde a :')
% % filas='';
% % for ii=1:n_columns
% %     filas=[filas, char(raw(1,ii)), ' ; '];
% % end
% % disp(filas); 
% % 
% % % Creamos ahora una matriz donde cada columna tiene el siguiente
% % % significado:
% % % 1: Valor demanda, 2:año, 3:mes, 4:dia, 5:hora UTC: 6:min UTC; 7: Dif UTC
% % 
% % Data=nan(n_rows-1,3); % Restamos uno porque la primera fila son los nombre de las columnas
% % 
% % I_Demanda=5; % La demanda real está en la quinta columna.
% % I_Date_Time_UTC=6; % La fecha y hora +UTC está en la sexta columna.
% % for kk=1:n_rows-1
% %     Demanda=raw(kk+1,I_Demanda);
% %     if ischar(Demanda{1})
% %         Data(kk,1)=str2double(Demanda{1});
% %     else
% %         Data(kk,1)=Demanda{1};
% %     end
% %     
% %     Date_Time_UTC=raw(kk+1,I_Date_Time_UTC);
% %     DTU=char(Date_Time_UTC);
% %     
% %     % El formato para DTU es 2014-01-01T16:00:00+01:00
% %     
% %     Year=str2double(DTU(1:4));   % Year
% %     Month=str2double(DTU(6:7));   % Month
% %     Day=str2double(DTU(9:10));  % Day
% %     Hour=str2double(DTU(12:13)); % Hour
% %     Minute=str2double(DTU(15:16)); % Minute
% %     Second=str2double(DTU(18:19));
% %     Data(kk,2)=datenum([Year Month Day Hour Minute Second]);
% %     Data(kk,3)=str2double(DTU(21:22)); % UTC
% %     
% % end
% % 
% % Data_Info=['Data es una matriz con tres columnas: \n ', ...
% %     'La primera es la demanda real del mercado eléctrico español', ...
% %     'La segunda es la fecha y tiempo en datenum', ...
% %     'La tercera es el la diferencia UTC (1 en horario de invierno, 2 en verano'];
% %      
% % save ('Demand_Data','Data','Data_Info');
% % 
% % else
%     load('Demand_Data')
% % end
%     
% N=size(Data,1);
% eje_y_h=zeros(2*N,1);
% eje_x_h=zeros(2*N,1);
% for kk=1:N
%     eje_y_h(2*kk-1)=Data(kk,1);
%     eje_y_h(2*kk)=Data(kk,1);
%     eje_x_h(2*kk-1)=Data(kk,2);
%     if (kk<N)
%         eje_x_h(2*kk)=Data(kk+1,2);
%     else
%         eje_x_h(2*kk)=Data(kk,2)+1/24;
%     end
% end
% 
% figure(1)
% plot(eje_x_h,eje_y_h,'b');
% xlabel('Date Num');
% ylabel('Demanda Horaria');
% title('Demanda Eléctrica Mercado Español');
% 
% %% Convertir a Dia
% [eje_x_d,eje_y_d]=dem_diaria(Data);
% 
% figure(2)
% plot(eje_x_d(:,1),eje_y_d,'b');
% xlabel('Days');
% ylabel('Demanda Diaria');
% title('Demanda Eléctrica Mercado Español');
% 
% save ('Demand_Data_Horaria','eje_x_d','eje_y_d');

%% Prediccion con Métodos KERNEL
clear

prompt = 'Select the day to start the prediction for the nexts 7 days(7-2139)\n';
dia=input(prompt);

load('Demand_Data_Horaria')
type_reg=2;
dim_reg=2;

tau=110;
func=1;
e=1;m=0;r=0;
eje_y_d1 = normalize(eje_y_d); % normalizar los valores

% Graficar dias normalizados
figure(3)
plot(eje_x_d(:,1),eje_y_d1,'r');
xlabel('Days');
ylabel('Demanda Diaria Normalizada');
title('Demanda Eléctrica Mercado Español');

% Graficar dias anteriores
figure(4)
hold on
xlabel('Days');
ylabel('Demanda Diaria');
title('Prediccion Demanda Eléctrica Mercado Español');
plot(eje_x_d(dia-15:dia,1),eje_y_d(dia-15:dia),'b');

% Prediccion con Métodos KERNEL
% Conformar Set de Entrenamiento
rr=dia;
for qq=1:(rr-8)
   set_X(qq,:) = regresor(type_reg,dim_reg,qq+7,eje_x_d,eje_y_d1);
   set_Y(qq) = eje_y_d1(qq+8);
end
% Prediccion
for rr=dia:dia+7
    
    x_reg = regresor(type_reg,dim_reg,rr,eje_x_d,eje_y_d1);
    y     = compute_Kernel_prediction(func,x_reg',set_Y',set_X',1,1,tau);

    % Graficar Resultados
    y = denormalize(y,eje_y_d); % desnormalizar los valores
    r = r+(eje_y_d(rr)-y);
    m = m+eje_y_d(rr)-min(eje_y_d);
    plot(eje_x_d(rr,1),eje_y_d(rr),'*r');
    plot(eje_x_d(rr,1),y,'go'); 

    % Calcular Error Cuadratico Medio 
    ECM(e)= sqrt( mean( (y-eje_y_d(rr)).^2 ));
    e=e+1;

end

% ECM promedio de la prediccion
w = mean(ECM);
fprintf('ECM maximo %e.\n',max(ECM));
fprintf('ECM promedio de la prediccion %e.\n',w);
