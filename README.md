Git repository generated for the manuscript "Zebrafish as a drug discovery platform targeting mitochondrial metabolism in neurodegenerative diseases: A systematic review and meta-analysis" in Molecular Neurobiology journal


# Data and results
The data collected by this study is in the data folder and the results files of this pipeline generated for the manuscript  are in the results folder.

# Install

For network management (needs python):
```
    pip install NetAnalyzer
```

For enrichment analysis (needs R):
```
    Rscript -e 'install.packages("devtools", repos="http://cran.us.r-project.org")'
    Rscript -e 'devtools::install_github("seoanezonjic/ExpHunterSuite", dependencies=TRUE)'
    
```

Then to make PATH accesible the main scripts execute the following two lines and add the third to your .bashrc or .profile files
```
    mkdir install_folder
    Rscript -e "ExpHunterSuite::install_DEgenes_hunter('install_folder')"
    export PATH=path_to_install_folder:$PATH
```
