#!/bin/bash
# creates a R script to draw plots from bayescan ouput files
# save the stdout as .R file and run it as
# R CMD yourfile.R
# files will be "bayescan_plots.pdf" and "fst_plots.pdf"
# sometimes the files will be really large, you might want to break it into seperate pdf files

echo "source (\"/data003/GIF/software/packages/bayescan/2.1/R_functions/plot_R.r\")"
# uses plot_bayescan from the bayescan package
for fstfile in $(find $(pwd) -name "*.b_fst.txt"); do
chrname=$(basename $(dirname ${fstfile}));
echo "pdf(\"bayescan_plots_${chrname}.pdf\")"
echo "plot_bayescan(\"${fstfile}\")";
echo "title(\"${chrname}\")";
echo "dev.off()"
done

# simple way to see fst distribution across chromosomes
echo "plot_colors <- c(rgb(r=0.0,g=0.0,b=0.9), \"red\", \"forestgreen\")"
for fstfile in $(find $(pwd) -name "*.b_fst.txt"); do
chrname=$(basename $(dirname ${fstfile}));
echo "pdf(\"fst_plots_${chrname}.pdf\")"
echo "data <- read.table(\"${fstfile}\", header = TRUE, row.names = 1)";
echo "plot(data\$fst, type=\"o\", col=plot_colors[1], ylab=\"Fst\", xlab=\"coordinates\")";
echo "title(\"${chrname} Fst distribution\")";
echo "dev.off()"
done

