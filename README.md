# Problems
Scripts for problems we discussed in meetings.

## Overview
script | data | date of the meeting | description
------ | ---- | ------------------- | -----------
CicrlePlot_withGGplot | random, created inside the script | November 4, 2015 | Daniel wasn't happy with the way the package `OmicCircos` visualised his data, so we tried to do it better using `ggplot2`. The script creates random data and uses segment and rectangle geoms in polar coordinates to create circular plots.
PlotData_ttest | NA | November 18, 2015 | Haroon asked for help with his data analysis. In this script, we explore how to melt data with `reshape2` and then create different plots with `ggplot2`, using bar, point and boxplot geoms as well as `facet_wrap` for a better overview of the data. We also use "split - apply - combine" to do t tests on different subsets of the data.
splitting_columns | NA | November 25, 2015 | In another data set, Haroon had the problem of a combined identifier for condition and replicate ("Ct1" for "control replicate 1", for example). To be able to do a similar analysis as in the script created before, he had to split this column into two, which we did using `gsub()`.
