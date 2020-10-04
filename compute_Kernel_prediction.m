function y=compute_Kernel_prediction(func,x,set_Y,set_X,param1,param2,tau)
    if func==1
        Kern=@(x,y) x'*y; % Lineal
    elseif func==2
        Kern=@(x,y) exp(-param2*(x-y)'*(x-y)); % Base radial
    else
        Kern=@(x,y) (param1+x'*y)^param2; % polinómica
    end
    N=size(set_X,2);
    K=nan(N);
    D=nan(1,N);
    for kk=1:N
        xa=set_X(:,kk);
        D(kk)=Kern(xa,x);
        for jj=kk:N
            xb=set_X(:,jj);
            K(kk,jj)=Kern(xa,xb);
            K(jj,kk)=K(kk,jj);
        end
    end
    y=D*inv((1/tau)*eye(N)+K)*set_Y;
end





