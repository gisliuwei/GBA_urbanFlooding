[a,R] = geotiffread('E:\averageRisk.tif');
info  = geotiffinfo('E:\averageRisk.tif');
Elevation = imread('E:\averageRisk.tif');    
[m1,n1] = size(Elevation); 

sumData = [];
for year = 2011:2020
    data = imread(['E:\sgRisk',num2str(year),'.tif']);
    data= double(reshape(data',m1*n1,1));
    sumData = [sumData,data];
end
 
rowCol = zeros(m1*n1,2);
for i = 1:m1
    rowCol((i-1)*n1+1:i*n1,1)=i;
    rowCol((i-1)*n1+1:i*n1,2)=1:1:n1;
end
sumData = [rowCol,sumData];
sumData(isnan(sumData(:,end)),:)=[];
Zs = nan(length(sumData),1);
beta = nan(length(sumData),1);
UFk = nan(length(sumData),1);
UBk = nan(length(sumData),1);


for kkk = 1:length(sumData)
    ceil(kkk*100/length(sumData))
    trendData = sumData(kkk,3:end);
    trendData(isnan(trendData))=[];  
    if(length(trendData)<2)
        Zs(kkk,:) = nan;
        beta(kkk,:) = nan;        
    else
        [Zs(kkk,:),beta(kkk,:),~,~]= MKTest(trendData,length(trendData));
    end
end

Zs2 = reshape1(m1,n1,sumData(:,1:2),Zs);
fileName1 = 'E:\MannKendall\Zs.tif';     
geotiffwrite(fileName1,Zs2,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)
beta2 = reshape1(m1,n1,sumData(:,1:2),beta);
fileName2 = 'E:\MannKendall\beta.tif';     
geotiffwrite(fileName2,beta2,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)


        
        
