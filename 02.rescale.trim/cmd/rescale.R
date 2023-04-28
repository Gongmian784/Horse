# Usage: /home/ginolhac/install/R-3.0.2/bin/Rscript --vanilla --slave /disk/eos/data/ludovic/BAM/rescale.R -f FOLDER

variable <- commandArgs(trailingOnly=TRUE)

setwd(variable[1])
print(variable[1])

name<-"subst.txt"

tab<-read.table(file=name,sep="\t")
pos<-seq(1,70,1)

# HARD-THRESHOLD ON THE ERROR RATE PER BASE (EXCLUDING C>Ts AND G>As)
threshold<-0.001

output<-c()

############
# TRIMMING #
############

trim.d5<-tab$V2[70*2+pos]
trim.d3<-tab$V2[70*3+pos]
#plot(pos,trim.d5,col="red",pch=20)
#plot(pos,trim.d3,col="blue",pch=20)
trim.dr5<-summary(lm(trim.d5~pos))$residuals
trim.dr3<-summary(lm(trim.d3~pos))$residuals
#plot(pos,trim.dr5,col="red",pch=20)
#plot(pos,trim.dr3,col="blue",pch=20)
trim.s5<-pos[trim.dr5<=threshold][1]
trim.s3<-pos[trim.dr3<=threshold][1]

# QC
#plot(pos,trim.dr5,col="red",pch=20)
#abline(h=threshold,col="red")
#plot(pos,trim.dr3,col="blue",pch=20)
#abline(h=threshold,col="blue")


#############
# RESCALING #
#############

pos.5<-seq(1,70-trim.s5+1,1)
pos.3<-seq(1,70-trim.s3+1,1)

rescale.p5<-cumsum(tab$V2[pos.5])
rescale.p3<-cumsum(tab$V2[70+pos.3])

# residuals [1..70-trim.s5/3]
rescale.r5<-summary(lm(rescale.p5~pos.5))$residuals
rescale.r3<-summary(lm(rescale.p3~pos.3))$residuals

# minimum within the trustworthy half of the template
rescale.m5<-min(rescale.r5[pos.5[36:length(pos.5)]])
rescale.m3<-min(rescale.r3[pos.3[36:length(pos.3)]])

# QC
#plot(pos.5,rescale.r5,col="red",pch=20)
#abline(h=rescale.m5,col="red")
#plot(pos.3,rescale.r3,col="blue",pch=20)
#abline(h=rescale.m3,col="blue")

# First trustworthy bases to keep - +1 TO BE CONSERVATIVE = NEXT BASE THAT WE WOULD HAVE OTHERWISE ACCEPTED
rescale.s5<-pos.5[rescale.r5>=rescale.m5][1]
rescale.s3<-pos.3[rescale.r3>=rescale.m3][1]

# Accepted C>T error 
# tab$V2[rescale.s5]
# Accepted G>A error 
# tab$V2[70+rescale.s3]

output<-data.frame(trim.s5,trim.dr5[trim.s5],trim.s3,trim.dr3[trim.s3],rescale.s5,tab$V2[rescale.s5],rescale.s3,tab$V2[70+rescale.s3])

rescale.s5<-pos.5[rescale.r5>=rescale.m5][1]+1
rescale.s3<-pos.3[rescale.r3>=rescale.m3][1]+1
# Accepted C>T error
# tab$V2[rescale.s5]
# Accepted G>A error
# tab$V2[70+rescale.s3]

output<-c(output,rescale.s5,tab$V2[rescale.s5],rescale.s3,tab$V2[70+rescale.s3])
write.table(file=paste(name,".out",sep=''),output,row.names=F,col.names=F,quote=F)


