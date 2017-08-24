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
  library(lmerTest) # running mixed effect models
  library(splines)  # fitting splines
})
  
setwd("/hpf/largeprojects/MICe/chammill/presentations/summer_school2017/longitudinal_analysis")

# Read CSV file that contains the data we wish to analyze
df = read.csv('tamarack_det.csv',stringsAsFactors = FALSE)

# relevel genotype vector to make reference WT.
df = df %>% mutate(genotype = factor(genotype,levels=c('WT','KO')))

# Let us begin by analyzing structure volumes.
# I ran the code below and saved the result in 
# "anatAbsVols.RData".
# so you only need to load the rdata file.
dothis = FALSE
if (dothis) {
  anatAbsVols = anatGetAll(
     filenames=df$absolutes,
     atlas='/hpf/largeprojects/MICe/dfernandes/asheng_Arhgef/atlas/labels_resampled.mnc',
     defs='/hpf/largeprojects/MICe/tools/atlases/Dorr_2008_Steadman_2013_Ullmann_2013/mappings/Dorr_2008_Steadman_2013_Ullmann_2013_mapping_of_labels.csv',
     method='jacobians',
     side='both',
     parallel=c('PBS',10),
     strict=TRUE)
   save(anatAbsVols,file="anatAbsVols.RData")
}
load('anatAbsVols.RData')

# anatAbsVols is a dataframe that contains structures 
# as columns and rows correspond to each determinant
# in the df$absolutes

# We now want to plot structures and see how they
# look. Lets try the "right Cingulate cortex: area 25"
stroi = "right Cingulate cortex: area 25"
df$struct = anatAbsVols[,stroi]

ggplot(df,aes(timepoint,struct,colour=genotype,group=subject_id))+
   geom_point(alpha=0.2)+
   geom_line(alpha=0.2) + 
   stat_smooth(aes(group=genotype)) +
   ggtitle(stroi) + xlab('Days old') +
   ylab('Volume')

# interesting pattern of volume difference in early 
# life that decreases in later life.
# To do significance testing, we need a good 
# model for growth. 
# Obviously, a linear model is not good
# but lets try it just to see what a poor 
# model looks like.

ggplot(df,aes(timepoint,struct,colour=genotype,group=subject_id))+
   geom_point(alpha=0.2)+
   geom_line(alpha=0.2) + 
   stat_smooth(method='lm',aes(group=genotype)) +
   ggtitle(stroi) + xlab('Days old') +
   ylab('Volume')

mod1 = lmer(struct ~ timepoint*genotype+(timepoint|subject_id),df)
plot(mod1)

# We can see the residuals are biased. Also, its clear that 
# the growth curve is not well fit by a line.
#
# We can fit more complex models using splines.
# Lets try quadratic natural splines:

ggplot(df,aes(timepoint,struct,colour=genotype,group=subject_id))+
   geom_point(alpha=0.2)+
   geom_line(alpha=0.2) + 
   stat_smooth(method = "lm", formula = y ~ ns(x, 2),aes(group=genotype)) +
   ggtitle(stroi) + xlab('Days old') +
   ylab('Volume')

mod1 = lmer(struct ~ ns(timepoint,2)*genotype+(timepoint|subject_id),df)
plot(mod1)


# Now try cubic natural splines:
ggplot(df,aes(timepoint,struct,colour=genotype,group=subject_id))+
   geom_point(alpha=0.2)+
   geom_line(alpha=0.2) + 
   stat_smooth(method = "lm", formula = y ~ ns(x, 3),aes(group=genotype)) +
   ggtitle(stroi) + xlab('Days old') +
   ylab('Volume')

mod1 = lmer(struct ~ ns(timepoint,3)*genotype+(timepoint|subject_id),df)
plot(mod1)

# So quadratic and cubic splines are both good. How can we test 
# which model is best? There is no real good way I know of. 
# Lets start by fitting a linear, quadratic, and cubic models
# and saving the results.

mod_lin = lmer(struct ~ ns(timepoint,1)*genotype+(timepoint|subject_id),df,REML=FALSE)
mod_quad = lmer(struct ~ ns(timepoint,2)*genotype+(timepoint|subject_id),df,REML=FALSE)
mod_cub = lmer(struct ~ ns(timepoint,3)*genotype+(timepoint|subject_id),df,REML=FALSE)

# We can run anova to compare models. Let's compare 
# the quadratic and linear models:
anova(mod_quad , mod_lin)

