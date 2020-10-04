% Desnormalizar
function desnorm=denormalize(norm,y_d)
    minimo=min(y_d);
    maximo=max(y_d);
    desnorm=((maximo-minimo)*norm)+minimo;
end

