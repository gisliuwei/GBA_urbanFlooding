clc,clear
[a,R] = geotiffread('E:\14.DWQ_island\1.data\3.extractByMask\Elevation\Elevation.tif');
info  = geotiffinfo('E:\14.DWQ_island\1.data\3.extractByMask\Elevation\Elevation.tif');
Elevation = imread('E:\14.DWQ_island\1.data\3.extractByMask\Elevation\Elevation.tif');    
[m1,n1] = size(Elevation);  
ori_mod = load('E:\3.大湾区内涝Sustainable city and society\1.data\确定方案\findMAC\mat655.mat');  %连续值的MAC

for year = 2006:2020
    year
    risk = nan(m1,n1);
    if year < 2020
        OriData = datasetUnit(year);
        ntree=500;     mtry=3;
        [Y_train, votes_train, prediction_train] = classRF_predict(OriData(:,3:end),ori_mod.mod);
        risk1 = votes_train(:,2)/500;
        C = [OriData(:,1:2),risk1];
        for idx = 1:length(C)
            risk(C(idx,1),C(idx,2))=risk1(idx);       
        end
        fileName1 = ['E:\14.DWQ_island\1.data\test\MAC2tif\risk',num2str(year),'.tif'];     
        geotiffwrite(fileName1,risk,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)
        
        %classified_risk
        classified_risk = risk;
%         classified_risk(risk<=0.2)=1;
%         classified_risk(risk > 0.2 & risk<=0.4)=2;
%         classified_risk(risk > 0.4 & risk<=0.6)=3;
%         classified_risk(risk > 0.6 & risk<=0.8)=4;
%         classified_risk(risk>0.8)=5;
        for kk = 1:10
            kk1 = kk*0.1;
            classified_risk(risk<=kk1 & risk>(kk1-0.1))=kk;
        end
        
        fileName2 = ['E:\14.DWQ_island\1.data\test\MAC2tif\等间距_risk',num2str(year),'.tif'];     
        geotiffwrite(fileName2,classified_risk,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)       
        
    end
    
    %统计正样本在高风险区的比例
    if year == 2020        
        Data = datasetUnit(year);
        OriData = Data;
        ntree=500;     mtry=3;
        [Y_train, votes_train, prediction_train] = classRF_predict(OriData(:,3:end-1),ori_mod.mod);
        risk1 = votes_train(:,2)/500;
        C = [OriData(:,1:2),risk1];
        for idx = 1:length(C)
            risk(C(idx,1),C(idx,2))= risk1(idx);       
        end
        fileName3 = ['E:\14.DWQ_island\1.data\test\MAC2tif\降水risk',num2str(year),'.tif'];     
        geotiffwrite(fileName3,risk,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)
        
        %classified_risk
        classified_risk = risk;
%         classified_risk(risk<=0.2)=1;
%         classified_risk(risk > 0.2 & risk<=0.4)=2;
%         classified_risk(risk > 0.4 & risk<=0.6)=3;
%         classified_risk(risk > 0.6 & risk<=0.8)=4;
%         classified_risk(risk>0.8)=5;
        for kk = 1:10
            kk1 = kk*0.1;
            classified_risk(risk<=kk1 & risk>(kk1-0.1))=kk;
        end
        
        fileName4 = ['E:\14.DWQ_island\1.data\test\MAC2tif\等间距_risk',num2str(year),'.tif'];     
        geotiffwrite(fileName4,classified_risk,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)   
        
        predict_label = risk1;
        predict_label(risk1<=0.2)=1;
        predict_label(risk1 > 0.2 & risk1<=0.4)=2;
        predict_label(risk1 > 0.4 & risk1<=0.6)=3;
        predict_label(risk1 > 0.6 & risk1<=0.8)=4;
        predict_label(risk1>0.8)=5;
        for class = 1:5
            sum(Data(:,end)== (predict_label==class)) 
        end
    end 
    
end