# You can use multiple criteria to select the best
# models. Some people select the model with the 
# lowest AIC. Others select the model with the lowest 
# BIC. Still select models with the highest logLik.
# THe advantage of this method is that this ratio
# can be significance tested (AKA we can get pvalues
# for it); and the significance is given by Pr(>Chisq).
# All measure show that the quadratic models is 
# wayyyyy better than the linear model.

# Now compare cubic and quadratic
anova(mod_cub , mod_quad)

# There is no real benefit in going from quadratic 
# to cubic growth models. So we can use quadratic
# In practice, I usually run several models with
# varying degrees of complexity to check if 
# results are consistent. 

# Let us also look as the random effects. 
# So far we have fit a random size and random
# growth for each mouse. Let's try different 
# random effects and see what they do.

# Model with random growth and size
mod_grow = lmer(struct ~ ns(timepoint,2)*genotype+(1+timepoint|subject_id),df,REML=FALSE)
## THIS IS SYNONYMOUS WITH
mod_grow = lmer(struct ~ ns(timepoint,2)*genotype+(timepoint|subject_id),df,REML=FALSE)

# Model with random size
mod_size = lmer(struct ~ ns(timepoint,2)*genotype+(1|subject_id),df,REML=FALSE)

# Find predictions using both models
df$growPred = predict(object=mod_grow,newdata=df)
df$sizePred = predict(object=mod_size,newdata=df)

# Let us plot three WildType IDs and see how random
# effects influence predictions.
ID_to_plot = c('B_7_4','A_1_6','A_1_2')
ggplot(df %>% filter(subject_id %in% ID_to_plot),
          aes(timepoint,struct,group=subject_id))+
   geom_point(aes(shape=subject_id))+
   geom_line(aes(y=sizePred,linetype=subject_id)) + 
   ggtitle(paste(stroi,'volume predicted from random size model')) + xlab('Days old') +
   ylab('Volume')
dev.new()
ggplot(df %>% filter(subject_id %in% ID_to_plot),
          aes(timepoint,struct,group=subject_id))+
   geom_point(aes(shape=subject_id))+
   geom_line(aes(y=growPred,linetype=subject_id)) + 
   ggtitle(paste(stroi,'volume predicted from random size+growth model')) + xlab('Days old') +
   ylab('Volume')

# We can see that random size + growth model 
# predicts data better than just random size
# This can be significance tested using
# a log likelihood test.
anova(mod_grow,mod_size)

# Generally, we like having complex random
# effects so we can better fit the data.
# BUT... there can be issues that arise.
# Consider modelling a different structure:

df$struct = anatAbsVols[,'interpedunclar nucleus']
mod_test_gro = lmer(struct ~ ns(timepoint,2)*genotype+(timepoint|subject_id),df,REML=FALSE)  

# Random effect structures that are too complicated, 
# result in failed convergence. Notice, the model below 
# has simpler random effects. This will converge:

mod_test_size = lmer(struct ~ ns(timepoint,2)*genotype+(1|subject_id),df,REML=FALSE)  

# We can still do log likelihood 
# tests with models that failed convergence.
# But best practice is to avoid model 
# failure for structures.

# Now let us repeat a comparison of linear and 
# quadratic splines for all structures.

anatlmerfunc = function(x) {
   df$struct = anatAbsVols[,x]
   mod1 = lmer(struct ~ ns(timepoint,1)*genotype+(timepoint|subject_id),df,REML=FALSE)
   mod2 = lmer(struct ~ ns(timepoint,2)*genotype+(timepoint|subject_id),df,REML=FALSE)
   anv = anova(mod1,mod2)
   return(anv[2,'Pr(>Chisq)'])
}

dothis = FALSE
if (dothis) {
   abs_lin_vs_quad_p = unlist(lapply(colnames(anatAbsVols) , anatlmerfunc))  #find pvalues for all structures
   abs_lin_vs_quad_q = p.adjust(abs_lin_vs_quad_p,method='fdr')   # correct for multiple comparisons
   save(abs_lin_vs_quad_p,abs_lin_vs_quad_q,file="abs_lin_vs_quad.RData")
}
load("abs_lin_vs_quad.RData")

# We can also repeat comparison of individual size
# and individual size+growth models
anatlmerfunc = function(x) {
   df$struct = anatAbsVols[,x]
   mod1 = lmer(struct ~ ns(timepoint,2)*genotype+(1|subject_id),df,REML=FALSE)
   mod2 = lmer(struct ~ ns(timepoint,2)*genotype+(timepoint|subject_id),df,REML=FALSE)
   anv = anova(mod1,mod2)
   return(anv[2,'Pr(>Chisq)'])
}

