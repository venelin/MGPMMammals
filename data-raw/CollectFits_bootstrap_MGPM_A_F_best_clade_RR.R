# Run this script from the data-raw directory using this command:
# R --vanilla -f CollectFits_bootstrap_MGPM_A_F_best_clade_RR.R

library(PCMFit)
library(PCMBase)
library(PCMBaseCpp)
library(MGPMMammals)
library(data.table)

options(PCMBase.Value.NA = -1e20)
options(PCMBase.Lmr.mode = 11)
options(PCMBase.Threshold.EV = 1e-9)

args <- commandArgs(trailingOnly = TRUE)
print(args)

inferredModel <- bestFitToDataWithSEs$modelOptim

# Set internal node.label containing family and order names at the internal
# nodes
tree$node.label <- bestFitMappingsToDataWithoutSEs$treeOriginal$node.label

fits_bootstrap_MGPM_A_F_best_clade_RR_HD <- CollectBootstrapResults(
  resultDir = "Results_bootstrap",
  prefixFiles = "bootstrap_MGPM_A_F_best_clade_RR_id_",
  ids = seq_len(200),
  inferredTree =
    bestFitToDataWithSEs$inferredTreeWithRealLabelsRegimesAndEpochsHD,
  inferredBackboneTree =
    bestFitToDataWithSEs$inferredBackboneWithRealLabelsRegimesAndEpochsHD,
  epochs = bestFitToDataWithSEs$epochsHD,
  naturalNodeLabelsInOriginalTree = PCMTreeGetLabels(tree),
  minLength = 0.2,
  verbose = TRUE)

inferredTree <- bestFitToDataWithSEs$inferredTreeWithRealLabelsRegimesAndEpochs
fits_bootstrap_MGPM_A_F_best_clade_RR_HD <- copy(fits_bootstrap_MGPM_A_F_best_clade_RR_HD)
fits_bootstrap_MGPM_A_F_best_clade_RR_HD[
  , logLikSimulatedModel := sapply(seq_len(.N), function(i) {

    PCMLik(
      X = valuesBootstrapBestFitToDataWithSEs$X[[i]][
        , seq_len(PCMTreeNumTips(inferredTree))],
      tree = inferredTree,
      model = inferredModel,
      metaI = PCMInfoCpp)
  })]


usethis::use_data(fits_bootstrap_MGPM_A_F_best_clade_RR_HD, overwrite = TRUE)
