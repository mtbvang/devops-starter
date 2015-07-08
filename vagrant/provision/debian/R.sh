#!/usr/bin/env bash

R_HOME=~/R

echo $R_HOME

wget http://cran.rstudio.com/src/base/R-3/R-3.1.2.tar.gz
mkdir $R_HOME
mv R-3.1.2.tar.gz $R_HOME/
cd $R_HOME/
tar zxvf R-3.1.2.tar.gz
cd R-3.1.2/
sudo apt-get install gfortran libreadline6-dev libx11-dev libxt-dev
./configure
make
sudo make install

Rscript -e "install.packages('ggplot2', dependencies=TRUE)"
Rscript -e "ITDB <- read.csv('/vagrant/IT.csv')"
Rscript -e "source('Functions for Benchmark and RCF.R')"