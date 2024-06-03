clear
[aa,R]=geotiffread('E:\sgRisk2011.tif');%先投影信息
info=geotiffinfo('E:\sgRisk2011.tif');
risksum=zeros(size(aa,1)*size(aa,2),15);
for year=2011:2020
    filename=strcat('E:\sgRisk',int2str(year),'.tif');
    risk=importdata(filename);
    risk=reshape(risk,size(risk,1)*size(risk,2),1);
    risksum(:,year-2010)=risk;   % n*15
end
hsum=zeros(size(aa,1),size(aa,2))-99;

for kk=1:size(risksum,1)
    ceil(kk*100/size(risksum,1))
    risk=risksum(kk,:);   % 1*15 
    risk(risk<0)=[];
    if sum(isnan(risk)) > 0 
        continue
    elseif min(risk) == max(risk)        
        hsum(kk)=1;        
    else
        risk_cf=[];
        for i=1:length(risk)-1
            risk_cf1=risk(i+1)-risk(i);
            risk_cf=[risk_cf,risk_cf1];
        end
        M=[];
        for i=1:size(risk_cf,2)
            M1=mean(risk_cf(1:i));
            M=[M,M1];
        end
        
        S=[];
        for i=1:size(risk_cf,2)
            S1=std(risk_cf(1:i))*sqrt((i-1)/i);
            S=[S,S1];
        end

        for i=1:size(risk_cf,2)
            for j=1:i
                der(j)=risk_cf(1,j)-M(1,i);
                cum=cumsum(der);
                RR(i)=max(cum)-min(cum);
            end
        end

        RS=S(2:size(risk_cf,2)).\RR(2:size(risk_cf,2));
        T=[];
        for i=1:size(risk_cf,2)
            T1=i;
            T=[T,T1];
        end
        lag=T(2:size(risk_cf,2));                  
        g=polyfit(log(lag/2),log(RS),1);                
        H=g(1);
        hsum(kk)=H;
        clear der
    end
end
geotiffwrite('E:\risk_Hurst.tif',hsum,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
