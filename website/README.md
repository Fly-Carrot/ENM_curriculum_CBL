# 一只鸟，一张地图｜十二章中文讲解网页

[在线阅读完整网页](https://bird-map-ecology-david.robbleeglish.chatgpt.site/)

这里保存了网页的完整静态文件和编写源文件。网页从一次丹顶鹤观测讲起，顺着记录、背景、模型、验证、跨区域预测、计数、占域和下一次调查，讲完十二章。章节中的分析图来自课程数据复现；带有“AI 场景配图”标注的图片用于帮助想象现场。

想离线阅读，下载仓库后打开 [dist/index.html](dist/index.html) 即可。请保留 `dist` 文件夹内的图片、样式和脚本，它们与页面一起工作。想了解页面怎样生成，可以看 [chapters.mjs](chapters.mjs) 和 [build.mjs](build.mjs)：在此目录运行 `node build.mjs` 会重新生成页面，再运行 `node verify.mjs` 可检查章节、链接、图片与关键教学计算。

网页附有五张可下载的课程结果表。为方便核对正文提到的其他数字，这里还保存了六张复现汇总表：[各模块数值](data/baseline-module-metrics.csv)、[空间分组数量](data/fold-balance.csv)、[环境外推结果](data/projection-support.csv)、[D4 情景核对](data/D4-sensitivity-audit.csv)、[D14 模型清单](data/D14-built-models.csv)和[范围变化](data/range-change.csv)。这些是课程运行后的汇总结果，没有收录原始气候栅格或专家范围图层。

原始课程代码来自[乔慧捷老师的仓库](https://github.com/qiaohj/ENM_curriculum)，采用 MIT 许可；课程数据见[乔老师发布的 Figshare 第 2 版](https://doi.org/10.6084/m9.figshare.33453802.v2)，采用 CC BY 4.0。完整来源与许可说明见 [THIRD_PARTY_NOTICES.txt](dist/THIRD_PARTY_NOTICES.txt)。这是一份独立学习讲解网页，不是课程官方页面。
