# Remaining Useful Life Analysis via Rule-Based XAI models 

This repository contains the code `CMAPS_feature_extraction.m` for preprocessing [NASA Turbofan Jet Engine Data Set](https://www.kaggle.com/datasets/behrad3d/nasa-cmaps) to extract statistical fingerprints (mean, variance, skewness, and kurtosis) from raw time-series. 

Also, original RUL values are used to introduce binary classes by setting a threshold on their values, i.e.:

- RUL > 150: healthy class

- RUL <= 150: fault class

A rule-based XAI model is then trained on the resulting dataset. Rules are provided in `rules/` folder.
