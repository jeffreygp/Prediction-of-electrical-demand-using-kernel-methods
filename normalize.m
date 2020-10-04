% Normalizar
function norm=normalize(y_d)
    minimo=min(y_d);
    maximo=max(y_d);
    for ii=1:length(y_d)
        norm(ii)=(y_d(ii)-minimo)/(maximo-minimo);
    end
end