dothis = FALSE
if (dothis) {
   abs_size_vs_grow_p = unlist(lapply(colnames(anatAbsVols) , anatlmerfunc))  #find pvalues for all structures
   abs_size_vs_grow_q = p.adjust(abs_size_vs_grow_p,method='fdr')   # correct for multiple comparisons
   save(abs_size_vs_grow_p,abs_size_vs_grow_q,file="abs_size_vs_grow.RData")
}
load("abs_size_vs_grow.RData")

# Let us display the results of the size vs growth
# random effects
create_vol <- 
  function(anat, defs , labels,bg=0, combineLeftRight = TRUE ){
    if (is.null(names(anat))) {stop('anat argument must have names')}
    lab_frame <- RMINC:::create_labels_frame(defs)
    if (combineLeftRight) {
    lab_frame <- lab_frame %>% mutate(Structure = gsub("right |left ", "", Structure))
    }
    if (prod(names(anat) %in% lab_frame$Structure) == 0)  {
       stop('anat argument must have names that are structures in defs argument')
    }
    max_lab <- max(lab_frame$label) + 1
    structures <- character(max_lab)
    structures[lab_frame$label + 1] <- lab_frame$Structure
    structures[1] <- "none"
    lab_vol <- mincGetVolume(labels)
    structures <- structures[lab_vol + 1]

    towrite = anat
    vols <- c("none" = bg,towrite)[structures]
    attr(vols,'likeVolume') = labels
    vols
  }

names(abs_size_vs_grow_q) = colnames(anatAbsVols)
statsvol = create_vol(  anat = abs_size_vs_grow_q,
                        defs = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_mapping_of_labels.csv',
                        labels = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_on_MEMRI_C57BL6_P43_labels.mnc',
                        bg=1,
                        combineLeftRight = FALSE)

# Visualize results in RMINC
mincPlotSliceSeries(anatomy = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_on_MEMRI_C57BL6_P43_average.mnc' %>% 
                               mincGetVolume %>% mincArray,
                    statistics = statsvol %>% mincArray ,
                    low=0.01,high=0.001,symmetric=FALSE,
                    legend='size vs growth+size',
                    begin=50,end=-70)

###########################################################################################
# Now for the question that motivates us.
# Is this structure significantly affected
# by mutation?
stroi = "right Cingulate cortex: area 25"
df$struct = anatAbsVols[,stroi]

# There are two ways to assess significance. 
# The best way is similar to how we selected a good
# model. We will run two models: one with a predictor
# of genotype and the other without the effect of 
# genotype.

mod_genotype = lmer(struct ~ ns(timepoint,2)*genotype+(timepoint|subject_id),df,REML=FALSE)
mod_NULL = lmer(struct ~ ns(timepoint,2)+(timepoint|subject_id),df,REML=FALSE)

# Now we ask, does the model mod_genotype (which has 
# genotype as a predictor), fit the data significantly
# better than the model mod_NULL, which does not
# have genotype as a predictor? Once again, we can
# use anova.

anova(mod_genotype , mod_NULL)

# The pvalue for the effect of genotype is given
# in column Pr(>Chisq). We see the effect is 
# highly significant.
# How muct of this effect is driven by the
# interaction effect we noted earlier?

mod_noInterac = lmer(struct ~ ns(timepoint,2) + genotype+(timepoint|subject_id),df,REML=FALSE)
anova(mod_genotype , mod_noInterac)

# We notice a weak trending effect of genotype interaction

# Another way to find significance is using the 
# Satterthwaite approximation. This is automatically
# computed by lmer. Use the summary function to 
# expose these values.

summary(mod_genotype)

# Now that we established a framework for finding 
# significance of one structure, let us find the 
# effect of genotype for all structures.
# I will make a function to find genotype effect for one 
# structure. Then apply it to all structures.

anatlmerfunc = function(x) {
   df$struct = anatAbsVols[,x]
   mod1 = lmer(struct ~ ns(timepoint,2)*genotype+(timepoint|subject_id),df,REML=FALSE)
   mod2 = lmer(struct ~ ns(timepoint,2)+(timepoint|subject_id),df,REML=FALSE)
   anv = anova(mod1,mod2)
   return(anv[2,'Pr(>Chisq)'])
}

