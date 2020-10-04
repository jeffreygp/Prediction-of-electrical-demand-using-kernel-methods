% Script para determinar la funcion kernel optima y la dim del regresor
clear
close all
load('Demand_Data_Horaria')

dim_reg=2;
type_reg=2;
eje_y_d1 = normalize(eje_y_d); % normalizar los valores

for func=1:3

    if func==1 % Lineal
        taumax=150;
        taumin=10;
        dtau=5;
        tau=taumin;
        
        param1=1;
        param2=1;

        for ii=1:((taumax-taumin)/dtau)
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
                        y = denormalize(y,eje_y_d); % desnormdalizar los valores

                        % Calcular Error Cuadratico Medio 
                        ECMD(ii,ww,e)= sqrt( mean( (y-eje_y_d(rr)).^2 ));
                        e=e+1;
                    end
                    % Promediar errores de los 7 dias de la semana
                    ECMCV(ii,ww)= mean(ECMD(ii,ww,:));
                end

                % Promediar errores de los 3 conjuntos de validación
                ECMR(ii)= mean(ECMCV(ii,:));
                tau=tau+dtau;                
        end
        save ('ECMR1','ECMR');
    elseif func==2 % Base radial
        clear e CE ECMCV ECMD ECMR hh param2max param2min dparam2 param2 param1max param1min dparam1 param1 taumax taumin dtau tau qq rr ww x_reg y
        taumax=150;
        taumin=10;
        dtau=5;
        tau=taumin;

        param2max=5;
        param2min=0.1;
        dparam2=0.2;
        param2=param2min;
        
        param1=1;

        for ii=1:((taumax-taumin)/dtau)
            for jj=1:((param2max-param2min)/dparam2)
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
                        ECMD(ii,jj,ww,e)= sqrt( mean( (y-eje_y_d(rr)).^2 ));
                        e=e+1;
                    end
                    % Promediar errores de los 7 dias de la semana
                    ECMCV(ii,jj,ww)= mean(ECMD(ii,jj,ww,:));
                end

                % Promediar errores de los 3 conjuntos de validación
                ECMR(ii,jj)= mean(ECMCV(ii,jj,:));                
                param2=param2+dparam2;
            end 
            tau=tau+dtau; 
        end
        save ('ECMR2','ECMR');
    else % polinómica
        clear e CE ECMCV ECMD ECMR hh param2max param2min dparam2 param2 param1max param1min dparam1 param1 taumax taumin dtau tau qq rr ww x_reg y
        param1max=1;
        param1min=0.1;
        dparam1=0.1;
        param1=param1min;

        param2max=8;
        param2min=1;
        dparam2=1;
        param2=param2min;
        
        tau=100;

        for ii=1:((param1max-param1min)/dparam1)
            for jj=1:((param2max-param2min)/dparam2)
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
                        ECMD(ii,jj,ww,e)= sqrt( mean( (y-eje_y_d(rr)).^2 ));
                        e=e+1;
                    end
                    % Promediar errores de los 7 dias de la semana
                    ECMCV(ii,jj,ww)= mean(ECMD(ii,jj,ww,:));
                end

                % Promediar errores de los 3 conjuntos de validación
                ECMR(ii,jj)= mean(ECMCV(ii,jj,:));
                param2=param2+dparam2;
            end 
            param1=param1+dparam1;
        end
        save ('ECMR3','ECMR');
    end
end



