
Getting set up
--------------

1.  WiFi
2.  Open firefox to 172.16.128.140:8787
3.  Log in with your MICe credentials
4.  Set you paths:

``` r
Sys.setenv(PATH = "/axiom2/projects/software/arch/linux-precise/bin/:/OGS/bin/linux-x64:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
           , PYTHONPATH = "/axiom2/projects/software/arch/linux-precise/python/"
           , LD_LIBRARY_PATH = "/axiom2/projects/software/arch/linux-precise/lib/:/axiom2/projects/software/arch/linux-precise/lib/InsightToolkit/")
```

Intro To R
----------

R is a statistical computing environment and an interpretted programming language "designed by statisticians for statisticians"^TM

You don't need to be a programmer to use R

But it helps to know some programming.

R Basics
--------

R is all about data and transformations of data. The most fundamental type of data in R is the **vector**. A vector is a one dimensional array of information.

We'll take the R provided vector `LETTERS` as an example.

Input the following line and press enter

``` r
LETTERS
```

    ##  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q"
    ## [18] "R" "S" "T" "U" "V" "W" "X" "Y" "Z"

R is an interpretted language. When you issue a command in the console, the R interpretter will give output any response it might have.

The above line asks the R interpretter to print the value of `LETTERS`. R will print the result of any computation aprovided at the command line automatically. Printing to the console can also be specified manually

``` r
print(LETTERS)
```

    ##  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q"
    ## [18] "R" "S" "T" "U" "V" "W" "X" "Y" "Z"

The `print` command comes in handy when you want to print intermediate results of a computation.

Creating your own vectors
-------------------------

To construct a vector, R provides the `c` function, to construct a vector from elements.

``` r
c(1,2,3,4,5)
```

    ## [1] 1 2 3 4 5

R also provides a short hand for creating numerical sequences

``` r
1:5
```

    ## [1] 1 2 3 4 5

Subsetting
----------

Sometimes you only want specific elements from a vector. The way to do this in R is the `[` operator.

``` r
LETTERS[5]
```

    ## [1] "E"

``` r
LETTERS[c(2,3)]
```

    ## [1] "B" "C"

``` r
LETTERS[-(4:25)]
```

    ## [1] "A" "B" "C" "Z"

An important note - R indexes from 1. This is an oddity for modern programming languages, most index from zero.

### No Scalars

If you experience with other programming languages you might expect R to make the distinction between vectors and their single element counterparts. R does not make this distinction. An element of a vector is just a one element vector

``` r
LETTERS[1][1][1][1]
```

    ## [1] "A"

Recap Vectors
-------------

1.  Vectors are 1D arrays of elements
2.  Vectors can be made by `c`onstructing them
3.  Vectors can be subset with `[` by single elements, vectors of elements, and removal
4.  R indexes from 1
5.  There are no scalars

Assignment
----------

