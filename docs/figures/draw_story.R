# Five single-panel figures for the Chinese course story.
# Run from the repository root: Rscript docs/figures/draw_story.R
# Input tables are preserved in docs/figures/source-data/.

library(ggplot2)

base <- file.path("docs", "figures")
input <- file.path(base, "source-data")
font <- "Arial Unicode MS" # Chinese-capable sans-serif family available on this host.
ink <- "#21313C"
quiet <- "#A7B7BD"
teal <- "#237F83"
blue <- "#3F72A5"
orange <- "#C48143"

theme_story <- function() {
  theme_classic(base_size = 9, base_family = "Arial Unicode MS") +
    theme(
      plot.title = element_text(size = 12, face = "bold", colour = ink, margin = margin(b = 7)),
      plot.subtitle = element_text(size = 8.3, colour = "#53636D", margin = margin(b = 10)),
      plot.caption = element_text(size = 7.5, colour = "#65737B", hjust = 0, margin = margin(t = 10)),
      axis.text = element_text(size = 8, colour = ink),
      axis.title = element_text(size = 8.5, colour = ink),
      axis.line = element_line(linewidth = 0.35, colour = quiet),
      axis.ticks = element_line(linewidth = 0.35, colour = quiet),
      legend.position = "bottom",
      legend.title = element_blank(),
      legend.text = element_text(size = 8),
      plot.margin = margin(15, 24, 12, 15)
    )
}

save_story <- function(plot, stem, width_mm = 183, height_mm = 92) {
  w <- width_mm / 25.4
  h <- height_mm / 25.4
  prefix <- file.path(base, stem)
  svglite::svglite(paste0(prefix, ".svg"), width = w, height = h)
  print(plot)
  dev.off()
  if (Sys.info()[["sysname"]] == "Darwin") {
    grDevices::quartz(type = "pdf", file = paste0(prefix, ".pdf"),
                      width = w, height = h, family = font)
  } else {
    grDevices::cairo_pdf(paste0(prefix, ".pdf"), width = w, height = h, family = "Arial Unicode MS")
  }
  print(plot)
  dev.off()
  ragg::agg_png(paste0(prefix, ".png"), width = w, height = h, units = "in", res = 300)
  print(plot)
  dev.off()
  ragg::agg_tiff(paste0(prefix, ".tiff"), width = w, height = h, units = "in", res = 600,
                 compression = "lzw")
  print(plot)
  dev.off()
}

# Fig. 1: D1 records retained after two distinct operations.
records_all <- read.csv(file.path(input, "occurrence-flow.csv"), check.names = FALSE)
records <- records_all[records_all$module == "D1", , drop = FALSE]
stopifnot(nrow(records_all) == 8, nrow(records) == 3,
          identical(records$n, c(7239L, 6323L, 341L)))
records$step <- factor(c("原始记录", "有气候值的像元", "每个像元留一条"),
                       levels = c("每个像元留一条", "有气候值的像元", "原始记录"))
records$colour <- c(quiet, blue, teal)
f1 <- ggplot(records, aes(x = n, y = step)) +
  geom_col(aes(fill = step), width = 0.54, show.legend = FALSE) +
  geom_text(aes(label = format(n, big.mark = ",", trim = TRUE)),
            hjust = -0.12, size = 3.1, family = font, colour = ink) +
  scale_fill_manual(values = setNames(records$colour, as.character(records$step))) +
  scale_x_continuous(limits = c(0, 8400), breaks = c(0, 2000, 4000, 6000, 8000),
                     labels = function(x) format(x, big.mark = ",", trim = TRUE), expand = c(0, 0)) +
  labs(title = "一张分布图，从几千条记录开始",
       subtitle = "丹顶鹤示例：先找到有环境信息的位置，再按气候像元去重",
       x = "记录数", y = NULL,
       caption = "每格留一条是为了减轻重复采样影响；被合并的记录不等于错误记录。") +
  theme_story()
