# Copyright 2019 Venelin Mitov
#
# This file is part of MGPMMammals.
#
# MGPMMammals is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# For information on the MGPMMammals package including its license, please
# read this web page: <https://venelin.github.io/MGPMMammals/index.html>.

#' Combined trait value and measurement error data for 629 mammal species.
#'
#' This dataset is compiled, based on the data published in
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @format This data is formatted as a data.table object with 629 lines and 16 columns.
#' @references
#' \enumerate{
#' \item{Mitov et al. 2019:}{ Mitov, V., Bartoszek, K., & Stadler, T. (2019). Automatic generation of evolutionary
#' hypotheses using mixed Gaussian phylogenetic models. Proceedings of the National",
#' Academy of Sciences of the United States of America. \url{http://doi.org/10.1073/pnas.1813823116}.}
#' \item{Bininda-Emonds et al. 2007: }{Bininda-Emonds, O. R. P., Cardillo, M., Jones, K. E.,
#' MacPhee, R. D. E., Beck, R. M. D., Grenyer, R., et al. (2007).
#' The delayed rise of present-day mammals. Nature, 446(7135), 507–512.
#' \url{http://doi.org/10.1038/nature05634}.}
#' \item{Boddy et al. 2012a:}{ Boddy, A. M., McGowen, M. R., Sherwood, C. C., Grossman, L. I., Goodman, M.,
#' & Wildman, D. E. (2012). Comparative analysis of encephalization in mammals
#' reveals relaxed constraints on anthropoid primate and cetacean brain scaling.
#' Journal of Evolutionary Biology,
#' 25(5), 981–994. \url{http://doi.org/10.1111/j.1420-9101.2012.02491.x}}
#' \item{Boddy et al. 2012b:}{ Boddy AM, McGowen MR, Sherwood CC, Grossman LI, Goodman M, Wildman DE (2012)
#' Data from: Comparative analysis of encephalization in mammals reveals relaxed constraints
#' on anthropoid primate and cetacean brain scaling. Dryad Digital Repository.
#' \url{https://doi.org/10.5061/dryad.5kh0b362}.}
#' }
"data.BoddyEtAl.2"

#' Phylogenetic tree of 629 mammal species
#'
#' This tree is extracted from Bininda-Emonds et al. 2007 (see references below).
#'
#' @format The tree is stored in the form a phylo object.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"tree"


#' Brain and body mass measurements for 629 mammal species
#'
#' This data-object is extracted from the supplementary data accompanying Boddy et al. 2012 (see References below).
#'
#' @format The trait data is stored in the form of a 2 x 629 numerical matrix.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"values"

#' Estimated measurement standard error for the brain and body mass of 629 mammal species
#'
#' The standard errors have been estimated based on the datasets published in
#' Boddy et al. 2012a and Boddy et al. 2012b (see references below).
#'
#' @format The data is stored in the form of a 2 x 629 numerical matrix.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"SEs"

#' Phylogenetic principal component transformation of the brain and body-mass data found in values object.
#'
#' @format The data is stored in the form of a 2 x 629 numerical matrix.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @seealso \code{\link{values}}
#' @inherit data.BoddyEtAl.2 references
"valuesPPCA"

#' Phylogenetic principal component transformation of the brain and body-mass standard errors
#' found in the SEs object.
#'
#' @format The data is stored in the form of a 2 x 629 numerical matrix.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @seealso \code{\link{SEs}}
#' @inherit data.BoddyEtAl.2 references
"SEsPPCA"

#' Best MGPM A-F model fit to the mammal data without including measurement error.
#'
#' @format This is a MixedGaussian PCM object. See \url{https://venelin.github.io/PCMBase/index.html}
#' for details on the PCMBase R-package.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"bestModelToDataWithoutSEs"

#' Raw PCMFitModelMappings object from the MGPM A-F model fit to the mammal data without including measurement error.
#'
#' @format This is a PCMFitModelMappings object. See \url{https://venelin.github.io/PCMFit/index.html}
#' for further documentation.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"fitMappingsToDataWithoutSEs"

