% Script para determinar la funcion kernel optima y la dim del regresor
clear
close all
load('Demand_Data_Horaria')
dim_reg=2;
type_reg=2;
param1=1.2;
param2=5;
func=3;
tau=100;
eje_y_d1 = normalize(eje_y_d); % normalizar los valores
ECMR(1)=3000000000;ECMR(2)=2000000000;ECMR(3)=1000000000;
for hh=4:10
    e=1;
    CE=0;
    for ww=1:5
        CE=CE+400;
        e=1;
        rr=CE;
        % Conformar Set de Entrenamiento
        clear set_X set_Y
        for qq=1:(rr-8)
           set_X(qq,:)= regresor(type_reg,dim_reg,qq+7,eje_x_d,eje_y_d1); 
           set_Y(qq)  = eje_y_d1(qq+8);
        end
        for rr=CE:CE+6
            
            % Prediccion con Métodos KERNEL
            x_reg = regresor(type_reg,dim_reg,rr,eje_x_d,eje_y_d1);
            y     = compute_Kernel_prediction(func,x_reg',set_Y',set_X',param1,param2,tau);
            y = denormalize(y,eje_y_d); % desnormalizar los valores

            % Calcular Error Cuadratico Medio 
            ECMD(hh,ww,e)= sqrt( mean( (y-eje_y_d(rr)).^2 ));
            e=e+1;
        end
        % Promediar errores de los 7 dias de la semana
        ECMCV(hh,ww)= mean(ECMD(hh,ww,:));
    end
    
    % Promediar errores de los 3 conjuntos de validación
    ECMR(hh)= mean(ECMCV(hh,:));
    
%     % Modificar parametros base radial
%     if (ECMR(hh-3)<ECMR(hh-2))
%         if (ECMR(hh-2)<ECMR(hh-1))
%              if (ECMR(hh-1)<ECMR(hh))
%                 param1=param1-30;
%                 %param2=param2-0.15;
%             else
%                 param1=param1+10;
%                 %param2=param2+0.05;
%             end
%         else
%             param1=param1+10;
%             %param2=param2+0.05;
%         end
%     else
%         param1=param1+10;
%         %param2=param2+0.05;
%     end
        % Modificar parametros polinomico
    if (ECMR(hh-3)<ECMR(hh-2))
        if (ECMR(hh-2)<ECMR(hh-1))
             if (ECMR(hh-1)<ECMR(hh))
                param1=param1+0.3;
                % param2=param2-3;
            else
                param1=param1-0.1;
                % param2=param2+1;
            end
        else
            param1=param1-0.1;
            % param2=param2+1;
        end
    else
        param1=param1-0.1;
        % param2=param2+1;
    end
end
