% Script para determinar la funcion kernel optima y la dim del regresor
clear
close all
load('Demand_Data_Horaria')
param1=1.3; param2=1.3; tau=110;
eje_y_d1 = normalize(eje_y_d); % normalizar los valores
for type_reg=2:2
    for dim_reg=2:2
        for func=1:1
            if func==3
                param1=0.1;
                param2=6; 
            end
            e=1;
            CE=0;
            for ww=1:10
                CE=CE+200;
                e=1;
                rr=CE;
                % Conformar Set de Entrenamiento
                clear set_X set_Y
                for qq=1:rr
                    eje_y_d_new(qq)=eje_y_d1(qq);
                end
                for qq=1:(rr-8)
                   set_X(qq,:)= regresor(type_reg,dim_reg,qq+7,eje_x_d,...
                       eje_y_d1); 
                   set_Y(qq)  = eje_y_d1(qq+8);
                end
                for rr=CE:CE+6
                    % Prediccion con Métodos KERNEL
                    x_reg = regresor(type_reg,dim_reg,rr,eje_x_d,eje_y_d_new);
                    y     = compute_Kernel_prediction(func,x_reg',set_Y',...
                        set_X',param1,param2,tau);
                    eje_y_d_new(rr)=y;
                    y = denormalize(y,eje_y_d); % desnormalizar los valores
                    % Calcular Error Cuadratico Medio 
                    ECMD(func,ww,e)= sqrt( mean( (y-eje_y_d(rr)).^2 ));
                    e=e+1;
                end
                % Promediar errores de los 7 dias de la semana
                ECMCV(func,ww)= mean(ECMD(func,ww,:));
            end
            % Promediar errores de los 3 conjuntos de validación
            ECMR(type_reg,dim_reg-1,func)= mean(ECMCV(func,:));
        end
    end
end
