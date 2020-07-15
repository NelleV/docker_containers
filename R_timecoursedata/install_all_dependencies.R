if(!require("devtools")){
    install.packages("devtools")
}

if(!require("testthat")){
    install.packages("testthat")
}


if(!require(knitr)){
    install.packages("knitr")
}

if(!require(rmarkdown)){
    install.packages("rmarkdown")
}

if(!require(roxygen2)){
    install.packages("roxygen2")
}


if(!(require(pkgdown))){
    install.packages("pkgdown")
}

if (!require("BiocManager")){
    install.packages("BiocManager")
}

if(!(require(BiocCheck))){
    BiocManager::install("BiocCheck")
}