dothis = FALSE
if (dothis) {
   abs_effect_genotype_p = unlist(lapply(colnames(anatAbsVols) , anatlmerfunc))  #find pvalues for all structures
   abs_effect_genotype_q = p.adjust(abs_effect_genotype_p,method='fdr')   # correct for multiple comparisons
   save(abs_effect_genotype_p,abs_effect_genotype_q,file="abs_effect_genotype.RData")
}
load('abs_effect_genotype.RData')

# So which structures have significant effects of genotype?
colnames(anatAbsVols) [abs_effect_genotype_q < 0.05]

# Let us visualize our structure-wise results on a brain.
# First run lmer on every structure using the fast 
# anatLm function (not the embarrassingly slow one we just 
# used to find significance).

str_mod = anatLmer(formula = ~ ns(timepoint,2)*genotype+(timepoint|subject_id), 
                   data = df,
                   anat = anatAbsVols)

# Now we will convert our structure statistics into a voxel map (statsvol)
# for display over an MRI atlas.

structure_statistics = str_mod[,'tvalue-genotypeKO']

# Mask structures (set value to 0) which have insignificant 
# effect of genotype.
structure_statistics[abs_effect_genotype_q > 0.05] = 0
 
statsvol = create_vol(  anat = structure_statistics,
                        defs = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_mapping_of_labels.csv',
                        labels = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_on_MEMRI_C57BL6_P43_labels.mnc',
                        bg=0,
                        combineLeftRight = FALSE)



# Visualize results in RMINC
mincPlotSliceSeries(anatomy = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_on_MEMRI_C57BL6_P43_average.mnc' %>% 
                               mincGetVolume %>% mincArray,
                    statistics = statsvol %>% mincArray ,
                    low=0,high=3,symmetric=TRUE,
                    legend='t-statistics Genotype KO',
                    begin=50,end=-70)

# We can repeat the structure analysis for 
# relative volumes. 
dothis = FALSE
if (dothis) {
  anatRelVols = anatGetAll(
     filenames=df$relatives,
     atlas='/hpf/largeprojects/MICe/dfernandes/asheng_Arhgef/atlas/labels_resampled.mnc',
     defs='/hpf/largeprojects/MICe/tools/atlases/Dorr_2008_Steadman_2013_Ullmann_2013/mappings/Dorr_2008_Steadman_2013_Ullmann_2013_mapping_of_labels.csv',
     method='jacobians',
     side='both',
     parallel=c('PBS',10),
     strict=TRUE)
   anatRelVols = scale(anatRelVols)
   save(anatRelVols,file="anatRelVols.RData")
}
load('anatRelVols.RData')

# anatRelVols is a dataframe that contains structures 
# as columns and rows correspond to each determinant
# in the df$relatives

# We now want to plot structures and see how they
# look. Lets try the "right Cingulate cortex: area 25"
stroi = "right Cingulate cortex: area 25"
df$struct = anatRelVols[,stroi]

ggplot(df,aes(timepoint,struct,colour=genotype,group=subject_id))+
   geom_point(alpha=0.2)+
   geom_line(alpha=0.2) + 
   stat_smooth(aes(group=genotype)) +
   ggtitle(stroi) + xlab('Days old') +
   ylab('Relative Volume')

# Notice the over-arching growth patterns that 
# were there from the absolute volumes has been 
# drastically minimized, as relative determinants
# consider volumetric changes after brains are
# scaled to an age-matched consensus average.

# This is particularily advantageous when considering
# growth models. Consider the following two models:
# One fits a linear growth model, the second fits 
# a quadratic growth model:
mod_lin = lmer(struct ~ ns(timepoint,1)*genotype+(timepoint|subject_id),df,REML=FALSE)
mod_quad = lmer(struct ~ ns(timepoint,2)*genotype+(timepoint|subject_id),df,REML=FALSE)

# We can run anova to compare models. Let's compare 
# the quadratic and linear models:
anova(mod_quad , mod_lin)

# Do we need random growth?
mod_grow = lmer(struct ~ timepoint*genotype+(timepoint|subject_id),df,REML=FALSE)
mod_size = lmer(struct ~ timepoint*genotype+(1|subject_id),df,REML=FALSE)
anova(mod_grow , mod_size)

# Lets run a comparison of linear and quadratic models
# for relative volumes for all structures

anatlmerfunc = function(x) {
   df$struct = anatRelVols[,x]
   mod1 = lmer(struct ~ ns(timepoint,1)*genotype+(timepoint|subject_id),df,REML=FALSE)
   mod2 = lmer(struct ~ ns(timepoint,2)*genotype+(timepoint|subject_id),df,REML=FALSE)
   anv = anova(mod1,mod2)
   return(anv[2,'Pr(>Chisq)'])
}

