
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MGPMMammals

This R-package contains the data and the R-code for the analysis of the
mammal dataset in the research article (Mitov, Bartoszek, and Stadler
2019) (see References).

## Installation

The easiest way to install this package is to use the function
`install_github()` from the R-package devtools. The following command
will install the most recent version of the master branch from the
github repository of the package.

``` r
devtools::install_github("venelin/MGPMMammals")
```

## License

All R and Rmd code files in MGPMMammals are distributed under the terms
of the [Creative Commons Attribution 4.0 International License (CC
BY 4.0)](https://creativecommons.org/licenses/by/4.0/legalcode).

Special terms apply to the following data-files and objects:

  - MGPMMammals/data/tree.rda and ALL identical or derived tree objects
    describing the mammal phylogenetic tree (i.e. objects of S3 class
    phylo), that are included in the data-files
    MGPMMammals/data/fitMappings\*,
    MGPMMammals/data/bestFitToDataWithSEs.rda,
    MGPMMammals/data/bestModelToDataWithoutSEs.rda,
    MGPMMammals/fits\_bootstrap\_MGPM\_A\_F\_best\_clade\_RR\_HD.rda.
    All of these tree objects are derived from the Mammal phylogenetic
    tree published in (Bininda-Emonds et al. 2007) These data-objects
    are included in MGPMMammals solely for the purpose of
    reproducibility; Hence, the author of MGPMMammals does not hold a
    copyright over any of these data-objects. If you reuse any of these
    tree objects in a publication, please cite this publication as
    explained in the output of the following R-coce
    `print(citation("MGPMMammals"), bibtex = TRUE)` (see next section).
  - MGPMMammals/data-raw/brain\_body\_database\_v2.txt,
    MGPMMammals/data-raw/jeb\_2491\_sm\_tables1.xlsx,
    MGPMMammals/data/data.BoddyEtAl.2.rda, MGPMMammals/data/values.rda,
    MGPMMammals/data/SEs.rda, MGPMMammals/data/valuesPPCA.rda,
    MGPMMammals/data/SEsPPCA.rda as well as ALL identical or derived
    data-objects describing the mammal taxonomy and brain and body-mass
    trait, which are included in in the data-files located in
    MGPMMammals/data/fitMappings\*,
    MGPMMammals/data/bestFitToDataWithSEs.rda,
    MGPMMammals/data/bestModelToDataWithoutSEs.rda,
    MGPMMammals/fits\_bootstrap\_MGPM\_A\_F\_best\_clade\_RR\_HD.rda.
    All of these data objects are derived from the data published in (A.
    M. Boddy et al. 2012) and in the accompanying data-package (Boddy et
    al. 2012). If you reuse any of these data objects in a publication,
    please cite the above article as explained in the following section.

## Citing MGPMMammals

Please, read the following:

``` r
print(citation("MGPMMammals"))
#> 
#> If you use R-code or analysis results from MGPMMammals in
#> publications, please cite the first one of the three articles
#> below. If you use the mammal tree, please, also cite the second
#> article below. If you use brain- and body-mass data from mammal
#> species, please, also cite the third and the fourth articles
#> below.
#> 
#>   Mitov, V., Bartoszek, K., & Stadler, T. (2019). Automatic
#>   generation of evolutionary hypotheses using mixed Gaussian
#>   phylogenetic models. Proceedings of the National Academy of
#>   Sciences of the United States of America, in-press,
#>   http://doi.org/10.1073/pnas.1813823116
#> 
#>   Bininda-Emonds, O. R. P., Cardillo, M., Jones, K. E., MacPhee,
#>   R. D. E., Beck, R. M. D., Grenyer, R., et al. (2007). The
#>   delayed rise of present-day mammals. Nature, 446(7135), 507–512.
#> 
#>   Boddy, A. M., McGowen, M. R., Sherwood, C. C., Grossman, L. I.,
#>   Goodman, M., & Wildman, D. E. (2012). Comparative analysis of
#>   encephalization in mammals reveals relaxed constraints on
#>   anthropoid primate and cetacean brain scaling. Journal of
#>   Evolutionary Biology 25(5), 981–994.
#>   http://doi.org/10.1111/j.1420-9101.2012.02491.x
#> 
#>   Boddy, A. M., McGowen, M. R., Sherwood, C. C., Grossman, L. I.,
#>   Goodman, M., & Wildman, D. E. (2012). Data from: Comparative
#>   analysis of encephalization in mammals reveals relaxed
#>   constraints on anthropoid primate and cetacean brain scaling.
#>   Dryad Digital Repository https://doi.org/10.5061/dryad.5kh0b362
#> 
#> To see these entries in BibTeX format, use 'print(<citation>,
#> bibtex=TRUE)', 'toBibtex(.)', or set
#> 'options(citation.bibtex.max=999)'.
```

## Further information

For additional information about the data objects and scripts in the
package, read [SI Appendix, Section
H](https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental)
from (Mitov, Bartoszek, and Stadler 2019).

# References

<div id="refs" class="references">

<div id="ref-BinindaEmonds:2007bk">

Bininda-Emonds, O. R. P., Cardillo, M., Jones, K. E., MacPhee, et al.
2007. “The Delayed Rise of Present-Day Mammals.” *Nature* 446 (7135):
507–12. <http://www.nature.com/doifinder/10.1038/nature05634>.

</div>

<div id="ref-Boddy:2012dd">

Boddy, A M, M R McGowen, C C Sherwood, L I Grossman, M Goodman, and D E
Wildman. 2012. “Comparative analysis of encephalization in mammals
reveals relaxed constraints on anthropoid primate and cetacean brain
scaling.” *Journal of Evolutionary Biology* 25 (5): 981–94.

</div>

<div id="ref-Boddy:2012bd">

Boddy, A. M., McGowen, M. R., Sherwood, C. C., Grossman, et al. 2012.
“Data from: Comparative Analysis of Encephalization in Mammals Reveals
Relaxed Constraints on Anthropoid Primate and Cetacean Brain Scaling.”
*Dryad Digital Repository*. <https://doi.org/10.5061/dryad.5kh0b362>.

</div>

<div id="ref-Mitov:2019a">

Mitov, Venelin, Krzysztof Bartoszek, and Tanja Stadler. 2019. “Automatic
Generation of Evolutionary Hypotheses Using Mixed Gaussian Phylogenetic
Models.” *Proceedings of the National Academy of Sciences of the United
States of America*.
<https://www.pnas.org/lookup/doi/10.1073/pnas.1813823116>.

</div>

</div>