#' Best MGPM A-F fit found to the mammal data without including measurement error.
#'
#' @format This is a PCMFit object. See \url{https://venelin.github.io/PCMFit/index.html}
#' for further documentation.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"bestFitToDataWithSEs"

#' Bootstrap datasets simulated using the MGPM* model, i.e. the model found in bestFitToDataWithSEs
#'
#' @format This is a data.table of 200 rows and 5 columns.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"valuesBootstrapBestFitToDataWithSEs"

#' MGPM fit models to the bootstrap datasets in valuesBootstrapBestFitToDataWithSEs.
#'
#' @format This is data.table object.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"fits_bootstrap_MGPM_A_F_best_clade_RR_HD"

#' Raw PCMFitModelMappings object from the MGPM A-F model fit to the mammal data including measurement error.
#'
#' @note This object was not used for MGPM*, because the ML fit bestFitToDataWithSEs, using the shift-point configuration from fitMappingsToDataWithoutSEs had a better score. However, this object was used to extract the global model fits for the different model types A-F.
#'
#' @format This is a PCMFitModelMappings object. See \url{https://venelin.github.io/PCMFit/index.html}
#' for further documentation.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"fitMappings_MGPM_A_F_best_clade_2_DataWithSEs"

#' Raw PCMFitModelMappings object from the MGPM A-F model fit to the pPCA transformed mammal data including pPCA transformed measurement error.
#'
#' @format This is a PCMFitModelMappings object. See \url{https://venelin.github.io/PCMFit/index.html}
#' for further documentation.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"fitMappings_MGPM_A_F_best_clade_2_pPCADataWithSEs"


#' Raw PCMFitModelMappings object from the MGPM B model fit to the mammal data including measurement error.
#'
#' @format This is a PCMFitModelMappings object. See \url{https://venelin.github.io/PCMFit/index.html}
#' for further documentation.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"fitMappings_MGPM_B_best_clade_2_DataWithSEs"

#' Raw PCMFitModelMappings object from the MGPM B model fit to the pPCA transformed mammal data including pPCA transformed measurement error.
#'
#' @format This is a PCMFitModelMappings object. See \url{https://venelin.github.io/PCMFit/index.html}
#' for further documentation.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"fitMappings_MGPM_B_best_clade_2_pPCADataWithSEs"

#' Raw PCMFitModelMappings object from the SCALAROU model fit to the mammal data including measurement error.
#'
#' @format This is a PCMFitModelMappings object. See \url{https://venelin.github.io/PCMFit/index.html}
#' for further documentation.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"fitMappings_SCALAROU_best_clade_DataWithSEs"

#' Raw PCMFitModelMappings object from the SCALAROU model fit to the pPCA transformed mammal data including pPCA transformed measurement error.
#'
#' @format This is a PCMFitModelMappings object. See \url{https://venelin.github.io/PCMFit/index.html}
#' for further documentation.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"fitMappings_SCALAROU_best_clade_pPCADataWithSEs"

#' Raw PCMFitModelMappings object from the SURFACEOU model fit to the mammal data including measurement error.
#'
#' @format This is a PCMFitModelMappings object. See \url{https://venelin.github.io/PCMFit/index.html}
#' for further documentation.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"fitMappings_SURFACEOU_best_clade_DataWithSEs"

#' Raw PCMFitModelMappings object from the SURFACEOU model fit to the pPCA transformed mammal data including pPCA transformed measurement error.
#'
#' @format This is a PCMFitModelMappings object. See \url{https://venelin.github.io/PCMFit/index.html}
#' for further documentation.
#'
#' @note For additional information, read \href{https://www.pnas.org/lookup/suppl/doi:10.1073/pnas.1813823116/-/DCSupplemental}{SI Appendix, Section H} from Mitov et al. 2019.
#'
#' @inherit data.BoddyEtAl.2 references
"fitMappings_SURFACEOU_best_clade_pPCADataWithSEs"