Often you want to save the result of a computation. R, like all languages, provides a mechanism to assign values to names (Pro Secret: It's actually the opposite). Names need to start with a letter, but may contain the special characters `_` and `.` as well as numbers

To assign values in R we use the `<-` assignment operator. Yet another case where R is a bit weird.

``` r
an_appropriate_name1 <- 1:5

an_appropriate_name1
```

    ## [1] 1 2 3 4 5

And elements of vectors can be assigned in place

``` r
an_appropriate_name1[1] <- 10

an_appropriate_name1
```

    ## [1] 10  2  3  4  5

Lists
-----

The second most fundamental data type in R is the list. Vectors are collections of elements with a given type (like numbers or letters), whereas lists are collections of whatever you'd like.

Lists can be made with the `list` function

``` r
l <- list(a = 5, b = "words", c = list())
l
```

    ## $a
    ## [1] 5
    ## 
    ## $b
    ## [1] "words"
    ## 
    ## $c
    ## list()

Lists can be subset like vectors and assigned like vectors

``` r
l[2:3] <- list("ardvark", 10)
l
```

    ## $a
    ## [1] 5
    ## 
    ## $b
    ## [1] "ardvark"
    ## 
    ## $c
    ## [1] 10

The subsetting operator (`[`) for lists returns a list containing the selected elements. To get a specific element out a list, you need the `[[` operator.

``` r
l[2]
```

    ## $b
    ## [1] "ardvark"

``` r
l[[2]]
```

    ## [1] "ardvark"

Lists can contain both named and unnamed elements. Named elements can be accessed directly with the `$` operator.

``` r
l$a
```

    ## [1] 5

Assignment and Lists Recap
--------------------------

1.  Values can be assigned to names with the `<-` operator
2.  Elements of vectors can be assigned in place
3.  Lists are collections of arbitrary elements
4.  Lists can be created with the `list` function with either named or unnamed elements
5.  Lists can be subset and assigned like vectors
6.  List elements can be accessed with `[[` operators
7.  Named list elements can be accessed with the `$` operator

Data Frames
-----------

The next data type to cover and one of the most important is the `data.frame`. Data frames are analogous to a sheet in excel or a table in a database. They are rectangular arrays of data, each column must have the same number of elements. Each column can contain elements of only one type, but data may differ in type across the rows. In R a data frame is a special case of a list of vectors.

``` r
frame <- data.frame(subject = 1:20,
                    group = sample(c("A", "B"), 20, replace = TRUE),
                    measurement = rnorm(20))

frame
```

    ##    subject group measurement
    ## 1        1     A   1.2324274
    ## 2        2     B   1.0043039
    ## 3        3     B   0.5513703
    ## 4        4     A  -0.6494055
    ## 5        5     B   0.3623714
    ## 6        6     B  -1.1274965
    ## 7        7     B   0.8210316
    ## 8        8     A  -0.5428193
    ## 9        9     B  -1.8431269
    ## 10      10     B  -2.9294178
    ## 11      11     A   0.1484543
    ## 12      12     B  -0.1895298
    ## 13      13     B  -1.5272545
    ## 14      14     B  -0.5400599
    ## 15      15     B  -0.6554384
    ## 16      16     B   0.4841818
    ## 17      17     A  -1.1227627
    ## 18      18     B  -0.5647752
    ## 19      19     B   1.9535241
    ## 20      20     A  -0.3197201

*Note the bonus functions `sample` (choosing random elements from a vector), and `rnorm` (normally distributed random numbers), don't worry about them yet*

I can treat my `data.frame` exactly like the `list` that it is, and extract the 'measurement' column

``` r
frame$measurement
```

    ##  [1]  1.2324274  1.0043039  0.5513703 -0.6494055  0.3623714 -1.1274965
    ##  [7]  0.8210316 -0.5428193 -1.8431269 -2.9294178  0.1484543 -0.1895298
    ## [13] -1.5272545 -0.5400599 -0.6554384  0.4841818 -1.1227627 -0.5647752
    ## [19]  1.9535241 -0.3197201

Observe that measurment is in fact a vector of numbers.

Data frames can also be subset by row and columns simultaneously to extract element.

``` r
frame[5, "group"]
```

    ## [1] B
    ## Levels: A B

And we can see that we can pull values out of the data frame. This notation can also be used to get entire rows and columns

``` r
frame[5,]
```

    ##   subject group measurement
    ## 5       5     B   0.3623714

``` r
frame[,2]
```

    ##  [1] A B B A B B B A B B A B B B B B A B B A
    ## Levels: A B

New columns can be added by subset assignment

``` r
frame$test <- rnorm(10)

frame
```

    ##    subject group measurement        test
    ## 1        1     A   1.2324274  0.66751963
    ## 2        2     B   1.0043039  0.09711311
    ## 3        3     B   0.5513703  0.43984527
    ## 4        4     A  -0.6494055 -0.32345796
    ## 5        5     B   0.3623714 -0.47167342
    ## 6        6     B  -1.1274965 -0.93658025
    ## 7        7     B   0.8210316  0.15564069
    ## 8        8     A  -0.5428193  0.25204733
    ## 9        9     B  -1.8431269 -0.80231671
    ## 10      10     B  -2.9294178 -0.46787267
    ## 11      11     A   0.1484543  0.66751963
    ## 12      12     B  -0.1895298  0.09711311
    ## 13      13     B  -1.5272545  0.43984527
    ## 14      14     B  -0.5400599 -0.32345796
    ## 15      15     B  -0.6554384 -0.47167342
    ## 16      16     B   0.4841818 -0.93658025
    ## 17      17     A  -1.1227627  0.15564069
    ## 18      18     B  -0.5647752  0.25204733
    ## 19      19     B   1.9535241 -0.80231671
    ## 20      20     A  -0.3197201 -0.46787267

And columns can be erased by setting the column to `NULL`, a special R object indicating nothingness.

``` r
frame$test <- NULL

frame
```

    ##    subject group measurement
    ## 1        1     A   1.2324274
    ## 2        2     B   1.0043039
    ## 3        3     B   0.5513703
    ## 4        4     A  -0.6494055
    ## 5        5     B   0.3623714
    ## 6        6     B  -1.1274965
    ## 7        7     B   0.8210316
    ## 8        8     A  -0.5428193
    ## 9        9     B  -1.8431269
    ## 10      10     B  -2.9294178
    ## 11      11     A   0.1484543
    ## 12      12     B  -0.1895298
    ## 13      13     B  -1.5272545
    ## 14      14     B  -0.5400599
    ## 15      15     B  -0.6554384
    ## 16      16     B   0.4841818
    ## 17      17     A  -1.1227627
    ## 18      18     B  -0.5647752
    ## 19      19     B   1.9535241
    ## 20      20     A  -0.3197201

Data frame Recap
----------------

1.  Data frames are rectangular arrays of data
2.  A data frame is a list of vectors of all the same length
3.  Each column vector can have its own type
4.  Data frame can be created with the `data.frame` function
5.  List style subsetting works for data frames (`[`, `[[`, `$`)
6.  Array style subsetting works for data frame (`[,]`)
7.  Columns can be added by subset assignment
8.  Columns can be removed by assigning `NULL` to a column

Finally, An Example
-------------------

Before we start we need some data to look at. Creating data frames in R is a pain, so we're going to need a function to read in data. The most common type of data you will access is in the `csv` format.

To get some example data, we will use the `read.csv` function, with no added arguments. This is only possible becasue the csv is nicely formatted. Many hours can be spent learning the ins and outs of reading data.frames into R, so I will gloss over this problem.

``` r
ex <- 
  read.csv("/hpf/largeprojects/MICe/chammill/presentations/summer_school2017/intro_to_R/fixed_datatable_IRdose.csv", 
           stringsAsFactors = FALSE)
```

*Note there is one added argument - `stringsAsFactors`. Remembering to set this to `FALSE` will save many headaches. In fact it is a good practice to run `options(stringsAsFactors = FALSE)` at the beginning of R session/script*

A useful tool for getting a sense of what's in any R object is the `str` function. This tells you about the structure of the object.

``` r
str(ex)
```

    ## 'data.frame':    41 obs. of  10 variables:
    ##  $ MouseID            : chr  "4.1.La" "4.1.Lb" "4.1.Lac" "4.1.Ra" ...
    ##  $ Sex                : chr  "M" "M" "M" "F" ...
    ##  $ Dose               : int  0 3 7 0 3 5 0 3 5 7 ...
    ##  $ Litter             : num  4.1 4.1 4.1 4.1 4.1 4.1 4.2 4.2 4.2 4.2 ...
    ##  $ Coil               : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ ScanDate           : chr  "03-Dec-12" "03-Dec-12" "03-Dec-12" "03-Dec-12" ...
    ##  $ original_mnc       : chr  "/projects/egerek/lbernas/Irradiation_behaviour_project/MR_data/distortion_corrected/fixed_03dec12.1.jan2011_distortion_correcte"| __truncated__ "/projects/egerek/lbernas/Irradiation_behaviour_project/MR_data/distortion_corrected/fixed_03dec12.2.jan2011_distortion_correcte"| __truncated__ "/projects/egerek/lbernas/Irradiation_behaviour_project/MR_data/distortion_corrected/fixed_03dec12.3.jan2011_distortion_correcte"| __truncated__ "/projects/egerek/lbernas/Irradiation_behaviour_project/MR_data/distortion_corrected/fixed_03dec12.4.jan2011_distortion_correcte"| __truncated__ ...
    ##  $ Jacobfile_scaled   : chr  "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.1.jan2011_distortion_c"| __truncated__ "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.2.jan2011_distortion_c"| __truncated__ "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.3.jan2011_distortion_c"| __truncated__ "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.4.jan2011_distortion_c"| __truncated__ ...
    ##  $ Jacobfile_scaled0.2: chr  "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.1.jan2011_distortion_c"| __truncated__ "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.2.jan2011_distortion_c"| __truncated__ "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.3.jan2011_distortion_c"| __truncated__ "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.4.jan2011_distortion_c"| __truncated__ ...
    ##  $ Jacobfile_scaled0.5: chr  "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.1.jan2011_distortion_c"| __truncated__ "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.2.jan2011_distortion_c"| __truncated__ "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.3.jan2011_distortion_c"| __truncated__ "/projects/moush/lbernas/Irradiation_behaviour_project/fixed_build_masked_23mar13_processed/fixed_03dec12.4.jan2011_distortion_c"| __truncated__ ...

Here we can see there is are 10 columns, some of which are numeric, some strings (character). Pardon the ugly printing of the filenames.

You can also get a sense for what's in a data frame by looking at the column names

``` r
names(ex)
```

    ##  [1] "MouseID"             "Sex"                 "Dose"               
    ##  [4] "Litter"              "Coil"                "ScanDate"           
    ##  [7] "original_mnc"        "Jacobfile_scaled"    "Jacobfile_scaled0.2"
    ## [10] "Jacobfile_scaled0.5"

First Statistics
----------------

R comes with a rich library of functions that tell you interesting properties about vectors.

Here's a quick assortment of some summary functions built in to R

``` r
length(ex$Dose)
```

    ## [1] 41

``` r
mean(ex$Dose)
```

    ## [1] 3.731707

``` r
median(ex$Dose)
```

    ## [1] 3

``` r
sd(ex$Dose)
```

    ## [1] 2.588671

``` r
min(ex$Dose)
```

    ## [1] 0

``` r
range(ex$Dose)
```

    ## [1] 0 7

``` r
summary(ex$Dose)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.000   3.000   3.000   3.732   5.000   7.000

``` r
unique(ex$Sex)
```

    ## [1] "M" "F"

``` r
table(ex$Sex)
```

    ## 
    ##  F  M 
    ## 22 19

A Simple Linear Model
---------------------

For a toy example let's test the hypothesis that the dose adminstered to the mice doesn't depend on sex.

R provides a convenient model specification format, often called the formula interface:

<response> ~ <covariate 1> + <covariate 2>

``` r
lmod <- lm(Dose ~ Sex, data = ex)

lmod
```

    ## 
    ## Call:
    ## lm(formula = Dose ~ Sex, data = ex)
    ## 
    ## Coefficients:
    ## (Intercept)         SexM  
    ##      3.5455       0.4019

``` r
summary(lmod)
```

    ## 
    ## Call:
    ## lm(formula = Dose ~ Sex, data = ex)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -3.9474 -0.9474 -0.5455  1.4545  3.4545 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)   3.5455     0.5572   6.363 1.62e-07 ***
    ## SexM          0.4019     0.8185   0.491    0.626    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2.614 on 39 degrees of freedom
    ## Multiple R-squared:  0.006144,   Adjusted R-squared:  -0.01934 
    ## F-statistic: 0.2411 on 1 and 39 DF,  p-value: 0.6262
