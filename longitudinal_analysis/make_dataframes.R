library(dplyr)

idfiles = '/hpf/largeprojects/MICe/dfernandes/asheng_Arhgef/Group2_LongitudinalFiles_cleaned_with_id_new.csv'
twolvlfiles = '/hpf/largeprojects/MICe/dfernandes/asheng_Arhgef/resampled_determinants_fixed.csv'


   df = read.csv(twolvlfiles,stringsAsFactor = FALSE) 
   df$subject_id = paste0(df$group,'_',df$litter,'_',df$mouse)       # make column of subject ids
   colnames(df)[colnames(df) == 'age'] = 'timepoint'                 # rename age to timepoint
   df = df[ ,c("subject_id", "timepoint", "fwhm", 
               "resampled_log_nlin_det", "resampled_log_full_det") ] # subset only columns you need

   regpath = '/hpf/largeprojects/MICe/bdarwin/2017-03-asheng-Arghef-neonatal/tamarack/'
   firstlvl.regdir = 'arghef_group2_first_level/'
   fullfirstlvlpath = paste0(regpath,firstlvl.regdir)

   # all files are relative paths. Make them full paths
   df$resampled_log_nlin_det = paste0(regpath, df$resampled_log_nlin_det) 

   # for some reason some files are missing firstlvl.regdir . Create boolean vector identifying them
   bool = !grepl(fullfirstlvlpath,df$resampled_log_nlin_det)

   # within firstlvl.regdir, the files are in subfolders indexed by image age.
   # To find files we will replace this subfolder with wildcard * and use ls to resolve
   fullfirstlvlpathsubdir = paste0(fullfirstlvlpath,"*/")
   files.with.wildcard = gsub(regpath, fullfirstlvlpathsubdir,df$resampled_log_nlin_det[bool])
   df$resampled_log_nlin_det[bool] = sapply(paste('ls',files.with.wildcard),
                                            function(x) system(x,intern=TRUE)) %>% 
                                     unname

   # repeat with absolutes
   df$resampled_log_full_det = paste0(regpath, df$resampled_log_full_det) 

   # for some reason some files are missing firstlvl.regdir . Create boolean vector identifying them
   bool = !grepl(fullfirstlvlpath,df$resampled_log_full_det)

   # within firstlvl.regdir, the files are in subfolders indexed by image age.
   # To find files we will replace this subfolder with wildcard * and use ls to resolve
   fullfirstlvlpathsubdir = paste0(fullfirstlvlpath,"*/")
   files.with.wildcard = gsub(regpath, fullfirstlvlpathsubdir,df$resampled_log_full_det[bool])
   df$resampled_log_full_det[bool] = sapply(paste('ls',files.with.wildcard),
                                            function(x) system(x,intern=TRUE)) %>% 
                                     unname   

   df2 = read.csv(idfiles,stringsAsFactor = FALSE)
   df = inner_join(df2,df,by=intersect(colnames(df2),colnames(df))) %>% filter(fwhm == 0.2)

   genotype = c('WT','KO')
   genotype = data.frame(litter = c(1,2,5,6,7,8,9) , genotype = genotype[c(1,2,2,2,1,2,1)] )

   df = inner_join(df , genotype , by='litter')

# We want relative volumes to be defined relative to the average age-matched brain
# This is given by the 'resampled_log_nlin_det' column
relatives = df$resampled_log_nlin_det
df$resampled_log_nlin_det = NULL

# We want absolutes to be true absolutes that requires some funky string manipulation.
isFinalTime = df$timepoint == 12

absoluteNOTfinTime = paste('ls',df$resampled_log_full_det[!isFinalTime] %>% gsub(pattern='/resampled/',replacement='/stats-volumes/') %>% dirname %>% paste0("/concat*_log_det_abs_fwhm0.2.mnc")) %>% lapply(function(x) system(x,intern=TRUE)) %>% unlist

absoluteFINTime = paste('ls',df$resampled_log_full_det[isFinalTime] %>% gsub(pattern='/resampled/',replacement='/stats-volumes/') %>% dirname %>% paste0("/*_log_det_abs_fwhm0.2.mnc")) %>% lapply(function(x) system(x,intern=TRUE)) %>% unlist

absolutes = df$resampled_log_full_det
absolutes[isFinalTime] = absoluteFINTime
absolutes[!isFinalTime] = absoluteNOTfinTime

df$resampled_log_full_det = NULL

df$absolutes = absolutes
df$relatives = relatives

write.csv(df,file='tamarack_det.csv',row.names=FALSE)



longfiles = '/hpf/largeprojects/MICe/dfernandes/asheng_Arhgef/arghef_group2_analysis_files.csv'


   df = read.csv(longfiles,stringsAsFactor = FALSE) 
   df2 = read.csv(idfiles,stringsAsFactor = FALSE) 
   df = inner_join(df2,df,by = c('subject_id','timepoint')) %>% filter(fwhm == 0.2)

   genotype = c('WT','KO')
   genotype = data.frame(  litter = c(1,2,5,6,7,8,9) , 
                           genotype = genotype[c(1,2,2,2,1,2,1)] )    

   df = inner_join(df , genotype , by='litter')

write.csv(df,file='regchain_det.csv',row.names=FALSE)



