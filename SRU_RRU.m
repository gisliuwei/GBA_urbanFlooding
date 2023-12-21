clc,clear
[a,R] = geotiffread('E:\Elevation.tif');
info  = geotiffinfo('E:\Elevation.tif');
Elevation = imread('E:\Elevation.tif');    
[m1,n1] = size(Elevation);  
ori_mod = load('E:\mat655.mat'); %连续值的MAC
sum = nan(1000,7);
for i = 1:1000
    OriData = datasetUnit(2020);
    posiData = OriData(OriData(:,end)==1,3:end);
    negaData = OriData(OriData(:,end)==-1,3:end); 
    
    idx1 = randperm(length(posiData));
    idx2 = randperm(length(negaData));       
    posiData1 = posiData(idx1,:);    
    negaData1 = negaData(idx2(1:length(posiData)),:);
    newData1 = [posiData1;negaData1];
    idx = randperm(length(newData1));
    trainingData = newData1(idx(1:floor(length(newData1)*0.7)),:);
    testingData = newData1(idx(floor(length(newData1)*0.7)+1:end),:);
    
    ntree=500;     mtry=3;
    mod = classRF_train(trainingData(:,1:end-1),trainingData(:,end),ntree,mtry);
    [Y_test, votes_test, prediction_test] = classRF_predict(testingData(:,1:end-1),mod);
    [MAC_Y_test, MAC_votes_test, MAC_prediction_test] = classRF_predict(testingData(:,1:end-1),ori_mod.mod);

    [OA_test,kappa_test,AUC_test] = accuracyEstimation(testingData(:,end),votes_test(:,2)/500,Y_test);  
    [MAC_OA_test,MAC_kappa_test,MAC_AUC_test] = accuracyEstimation(testingData(:,end),MAC_votes_test(:,2)/500,MAC_Y_test);  
         
    Q = [i, OA_test,kappa_test,AUC_test,MAC_OA_test,MAC_kappa_test,MAC_AUC_test]
    sum(i,:)=Q;
 end
dlmwrite('E:\RRU_SRU1000.csv',sum,'delimiter', ',','precision', 6,'newline', 'pc');








