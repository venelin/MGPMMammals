library(PCMBase)
library(PCMBaseCpp)
library(PCMFit)
library(TestPCMFit)
library(data.table)

GeneratePCMModels()

options(PCMBase.Value.NA = -1e20)
options(PCMBase.Lmr.mode = 11)

options(PCMBase.Threshold.SV = 1e-6)
options(PCMBase.Threshold.EV = 1e-5)
options(PCMBase.Skip.Singular = FALSE)
options(PCMBase.Threshold.Skip.Singular = 1e-4)

load("FinalResult_MixedGaussian_MammalData_id_1_t6_.RData")

tree <- fitMappings$treeOriginal

inferred <- RetrieveBestFitAIC(fitMappings, rank = 1)
inferredModel <- inferred$inferredModel

inferredTree <- attr(inferredModel, "tree")

PCMTreeSetLabels(inferredTree, PCMTreeGetLabels(tree))

colnames(valuesMammals) <- inferredTree$tip.label

print(AIC(inferredModel))
print(logLik(inferredModel))

# Try to improve the inferredFit by manually setting the model-types of the regimes that are
# apparently a bad fit to the data (backbone figure).
# These are the following regimes: 5, 7, 9, 10, 11
# For each of the above 5 regimes, we set the model to F (OU with asymetric H); also, we set the
# long-term vector to the current mean of the tips under this regime

tunedRegimeModels <- list(
  "5" = 5:6,
  "7" = 5:6,
  "9" = 5:6,
  "10" = 5:6,
  "11" = 5:6,
  "12" = 5:6)

currentModel <- inferredModel
currentMapping <- attr(inferredModel, "mapping")

