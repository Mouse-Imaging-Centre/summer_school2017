
What is a command line or terminal?
-----------------------------------

-   Open terminal
    -   on Mac: command + space -&gt; Terminal
    -   on Windows: use ssh client, e.g. cygwin
-   Basically a text-based interface
-   Can enter commands & feedback given as text

### why bother?

-   manipulate data
-   run registration pipeline in terminal
-   faster to navigate through folders

ssh
---

-   you can use terminal to log into other computers connected to same network
-   ssh: secure shell
-   login to network here using following username + password

``` bash
dvousden  password: dvousden123
ssh username@location
ssh -X username@location
```

-   first make sure everyone connected to wifi (Chris)
-   now try logging into our network

``` bash
ssh username@172.16.128.140
```

The Shell, Bash
---------------

-   within a terminal you have what is known as shell: defines how terminal will behave & runs commands
-   most common is bash
-   can check type of shell you have by looking at environment variable.
-   use echo command

``` bash
echo $SHELL
```

    ## /bin/bash

-   make sure says ‘bash’

Shortcuts
---------

-   commands stored in history
-   push up arrow to go backwards through history
-   `history`
-   ctrl + R to search history

Moving around the system
------------------------

``` bash
pwd  # tells you where you are, same structure as folders that you’re used to clicking
ls  # shows you what’s there 
```

    ## /hpf/largeprojects/MICe/chammill/presentations/summer_school2017/intro_to_bash
    ## intro_to_bash_slides20170821.md
    ## intro_to_bash_slides20170821.Rmd
    ## intro_to_bash_slides20170821.Rmd~

getting help & giving commands arguments
----------------------------------------

-   a lot of commands also take arguments
-   commands also have help pages or manuals to show you how to use them
-   `man`
-   q to quit

<!-- -->

    ls [-ABCFG…] [file ..]

    - tells you that ls ‘list directory contents’
    - possible arguments are all the letters
    - you can also give ls the name of a particular file and it will give you information about that file

``` bash
ls -l  # gives you long output (who created file, date of creation, size of file) 
#ls -l DIRECTORY # shows you what’s in that directory 
```

    ## total 77
    ## -rw-r--r-- 1 chammill mice 5466 Aug 21 15:42 intro_to_bash_slides20170821.md
    ## -rw-r--r-- 1 chammill mice 3758 Aug 21 15:49 intro_to_bash_slides20170821.Rmd
    ## -rw-r--r-- 1 chammill mice 3757 Aug 21 15:47 intro_to_bash_slides20170821.Rmd~

Paths
-----

-   whenever we refer to a file or directory on a command line, we have to use that file’s path
-   path is like the address, where to find the file or folder
-   absolute vs. relative paths
-   directories are organized hierarchically
    -   top is root /
    -   absolute paths specify location starting from root

``` bash
ls /home/Dulcie/Documents 
```

-   relative paths specify location in relation to where you currently are

``` bash
#ls Documents 
ls ~   # shortcut for home directory
ls .    # shortcut for current directory
ls ../  # shortcut for parent directory 
```

Moving around
-------------

``` bash
pwd
cd ..
pwd 
```

    ## /hpf/largeprojects/MICe/chammill/presentations/summer_school2017/intro_to_bash
    ## /hpf/largeprojects/MICe/chammill/presentations/summer_school2017

-   shortcut: tab completion

``` bash
# cd Doc   # show tab completion
```

Create new directory
--------------------

``` bash
mkdir banana
cd banana 
pwd
ls
cd ..
rmdir banana
```

Environment variables
---------------------

-   There are a number of different environment variables
-   one important one is called PATH

``` bash
echo $PATH
```

    ## /home/chammill/bin:/home/chammill/.local/bin:/hpf/largeprojects/MICe/chammill/local/bin:/home/chammill/local/bin:/axiom2/projects/software/arch/linux-xenial-xerus/Fiji/1.51n/bin:/axiom2/projects/software/arch/linux-xenial-xerus/R/3.2.3/bin:/axiom2/projects/software/arch/linux-xenial-xerus/MICe-lab/0.14/bin:/axiom2/projects/software/arch/linux-xenial-xerus/pydpiper/2.0.8/bin:/axiom2/projects/software/arch/linux-xenial-xerus/minc-stuffs/0.1.20/bin:/axiom2/projects/software/arch/linux-xenial-xerus/pyminc/0.51/bin:/axiom2/projects/software/arch/linux-xenial-xerus/python/3.6.2/bin:/axiom2/projects/software/arch/linux-xenial-xerus/minc-toolkit/1.9.15/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/OGS/bin/linux-x64:/axiom2/projects/software/arch/linux-xenial-xerus/OCCIviewer/bin:/axiom2/projects/software/arch/linux-xenial-xerus/bin:/axiom2/projects/software/arch/linux-xenial-xerus/src/mrtrix3/release/bin:/usr/games:/usr/local/games:/snap/bin

-   this tells the computer where to look for programs and software packages
-   if you are having problems running a certain program, sometimes it’s because you haven’t told the computer where to look

-   environment variables can be specified in .bashrc

``` bash
less ~/.bashrc
```

The MICe treasure hunt
----------------------

``` bash
mkdir /tmp/treasure
cd /tmp/treasure
perl /axiom2/projects/software/arch/linux-3_2_0-36-generic-x86_64-eglibc-2_15/bin/treasureHunt.pl
```

Let's have a look at the first clue

``` bash
ls 
```

    ## intro_to_bash_slides20170821.md
    ## intro_to_bash_slides20170821.Rmd
    ## intro_to_bash_slides20170821.Rmd~

when done you can delete directory

``` bash
rm -rf /tmp/treasure
```

Troubleshooting login
---------------------

Offending RSA key in /Users/Dulcie/.ssh/known\_hosts:12

     sed -i '6d' ~/.ssh/known_hosts
     perl -pi -e 's/\Q$_// if ($. == 6);' ~/.ssh/known_hosts