dothis = FALSE
if (dothis) {
   rel_lin_vs_quad_p = unlist(lapply(colnames(anatRelVols) , anatlmerfunc))  #find pvalues for all structures
   rel_lin_vs_quad_q = p.adjust(rel_lin_vs_quad_p,method='fdr')   # correct for multiple comparisons
   save(rel_lin_vs_quad_p,rel_lin_vs_quad_q,file="rel_lin_vs_quad.RData")
}
load("rel_lin_vs_quad.RData")

# We can also repeat comparison of individual size
# and individual size+growth models
anatlmerfunc = function(x) {
   df$struct = anatRelVols[,x]
   mod1 = lmer(struct ~ ns(timepoint,2)*genotype+(1|subject_id),df,REML=FALSE)
   mod2 = lmer(struct ~ ns(timepoint,2)*genotype+(timepoint|subject_id),df,REML=FALSE)
   anv = anova(mod1,mod2)
   return(anv[2,'Pr(>Chisq)'])
}

dothis = FALSE
if (dothis) {
   rel_size_vs_grow_p = unlist(lapply(colnames(anatRelVols) , anatlmerfunc))  #find pvalues for all structures
   rel_size_vs_grow_q = p.adjust(rel_size_vs_grow_p,method='fdr')   # correct for multiple comparisons
   save(rel_size_vs_grow_p,rel_size_vs_grow_q,file="rel_size_vs_grow.RData")
}
load("rel_size_vs_grow.RData")

# Visualize results in RMINC
names(rel_size_vs_grow_q) = colnames(anatRelVols)
statsvol = create_vol(  anat = rel_size_vs_grow_q,
                        defs = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_mapping_of_labels.csv',
                        labels = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_on_MEMRI_C57BL6_P43_labels.mnc',
                        bg=1,
                        combineLeftRight = FALSE)

mincPlotSliceSeries(anatomy = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_on_MEMRI_C57BL6_P43_average.mnc' %>% 
                               mincGetVolume %>% mincArray,
                    statistics = statsvol %>% mincArray ,
                    low=0.05,high=0.01,symmetric=FALSE,
                    legend='size vs growth+size',
                    begin=50,end=-70)



# We no longer need a complicated growth model. So now 
# let us run our anatomical statistics using the
# simpler model.
# Lets find structures significantly affected by 
# genotype. 
anatlmerfunc = function(x) {
   df$struct = anatRelVols[,x]
   mod1 = lmer(struct ~ timepoint*genotype+(timepoint|subject_id),df,REML=FALSE)
   mod2 = lmer(struct ~ timepoint+(timepoint|subject_id),df,REML=FALSE)
   anv = anova(mod1,mod2)
   return(anv[2,'Pr(>Chisq)'])
}


dothis = FALSE
if (dothis) {
   rel_effect_genotype_p = unlist(lapply(colnames(anatRelVols) , anatlmerfunc))  #find pvalues for all structures
   rel_effect_genotype_q = p.adjust(rel_effect_genotype_p,method='fdr')   # correct for multiple comparisons
   save(rel_effect_genotype_p,rel_effect_genotype_q,file="rel_effect_genotype.RData")
}
load('rel_effect_genotype.RData')

str_mod = anatLmer(formula = ~ timepoint*genotype+(timepoint|subject_id), 
                   data = df,
                   anat = anatRelVols)


structure_statistics = str_mod[,'tvalue-genotypeKO']

# Mask structures (set value to 0) which have insignificant 
# effect of genotype.
structure_statistics[rel_effect_genotype_q > 0.05] = 0
 
statsvol = create_vol(  anat = structure_statistics,
                        defs = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_mapping_of_labels.csv',
                        labels = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_on_MEMRI_C57BL6_P43_labels.mnc',
                        bg=0,
                        combineLeftRight = FALSE)



# Visualize results in RMINC
mincPlotSliceSeries(anatomy = 'DSU_atlas/Dorr_2008_Steadman_2013_Ullmann_2013_on_MEMRI_C57BL6_P43_average.mnc' %>% 
                               mincGetVolume %>% mincArray,
                    statistics = statsvol %>% mincArray ,
                    low=0,high=3,symmetric=TRUE,
                    legend='t-statistics Genotype KO',
                    begin=50,end=-70)


