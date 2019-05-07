
<!-- README.md is generated from README.Rmd. Please edit that file -->
MGPMMammals
===========

Contains the code and fitted models of the mammal data analysis for the research article entitled "Automatic Generation of Evolutionary Hypotheses using Mixed Gaussian Phylogenetic Models".

Installation
------------

This package contains large data files and is not intended for release on CRAN. The recommended way to use this package is to follow these steps:

-   Clone the package repository from github using the command (type the following three commands in your terminal / shell):

        git clone https://github.com/venelin/MGPMMammals.git

-   Enable git large file system (LFS) in your working copy:

        git lfs install

-   Pull the binary data from the LFS

        git pull

-   Install the package from your local working copy (type the following command in your R interpreter). Note that the directory MGPMMammals should be in your current directory from which R is running:

``` r
install.packages("MGPMMammals", repos=NULL, type="source")
```