save_story(f1, "story-01-records")

# Fig. 2: one fixed Maxent setting, three evaluation designs.
validation_all <- read.csv(file.path(input, "validation-design.csv"), check.names = FALSE)
validation <- validation_all[validation_all$fc == "LQ" & validation_all$rm == 0.5, , drop = FALSE]
stopifnot(nrow(validation_all) == 24, nrow(validation) == 3,
          all(is.finite(validation$auc.diff.avg)), all(is.finite(validation$auc.diff.sd)))
scheme_names <- c("Random" = "随机分组 · 大范围背景",
                  "Block + global" = "空间分组 · 大范围背景",
                  "Block + buffered" = "空间分组 · 缓冲区背景")
stopifnot(setequal(validation$Scenario_short, names(scheme_names)))
validation$scheme <- factor(
  unname(scheme_names[validation$Scenario_short]),
  levels = c("空间分组 · 缓冲区背景", "空间分组 · 大范围背景", "随机分组 · 大范围背景")
)
validation$low <- pmax(0, validation$auc.diff.avg - validation$auc.diff.sd)
validation$high <- validation$auc.diff.avg + validation$auc.diff.sd
f2 <- ggplot(validation, aes(y = scheme)) +
  geom_segment(aes(x = low, xend = high, yend = scheme), linewidth = 1.15, colour = "#91B6B6") +
  geom_point(aes(x = auc.diff.avg), size = 3.4, colour = teal) +
  geom_text(aes(x = high + 0.015, label = sprintf("%.3f", auc.diff.avg)),
            hjust = 0, size = 3.1, family = font, colour = ink) +
  scale_x_continuous(limits = c(0, 0.29), breaks = seq(0, 0.25, 0.05), expand = c(0, 0)) +
  labs(title = "同一组参数，换一种考法，分数就会变",
       subtitle = "Maxent 的同一参数组合：LQ 特征，正则化倍数 0.5",
       x = "训练与验证 AUC 的平均差距", y = NULL,
       caption = "圆点为平均值；浅线为各折差距的 ±1 个标准差。三种背景与分组设计回答不同的预测问题。") +
  theme_story()
save_story(f2, "story-02-validation")

# Fig. 3: six single-species count models, four runs per algorithm.
models_all <- read.csv(file.path(input, "D14-model-evaluations.csv"), check.names = FALSE)
models <- models_all[models_all$metric.eval == "Rsquared", , drop = FALSE]
stopifnot(nrow(models_all) == 72, nrow(models) == 24,
          length(unique(models$algo)) == 6, all(is.finite(models$calibration)),
          all(is.finite(models$evaluation)))
algo_order <- c("GLM", "MARS", "DNN", "GBM", "XGBOOST", "RF")
means <- aggregate(models[c("calibration", "evaluation")],
                   by = list(algo = models$algo), FUN = mean)
sds <- aggregate(models[c("calibration", "evaluation")],
                 by = list(algo = models$algo), FUN = sd)
model_long <- rbind(
  data.frame(algo = means$algo, period = "训练期", mean = means$calibration, sd = sds$calibration),
  data.frame(algo = means$algo, period = "后一期", mean = means$evaluation, sd = sds$evaluation)
)
model_long$algo <- factor(model_long$algo, levels = algo_order)
model_long$period <- factor(model_long$period, levels = c("训练期", "后一期"))
pd <- position_dodge(width = 0.53)
f3 <- ggplot(model_long, aes(x = algo, y = mean, colour = period, group = period)) +
  geom_errorbar(aes(ymin = pmax(0, mean - sd), ymax = pmin(1, mean + sd)),
                width = 0.16, linewidth = 0.65, position = pd) +
  geom_point(size = 2.7, position = pd) +
  scale_colour_manual(values = c("训练期" = teal, "后一期" = orange)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2), expand = c(0, 0)) +
  labs(title = "六种方法，训练期和后一期各有一张成绩单",
       subtitle = "DataSTOC 的一个物种计数示例；每种方法汇总 4 次运行",
       x = NULL, y = "观测值与预测值的相关系数平方",
       caption = "点为 4 次运行均值，线为 ±1 个标准差。后一期对应独立的时间段；此图没有联合拟合多个物种。") +
  theme_story() +
  theme(axis.text.x = element_text(size = 7.5))