for(i in seq_along(tunedRegimeModels)) {
  regimeChar <- names(tunedRegimeModels)[i]
  regimeInt <- as.integer(regimeChar)



  for(m in tunedRegimeModels[[i]]) {
    newMapping <- currentMapping
    newMapping[as.integer(names(tunedRegimeModels)[i])] <- m

    newModel <- do.call(
      MixedGaussian,
      c(list(k = 2L, modelTypes = fitMappings$arguments$modelTypes,
             mapping = newMapping),
        fitMappings$arguments$argsMixedGaussian))

    fixedNames <- c("X0", as.character(seq_along(currentMapping)[-regimeInt]))

    PCMParamSetByName(newModel, currentModel[fixedNames])

    for(name in fixedNames) {
      newModel <- PCMFixParameter(newModel, name)
    }

    X <- attr(currentModel, "X")
    tree <- attr(currentModel, "tree")

    attr(newModel, "X") <- X
    attr(newModel, "tree") <- tree

    if(!is.null(currentModel[[regimeChar]]$H) && currentMapping[regimeInt] <= newMapping[regimeInt]) {
      newModel[[regimeChar]]$H[] <- currentModel[[regimeChar]]$H[]
    }
    if(!is.null(currentModel[[regimeChar]]$H) && currentMapping[regimeInt] <= newMapping[regimeInt]) {
      newModel[[regimeChar]]$Theta[] <- currentModel[[regimeChar]]$Theta[]
    } else {
      newModel[[regimeChar]]$Theta[] <- rowMeans(X[,PCMTreeGetTipsInRegime(tree, regimeChar)])
    }
    newModel[[regimeChar]]$Sigma_x[] <- currentModel[[regimeChar]]$Sigma_x[]

    argsConfigOptimAndMCMC <- fitMappings$arguments$argsConfigOptimAndMCMC2
    argsConfigOptimAndMCMC$genInitNumEvals <- 2
    argsConfigOptimAndMCMC$nCallsOptim <- 1

    metaINewModel <- PCMInfoCpp(X, tree, newModel)

    cat("Fitting new model with all regimes except ", regimeChar, " being fixed; currentMapping=", currentMapping[regimeInt], "; newMapping=", newMapping[regimeInt], "...\n")
    fit <- do.call(
      PCMFit,
      c(list(X = X, tree = tree, model = copy(newModel), metaI = metaINewModel, verbose = TRUE),
        list(positiveValueGuard = fitMappings$arguments$positiveValueGuard,
             argsPCMParamLowerLimit = fitMappings$arguments$argsPCMParamLowerLimit,
             argsPCMParamUpperLimit = fitMappings$arguments$argsPCMParamUpperLimit,
             argsPCMParamLoadOrStore = fitMappings$arguments$argsPCMParamLoadOrStore,
             argsConfigOptimAndMCMC = c(
               list(listParInitOptim = list(PCMParamGetShortVector(newModel))),
               argsConfigOptimAndMCMC)))
    )

    newModelFitted1 <- fit$modelOptim
    for(name in fixedNames) {
      newModelFitted1 <- PCMUnfixParameter(newModelFitted1, name)
    }
    attr(newModelFitted1, "X") <- X
    attr(newModelFitted1, "tree") <- tree

    metaINewModelFitted1 <- PCMInfoCpp(X, tree, newModelFitted1)

    cat("Fitting new model with all regimes free currentMapping=", currentMapping[regimeInt], "; newMapping=", newMapping[regimeInt], "...\n")
    fit <- do.call(
      PCMFit,
      c(list(X = X, tree = tree, model = copy(newModelFitted1), metaI = metaINewModelFitted1, verbose = TRUE),
        list(positiveValueGuard = fitMappings$arguments$positiveValueGuard,
             argsPCMParamLowerLimit = fitMappings$arguments$argsPCMParamLowerLimit,
             argsPCMParamUpperLimit = fitMappings$arguments$argsPCMParamUpperLimit,
             argsPCMParamLoadOrStore = fitMappings$arguments$argsPCMParamLoadOrStore,
             argsConfigOptimAndMCMC = c(list(listParInitOptim = list(PCMParamGetShortVector(newModelFitted1))),
                                        argsConfigOptimAndMCMC)))
    )

    newModelFitted2 <- fit$modelOptim

    attr(newModelFitted2, "X") <- X
    attr(newModelFitted2, "tree") <- tree

    cat("-----------------------------------------\n")
    cat("Fine tuning regime ", regimeChar, "...\n")
    cat("Initial model mapping ", currentMapping[regimeInt], "\n")
    cat("Initial AIC=", AIC(currentModel), "\n")
    cat("Initial logLik=", logLik(currentModel), "\n")
    cat("Initial p=", PCMParamCount(currentModel, TRUE, TRUE), "\n")
    cat("\n")
    cat("New model mapping ", newMapping[regimeInt], "\n")
    cat("New AIC(all but 1 fixed)=", AIC(newModelFitted1), "\n")
    cat("New logLik(all but 1 fixed)=", logLik(newModelFitted1), "\n")
    cat("New p=", PCMParamCount(newModelFitted1, TRUE, TRUE), "\n")
    cat("\n")
    cat("New model mapping ", newMapping[regimeInt], "\n")
    cat("New AIC(all free)=", AIC(newModelFitted2), "\n")
    cat("New logLik(all free)=", logLik(newModelFitted2), "\n")
    cat("New p=", PCMParamCount(newModelFitted2, TRUE, TRUE), "\n")
    cat("\n")
    if(AIC(newModelFitted2) < AIC(currentModel)) {
      cat("AIC improved => setting current model to newModelFitted2\n")
      currentModel <- newModelFitted2
      currentMapping <- newMapping
    }
    cat("-----------------------------------------\n")
  }
}

cat("=============================================\n")

cat("Initial mapping in inferredModel ", attr(inferredModel, "mapping"), "\n")
cat("Initial AIC in inferredModel=", AIC(inferredModel), "\n")
cat("Final mapping after fine tuning=", attr(currentModel, "mapping"), "\n")
cat("Final AIC after fine tuning=", AIC(currentModel), "\n")

finalModel <- currentModel
save(finalModel, file = "Result_FineTuning_BestFit_MammalData_t6.RData")

# the finaModel object was saved under the following name as a data-object using
# the following code:
#
# bestModelToDataWithoutSEs <- finalModel
# usethis::use_data(bestModelToDataWithoutSEs)
