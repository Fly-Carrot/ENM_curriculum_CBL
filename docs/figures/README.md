# 中文故事图：数据与作图说明

这五张图使用已经完成的课程复现结果重新绘制。绘图语言是 R，代码为 [draw_story.R](draw_story.R)；每张图均提供 PNG、SVG、PDF 和 600 dpi TIFF。PNG 用于 GitHub 阅读，其他格式便于放大查看和后续排版。

| 图 | 回答的问题 | 数据表与使用范围 |
| --- | --- | --- |
| [01 记录进入模型](story-01-records.png) | 记录怎样变成不同的环境像元？ | [occurrence-flow.csv](source-data/occurrence-flow.csv) 的 D1 三行：7,239 → 6,323 → 341。 |
| [02 验证设计](story-02-validation.png) | 固定参数组合，换背景与分组，训练—验证差距怎样变？ | [validation-design.csv](source-data/validation-design.csv) 共 24 行；图取固定参数 `fc=LQ, rm=0.5` 的三行，浅线是 `auc.diff.avg ± auc.diff.sd`。 |
| [03 六种算法](story-03-algorithms.png) | 训练期与后一期的表现能否一起看？ | [D14-model-evaluations.csv](source-data/D14-model-evaluations.csv) 共 72 行；图取 `metric.eval=Rsquared` 的 24 行，六种算法各四次运行，分别计算训练期和后一期均值、标准差。此指标按观测—预测相关系数平方解释。 |
| [04 环境情景](story-04-scenario.png) | 一个明确的教学情景如何改变阈值地图？ | [D4-sensitivity-range-change.csv](source-data/D4-sensitivity-range-change.csv) 四行全部使用；`bio8 +2°C`，阈值 0.25，显示有效域的面积比例。 |
| [05 连续地图](story-05-map.png) | 环境关系放回地理空间后是什么样？ | [glm-maxent-map.csv](source-data/glm-maxent-map.csv) 共 53,468 行；图取 `source_panel=map_predictions` 且 `Algorithm=MaxEnt` 的 21,734 个有效像元，原样绘制，不抽样。 |

四个小表和地图像元表均来自本地课程复现生成的结果表。课程代码以乔慧捷老师的[公开仓库](https://github.com/qiaohj/ENM_curriculum)为源，课程数据条目由乔老师在 [Figshare](https://doi.org/10.6084/m9.figshare.33453802) 以 CC BY 4.0 发布。这里的汇总、中文图题和绘图由 fork 维护者完成；引用数据时请同时保留原始数据来源。丹顶鹤地图使用 [WorldClim 2.1 气候变量](https://www.worldclim.org/data/worldclim21.html)；气候数据的来源文献是 Fick 与 Hijmans（2017）。所附地图像元表只含模型预测分数，不含原始气候栅格。

每图各回答一个问题，因此采用单幅图，不需要多面板对齐。颜色沿用蓝绿为主要信息、橙色表示变化的简洁方案；图中最小文字在实际 PDF 中为 7.5 pt。五张 PDF 的碰撞检查均无失败项；地图色标两端的数字与色带边缘接触，属于有意的刻度位置。macOS Quartz PDF 把文字大小存为 1 pt 再施加变换；因此仅扫描 PDF `Tf` 的检查会报出 1 pt，按最终页面文字几何测得的最小有效字号为 7.5 pt。全部图片都已逐张目视检查。

从仓库根目录运行：`Rscript docs/figures/draw_story.R`。图中只使用来源表内的观测或课程计算值，没有为画图另造示例数字。环境情景图本身是明确标记的教学试验。
