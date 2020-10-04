function [x_d,y_d]=dem_diaria(Data)
    ii=1;
    x_d(ii,1)=ii;
    x_d(ii,2)= weekday(datetime(Data(4,2), 'ConvertFrom','datenum'));
    sum=Data(4,1);
    count=1;
    for kk=5:length(Data(:,2))
        if(day(datetime(Data(kk,2), 'ConvertFrom','datenum'))...
                ==day(datetime(Data(kk-1,2), 'ConvertFrom','datenum')))
            sum=sum+Data(kk,1);
            count=count+1;
        else
            y_d(ii) = sum; 
            sum=Data(kk,1);
            count=1;
            ii=ii+1;
            x_d(ii,1)=ii;
            x_d(ii,2)=weekday(datetime(Data(kk,2),'ConvertFrom','datenum'));
        end
    end
    y_d(ii) = sum;
end




