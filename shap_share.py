import matplotlib
import pandas as pd
import numpy as np
import shap
from matplotlib import pyplot as plt
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score


# 从CSV文件加载数据
data = pd.read_csv('C:\\Users\\A\\Desktop\\内涝易感时序_返修\\data\\out.csv')
data_sample = data.sample(n=3000)
# 分离特征和目标
X = data_sample.iloc[:, 0:10]  # 训练样本
x = data.iloc[:, 0:10]         # 全样本
y = data_sample.iloc[:, 10]
print("1")
# 将数据分为训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)
print("1")
# 构建随机森林模型
RFModel = RandomForestRegressor(n_estimators=130, max_features=3, max_depth=5)
RFModel.fit(X_train, y_train)
print("Random Forest model trained")
# 评估模型精度
y_pred = RFModel.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)
print(f"Mean Squared Error: {mse}")
print(f"R-squared: {r2}")


# shap分析
explainer = shap.TreeExplainer(RFModel)
shap_values = explainer(x)
shap_values_all = explainer.shap_values(x)  # 输出结果改变数据格式
# 更改颜色条（可以选取色条某一部分）
cmap = plt.get_cmap('winter')
colors = cmap(np.linspace(0.2, 1, 256))
winter_r_plus = matplotlib.colors.LinearSegmentedColormap.from_list('winter_r_plus', colors)
# 蜂群图
plt.figure()
shap.plots.beeswarm(shap_values, color=winter_r_plus)
plt.savefig('shap_all_bee.png')  # 将图保存为文件
plt.show()
# 全局重要性图
plt.figure()
shap.summary_plot(shap_values_all, X_train, plot_type="bar")
plt.savefig('shap_all_bar.png')  # 将图保存为文件
plt.show()
# 单样本瀑布图
plt.figure()
shap.plots.waterfall(shap_values[1000])  # 选取某一点
plt.savefig('shap_single_water.png')     # 将图保存为文件
plt.show()


