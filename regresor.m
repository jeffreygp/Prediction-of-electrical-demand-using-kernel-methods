% Script para conformar el regresor
function x_reg=regresor(type,reg,rr,eje_x_d,eje_y_d)
if type==1
    for tt=1:(reg)
        % Dias anteriores
        x_reg(tt)=eje_y_d(rr-tt);
    end
elseif type==2
    for tt=1:(reg)
        if tt==(reg)
            % Una semana antes
            x_reg(tt)=eje_y_d(rr-7);
        else
            % Dias anteriores
            x_reg(tt)=eje_y_d(rr-tt);
        end
    end
else
    for tt=1:(reg)
        if tt==(reg)
            % Dia de la semana
            x_reg(tt)=eje_x_d(rr,2); 
        elseif tt==(reg-1)
            % Una semana antes
            x_reg(tt)=eje_y_d(rr-7);
        else
            % Dias anteriores
            x_reg(tt)=eje_y_d(rr-tt);
        end
    end
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end