save_story(f3, "story-03-algorithms", width_mm = 183, height_mm = 102)

# Fig. 4: area shares in the explicitly simulated bio8 +2 C scenario.
change_all <- read.csv(file.path(input, "D4-sensitivity-range-change.csv"), check.names = FALSE)
stopifnot(nrow(change_all) == 4, all(is.finite(change_all$area_percentage)),
          abs(sum(change_all$area_percentage) - 100) < 0.01,
          length(unique(change_all$threshold)) == 1)
change_all$group <- factor(change_all$status,
                           levels = c("Absent", "Loss", "Stable", "Gain"),
                           labels = c("两次都未入选", "原有、情景中未入选", "两次都入选", "情景中新增"))
f4 <- ggplot(change_all, aes(x = area_percentage, y = group)) +
  geom_col(aes(fill = status), width = 0.55, show.legend = FALSE) +
  geom_text(aes(label = sprintf("%.1f%%", area_percentage)),
            hjust = -0.13, size = 3.1, family = font, colour = ink) +
  scale_fill_manual(values = c("Absent" = quiet, "Loss" = orange,
                               "Stable" = teal, "Gain" = blue)) +
  scale_x_continuous(limits = c(0, 55), breaks = seq(0, 50, 10), expand = c(0, 0)) +
  labs(title = "换一个环境情景，阈值地图会怎样变？",
       subtitle = "课堂灵敏度试验：给 bio8 加 2°C，再按 0.25 的阈值重新分组",
       x = "研究范围内的面积比例", y = NULL,
       caption = "面积比例按有效像元面积计算。这是人为设置的教学情景。") +
  theme_story()
save_story(f4, "story-04-scenario")

# Fig. 5: every valid MaxEnt raster cell in the teaching study window.
map_all <- read.csv(file.path(input, "glm-maxent-map.csv"), check.names = FALSE)
map <- map_all[map_all$source_panel == "map_predictions" &
                 map_all$Algorithm == "MaxEnt", , drop = FALSE]
stopifnot(nrow(map_all) == 53468, nrow(map) == 21734,
          all(is.finite(map$x)), all(is.finite(map$y)),
          all(is.finite(map$suitability)),
          all(map$suitability >= 0 & map$suitability <= 1))
f5 <- ggplot(map, aes(x = x, y = y, fill = suitability)) +
  geom_tile(width = 1 / 6, height = 1 / 6) +
  coord_quickmap(xlim = c(110, 150), ylim = c(30, 55), expand = FALSE) +
  scale_fill_gradientn(colours = c("#F3F5F4", "#B7D7D4", "#579A9A", "#165C68"),
                       limits = c(0, 1), breaks = c(0, 0.25, 0.5, 0.75, 1),
                       name = "相对适宜性") +
  guides(fill = guide_colourbar(title.position = "top", barwidth = grid::unit(68, "mm"),
                                barheight = grid::unit(3.5, "mm"))) +
  labs(title = "把学到的环境关系，放回地图上",
       subtitle = "丹顶鹤示例：Maxent 对研究范围内每个有效气候像元的连续预测",
       x = "经度", y = "纬度",
       caption = "颜色表示此模型的相对适宜性。地图包含 21,734 个有效像元。") +
  theme_story() +
  theme(panel.grid.major = element_line(colour = "#E8EEEF", linewidth = 0.25),
        legend.position = "bottom")
save_story(f5, "story-05-map", width_mm = 183, height_mm = 126)

cat("Rendered five source-linked single-panel figures.\n")
