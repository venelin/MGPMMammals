library(PCMFit)
library(PCMBase)
library(PCMBaseCpp)
library(MGPMMammals)

GeneratePCMModelTypes()

options(PCMBase.Lmr.mode = 11)

load("Results/Result_FineTuning_BestFit_MammalData_t6.RData")
nodesShiftsFinalModel_t6 <- PCMTreeGetPartition(attr(finalModel, "tree"))
treeMammals <- MGPMMammals::tree
PCMTreeSetPartition(treeMammals, nodesShiftsFinalModel_t6)
attr(finalModel, "tree") <- treeMammals
attr(finalModel, "X") <- MGPMMammals::values
attr(finalModel, "SE") <-  MGPMMammals::SEs
logLik(finalModel)



matParInit1 <- matrix(PCMParamGetShortVector(finalModel, k = 2L, R = PCMNumRegimes(finalModel)), nrow = 1L)
matParInitGuess <- GuessInitVecParams(finalModel, n = 100)
matParInitGuessVaryTheta <- GuessInitVecParams(finalModel, n = 100, varyTheta = TRUE)
matParInitJitter <- jitterModelParams(finalModel, sdJitterAllRegimeFits = 0.05, sdJitterRootRegimeFit = 0.05)


likFun <- PCMCreateLikelihood(
  X = values, tree = treeMammals, model = finalModel,
  SE = SEs,
  SE = matrix(0, 2, PCMTreeNumTips(treeMammals)),
  metaI = PCMInfoCpp, positiveValueGuard = 10000)


valuesParInit1 <- apply(matParInit1, 1, likFun)
valuesParInitGuess <- apply(matParInitGuess, 1, likFun)
valuesParInitGuessVaryTheta <- apply(matParInitGuessVaryTheta, 1, likFun)
valuesParInitJitter <- apply(matParInitJitter, 1, likFun)


fitFinalModel_t6_toDataWithSEs <- PCMFit(
  X = values, tree = treeMammals, model = finalModel, SE = SEs, metaI = PCMInfoCpp,
  positiveValueGuard = 10000,
  matParInit = rbind(matParInitGuess, matParInitJitter),
  matrix(PCMParamGetShortVector(finalModel, k = 2L, R = PCMNumRegimes(finalModel)), nrow = 1L),
  numRunifInitVecParams = 0, numGuessInitVecParams = 0,
  numCallsOptim = 100, control = list(maxit = 1000, factr=1e-8),
  verbose = TRUE)

save(
  fitFinalModel_t6_toDataWithSEs,
  file = "Results/FitFinalModel_t6_toDataWithSEs_t3.RData")

bestFitToDataWithSEs <- fitFinalModel_t6_toDataWithSEs
usethis::use_data(bestFitToDataWithSEs)
