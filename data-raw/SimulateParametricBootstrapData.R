library(data.table)
library(PCMBase)
library(MGPMMammals)

set.seed(12)

numBootstraps <- 200

bestModel <- MGPMMammals::bestFitToDataWithSEs$modelOptim
treeWithRegimes <- attr(bestModel, "tree")

metaI <- PCMInfo(X = NULL, tree = treeWithRegimes, model = bestModel, SE = SEs)

# Simulate data with the best fit model from the mammal data with SEs
valuesBootstrapBestFitToDataWithSEs <- data.table(
  IdGlob = seq_len(numBootstraps),
  X = lapply(seq_len(numBootstraps), function(id) {
    PCMSim(
      tree = treeWithRegimes, model = bestModel, X0 = bestModel$X0,
      SE = MGPMMammals::SEs, metaI = metaI)
  })
)

options(PCMBase.Value.NA = -1e20)
options(PCMBase.Lmr.mode = 11)
options(PCMBase.Threshold.EV = 1e-7)

valuesBootstrapBestFitToDataWithSEs <- copy(valuesBootstrapBestFitToDataWithSEs)
valuesBootstrapBestFitToDataWithSEs[
  , c("df", "logLik", "score") := {
    resLists <- lapply(.I, function(i) {
      attr(bestModel, "X") <- X[[i]]
      ll <- logLik(bestModel)
      aic <- AIC(bestModel)
      df <- attr(ll, "df")
      c(df, ll, aic)
    })
    list(df = sapply(resLists, function(.) .[1]),
         logLik = sapply(resLists, function(.) .[2]),
         score = sapply(resLists, function(.) .[3]))
  }]

usethis::use_data(valuesBootstrapBestFitToDataWithSEs, overwrite = TRUE)

