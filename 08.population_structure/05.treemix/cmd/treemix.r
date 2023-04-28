Args<-commandArgs(T)
verbose=T
stem = Args[1]
pop = Args[2]
source("/stor9000/apps/users/NWSUAF/2014010784/script/treemix/plotting_funcs.R")

#tree
pdf(paste(stem,"tree.pdf",sep="."), width = 7, height = 7)
plot_tree(stem, o = pop, cex = 0.5, disp = 0.003, plus = 0.01, flip = vector(), arrow = 0.05, scale = T, ybar = 0, mbar = T, plotmig = T, plotnames = T, xmin = 0, lwd = 1, font = 1)
dev.off()
#cex: 字号
#disp: 字到枝的距离
#plus: 树的宽度(越小越宽)
#arrow: 箭头指针长度
#ybar: migration bar的位置
#mbar: 是否显示migration bar
#plotmig: 是否画基因流
#plotnames: 是否画枝的名字
#xmin: drift的最小值
#lwd: 枝的粗细
#font: 字体

#residual visualization
pdf(paste(stem,"residual.pdf",sep="."), width = 7, height = 7)
plot_resid(stem, pop_order = pop, min = -0.009, max = 0.009, cex = 0.5, usemax = T, wcols = "r")
dev.off()

#model explanation
explanation=get_f(stem)
print(explanation)
