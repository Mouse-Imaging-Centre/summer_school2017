Software install notes
================

Some of The software you will need

Packages
--------

### Mac Specific

Brew: <https://brew.sh/> you will likely need gcc: brew install gcc

### Windows

virtual box: <https://www.virtualbox.org/>

### Minc Toolkit

bic-mni.github.io

### Pyminc

github.com/Mouse-Imaging-Centre/pyminc

### Minc-Stuffs

github.com/Mouse-Imaging-Centre/minc-stuffs

### RMINC

github.com/Mouse-Imaging-Centre/RMINC

### Pydpiper

github.com/Mouse-Imaging-Centre/pydpiper

Install Notes
-------------

### Pyminc (mac)

``` bash
brew install python3
git clone --recursive https://github.com/Mouse-Imaging-Centre/pyminc
cd pyminc
python3 setup.py install
# you may need to add this to .bash_profile (maybe)
# LD_LIBRARY_PATH=/opt/minc/1.9.15/minc-toolkit-config.sh:$LD_LIBRARY_PATH
```

### RMINC (mac)

Please note that for install RMINC, there is an [INSTALL](https://github.com/Mouse-Imaging-Centre/RMINC/blob/master/INSTALL) file in the github repo that has some important notes. Especially for mac users, the Fortran linking notes are important. The current brew version of gcc as of this morning is /usr/local/Cellar/gcc/7.2.0/lib/gcc/7 instead of 5.3.0 shown in the INSTALL file.

``` bash
brew install R # only if you don’t have R
```

Do the following all in **the same terminal** (just for installing RMINC)

``` bash
export MINC_PATH=/opt/minc/1.9.15/ # Then run the basic install
R
```

``` r
install.packages("devtools")
devtools::install_github("Mouse-Imaging-Centre/RMINC", dependencies = TRUE)
```

To test the install run

``` r
library(RMINC)
install.packages(c("lmerTest", "testthat")) #you probably need these
runRMINCTestbed()
```

If R complains about anatomy hierarchy those errors are spurious, other errors are potentially problematic.
