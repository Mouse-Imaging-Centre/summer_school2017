# The following scripts demonstrates a typical analysis
# for in vivo data.
#
#### PREAMBLE ###
# Make sure to load the appropriate modules first
# in terminal, prior to starting R.
# For sickkids HPF, the modules are as follows:
# > module use /hpf/largeprojects/MICe/tools/modulefiles
# > module load octave/4.0.0 gcc/4.9.1 
# > module load minc-toolkit/1.9.11 python/2.7.12 
# > module load pyminc/0.47 minc-stuffs/0.1.17
# > module load R/3.3.2 RMINC/1.4.3.4
#### R Code begins ###

# Lets load the libraries we need
suppressPackageStartupMessages({
  library(RMINC)    # To handle MINC data
  library(dplyr)    # Useful for manipulating data frames
  library(ggplot2)  # Useful for visualization
  library(splines)  # Useful for visualization
})
  
setwd("/hpf/largeprojects/MICe/chammill/presentations/summer_school2017/longitudinal_analysis")
# Read CSV file that contains the data we wish to analyze
df = read.csv('tamarack_det.csv',stringsAsFactors = FALSE)

# relevel genotype vector to make reference WT.
df = df %>% mutate(genotype = factor(genotype,levels=c('WT','KO')))

# We want to use a mask for analysis so we don't
# waste computation time evaluating voxels outside
# the brain. 
mask = 'DSU_atlas/mask.mnc'

# This model looks at the voxel-wise effect of 
# genotype on relative volumes. 
dothis = FALSE
if (dothis) {
   vs_full=mincLmer(relatives ~ genotype*timepoint+(1 | subject_id), 
                df, mask=mask,parallel=c('PBS',100),REML=FALSE,cleanup=TRUE,
                temp_dir='lmer_models/tmp')
   vs_noint=mincLmer(relatives ~ genotype+timepoint+(1 | subject_id), 
                df, mask=mask,parallel=c('PBS',100),REML=FALSE,cleanup=TRUE,
                temp_dir='lmer_models/tmp')
   vs_nogeno=mincLmer(relatives ~ timepoint+(1 | subject_id), 
                df, mask=mask,parallel=c('PBS',100),REML=FALSE,cleanup=TRUE,
                temp_dir='lmer_models/tmp')
   quickfdr = mincFDR(mincLmerEstimateDF(vs_full))
   vsfdrGeno = mincFDR(mincLogLikRatio(vs_full,vs_nogeno))
   vsfdrInt = mincFDR(mincLogLikRatio(vs_full,vs_noint))
   save(vs_full,vs_noint,quickfdr,vsfdrGeno,vsfdrInt,file='lmer_models/lmer_models_genotype_effect.RData')
}
load('lmer_models/lmer_models_genotype_effect.RData')

# Let us visualize the interaction term:
mincPlotSliceSeries(anatomy = 'mri_template.mnc' %>% 
                               mincGetVolume %>% mincArray,
                    statistics = vsfdrInt %>% mincArray('vs_full') ,
                    low=0.1,high=0.05,symmetric=FALSE,
                    legend='FDR genotype interaction',
                    begin=60,end=-50)

# Now visualize the overall genotype effect:
mincPlotSliceSeries(anatomy = 'mri_template.mnc' %>% 
                               mincGetVolume %>% mincArray,
                    statistics = vsfdrGeno %>% mincArray('vs_full') ,
                    low=0.1,high=0.05,symmetric=FALSE,
                    legend='FDR genotype',
                    begin=60,end=-50)


