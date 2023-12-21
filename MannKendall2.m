[a,R] = geotiffread('E:\risk_Hurst.tif');
info  = geotiffinfo('E:\risk_Hurst.tif');
meta = imread('E:\risk_Hurst.tif');
[m1,n1] = size(meta);
rowCol = zeros(m1*n1,2);
for i = 1:m1
    rowCol((i-1)*n1+1:i*n1,1)=i;
    rowCol((i-1)*n1+1:i*n1,2)=1:1:n1;
end

beta = imread('E:\beta.tif');        beta= double(reshape(beta',m1*n1,1));
hurst = imread('E:\risk_Hurst.tif'); hurst= double(reshape(hurst',m1*n1,1));
Zs = imread('E:\Zs.tif');             Zs= double(reshape(Zs',m1*n1,1));
sum_classRisk = imread('E:\sum_classRisk¶ş·ÖÀà.tif');   sum_classRisk= double(reshape(sum_classRisk',m1*n1,1));


sumData = [rowCol,beta,hurst,Zs,nan(length(beta),1),nan(length(beta),1)];
sumData(sumData(:,3) > 1  | sumData(:,3) < -1,:)=[]; 
sumData(sumData(:,4) > 10 | sumData(:,4) < -10,:)=[]; 
sumData(sumData(:,5) > 10 | sumData(:,5) < -10,:)=[]; 

beta = sumData(:,3);
hurst = sumData(:,4);
Zs = sumData(:,5);
Sen_MK =  sumData(:,6);
Sen_MK_hurst =  sumData(:,7);

Sen_MK(beta >= 0.0001 & Zs >= 1.96,:)=1;
Sen_MK(beta >= 0.0001 & Zs >= -1.96 & Zs < 1.96,:)=2;
Sen_MK(beta >=-0.0001 & beta < 0.0001,:)=3;
Sen_MK(beta < -0.0001 & Zs >= -1.96 & Zs < 1.96,:)=4;
Sen_MK(beta < -0.0001 & Zs < -1.96,:)=5;

aaa2 = [];
for iii = 1:5
    aaa1 = sum(Sen_MK == iii)*100/length(Sen_MK);
    aaa2 = [aaa2,aaa1];
end
aaa2

Sen_MK_hurst(hurst > 0.5 & beta >= 0.0001 & Zs >= 1.96,:)=1;
Sen_MK_hurst(hurst > 0.5 & beta >= 0.0001 & Zs >= -1.96 & Zs < 1.96,:)=2;
Sen_MK_hurst(hurst > 0.5 & beta >= -0.0001 & beta < 0.0001,:)=3;
Sen_MK_hurst(hurst > 0.5 & beta < -0.0001 & Zs >= -1.96 & Zs < 1.96,:)=4;
Sen_MK_hurst(hurst > 0.5 & beta < -0.0001 & Zs < -1.96,:)=5;
Sen_MK_hurst(hurst < 0.5,:)= 6;

ccc2 = [];
for iii = 1:6
    ccc1 = sum(Sen_MK_hurst == iii)*100/length(Sen_MK_hurst);
    ccc2 = [ccc2,ccc1];
end
ccc2

for kk = 3:4
    risk = nan(m1,n1);
    C = [sumData(:,1:2),Sen_MK,Sen_MK_hurst];
    risk1 = C(:,kk);
    for idx = 1:length(C)
        risk(C(idx,1),C(idx,2)) = risk1(idx);       
    end
    if kk == 3
        fileName1 = 'E:\Sen_MK.tif';  
    else
        fileName1 = 'E:\Sen_MK_hurst.tif';
    end
    geotiffwrite(fileName1,risk,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)
end