dothis = FALSE
if (dothis) {
   vs_full=mincLmer(relatives ~ genotype*ns(timepoint,3)+(timepoint | subject_id),
                df, mask=mask,parallel=c('PBS',100),REML=FALSE,cleanup=TRUE,
                temp_dir='lmer_models/tmp')
   vs_nogeno=mincLmer(relatives ~ ns(timepoint,3)+(timepoint | subject_id), 
                df, mask=mask,parallel=c('PBS',100),REML=FALSE,cleanup=TRUE,
                temp_dir='lmer_models/tmp')
   quickfdr = mincFDR(mincLmerEstimateDF(vs_full))
   vsfdrGeno = mincFDR(mincLogLikRatio(vs_full,vs_nogeno))
   save(vs_full,vs_nogeno,quickfdr,vsfdrGeno,file='lmer_models/lmer_models_genotype_effect_COMPLEX.RData')
}
load('lmer_models/lmer_models_genotype_effect_COMPLEX.RData')

# Now visualize the overall genotype effect:
mincPlotSliceSeries(anatomy = 'mri_template.mnc' %>% 
                               mincGetVolume %>% mincArray,
                    statistics = vsfdrGeno %>% mincArray('vs_full') ,
                    low=0.1,high=0.05,symmetric=FALSE,
                    legend='FDR genotype',
                    begin=60,end=-50)


# There is a neat way to view the effect of 
# genotype over time.
# The trick is to center the timepoint 
# term on the age of interest and run 
# a linear mixed effects model. We can repeat 
# this for all the ages within the study.


# This model looks at the voxel-wise effect of 
# genotype on relative volumes. 
dothis = FALSE
if (dothis) {
   df$sage = df$timepoint - 4
   vs_c04=mincLmer(relatives ~ genotype*sage+(1 | subject_id), 
                df, mask=mask,parallel=c('PBS',100),REML=FALSE,cleanup=TRUE,
                temp_dir='lmer_models/tmp')
   quickfdr = mincFDR(mincLmerEstimateDF(vs_c04))
   save(vs_c04,quickfdr,file='lmer_models/lmer_models_centered_04.RData')
}

dothis = FALSE
if (dothis) {
   df$sage = df$timepoint - 6
   vs_c06=mincLmer(relatives ~ genotype*sage+(1 | subject_id), 
                df, mask=mask,parallel=c('PBS',100),REML=FALSE,cleanup=TRUE,
                temp_dir='lmer_models/tmp')
   quickfdr = mincFDR(mincLmerEstimateDF(vs_c06))
   save(vs_c06,quickfdr,file='lmer_models/lmer_models_centered_06.RData')
}

dothis = FALSE
if (dothis) {
   df$sage = df$timepoint - 8
   vs_c08=mincLmer(relatives ~ genotype*sage+(1 | subject_id), 
                df, mask=mask,parallel=c('PBS',100),REML=FALSE,cleanup=TRUE,
                temp_dir='lmer_models/tmp2')
   quickfdr = mincFDR(mincLmerEstimateDF(vs_c08))
   save(vs_c08,quickfdr,file='lmer_models/lmer_models_centered_08.RData')
}

dothis = FALSE
if (dothis) {
   df$sage = df$timepoint - 12
   vs_c12=mincLmer(relatives ~ genotype*sage+(1 | subject_id), 
                df, mask=mask,parallel=c('PBS',100),REML=FALSE,cleanup=TRUE,
                temp_dir='lmer_models/tmp')
   quickfdr = mincFDR(mincLmerEstimateDF(vs_c12))
   save(vs_c12,quickfdr,file='lmer_models/lmer_models_centered_12.RData')
}

dothis = FALSE
if (dothis) {
   df$sage = df$timepoint - 24
   vs_c24=mincLmer(relatives ~ genotype*sage+(1 | subject_id), 
                df, mask=mask,parallel=c('PBS',100),REML=FALSE,cleanup=TRUE,
                temp_dir='lmer_models/tmp')
   quickfdr = mincFDR(mincLmerEstimateDF(vs_c24))
   save(vs_c24,quickfdr,file='lmer_models/lmer_models_centered_24.RData')
}

# load everything
load('lmer_models/lmer_models_centered_04.RData')
load('lmer_models/lmer_models_centered_06.RData')
load('lmer_models/lmer_models_centered_08.RData')
load('lmer_models/lmer_models_centered_12.RData')
load('lmer_models/lmer_models_centered_24.RData')

### Let us visualize the results
anatomy = 'mri_template.mnc' %>% mincGetVolume %>% mincArray
mincPlotSliceSeries(anatomy = anatomy,
                    statistics = mincArray(vs_c04,'tvalue-genotypeKO'),
                    low=3,high=3.6,symmetric=TRUE,
                    legend='FDR genotype',
                    begin=60,end=-50)
mincPlotSliceSeries(anatomy = anatomy,
                    statistics = mincArray(vs_c06,'tvalue-genotypeKO'),
                    low=3,high=3.6,symmetric=TRUE,
                    legend='FDR genotype',
                    begin=60,end=-50)
mincPlotSliceSeries(anatomy = anatomy,
                    statistics = mincArray(vs_c08,'tvalue-genotypeKO'),
                    low=3,high=3.6,symmetric=TRUE,
                    legend='FDR genotype',
                    begin=60,end=-50)
mincPlotSliceSeries(anatomy = anatomy,
                    statistics = mincArray(vs_c12,'tvalue-genotypeKO'),
                    low=3,high=3.6,symmetric=TRUE,
                    legend='FDR genotype',
                    begin=60,end=-50)
mincPlotSliceSeries(anatomy = anatomy,
                    statistics = mincArray(vs_c24,'tvalue-genotypeKO'),
                    low=3,high=3.6,symmetric=TRUE,
                    legend='FDR genotype',
                    begin=60,end=-50)

############## Clustering analysis

maskvol = mincGetVolume(mask) > 0.5
load('lmer_models/lmer_models_genotype_effect.RData')
fdrmask = (vsfdrGeno < 0.05) & maskvol

dothis = FALSE
if (dothis) {
   anatarr = do.call('rbind',lapply(df$relatives , function(x) mincGetVolume(x)[fdrmask]))

   lwkr = df$timepoint %>% 
           unique %>% sort %>% lapply(function(x) 
                                    (anatarr[df$timepoint == x & df$genotype == 'WT', ] %>% 
                                           apply(2,function(y) log(mean(exp(y))))
                                    ) -
                                    (anatarr[df$timepoint == x & df$genotype == 'KO', ] %>% 
                                           apply(2,function(y) log(mean(exp(y))))
                                    )) %>% do.call(what = 'cbind')
   save(lwkr,file='lwkr.RData')
}
load('lwkr.RData')
mydata <- lwkr
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var))
  for (i in 2:15) wss[i] <- sum(kmeans(mydata,
                                       centers=i)$withinss,nstart=10)
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# Three clusters seems good

nclust = 3
cl = kmeans(mydata,centers=nclust,nstart=20)$cluster
agglwkr = 
   apply(lwkr , 2 , function(x) 
        (aggregate(x, by = list(cl), function(y) mean(y)) %>% arrange(Group.1))[,'x']  ) %>%
   as.data.frame
colnames(agglwkr) = df$timepoint %>% unique %>% sort
agglwkr$cluster = paste0('cl',1:nclust)

pldf = reshape2::melt(agglwkr,id.vars='cluster',variable.name = 'age',value.name = 'lwkr')
pldf$age = as.numeric(as.character(pldf$age))

ggplot(pldf,aes(age,lwkr,colour=cluster))+geom_line()+geom_point()+theme_bw()+geom_hline(yintercept=0) +
  xlab('Days after birth') + ylab('Log wildtype/knockout')


gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 35, c = 100)[1:n]
}


towrite = mincGetVolume('mri_template.mnc') * 0
towrite[fdrmask] = cl
attributes(towrite)$likeVolume = 'mri_template.mnc'

mincPlotSliceSeries(mincArray(mincGetVolume('mri_template.mnc')),
mincArray(towrite),col = gg_color_hue(3),
low=.5,high=3.5,begin=50,end=-50)

