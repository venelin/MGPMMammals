library(PCMBase)
library(PCMBaseCpp)
library(PCMFit)
library(MGPMMammals)

modelB <- MixedGaussian(
  k = 2,
  modelTypes = MGPMDefaultModelTypes(),
  mapping = c(`1`=2),
  Sigmae_x = structure(
      0, class = c("MatrixParameter", "_Omitted"),
      description =
         "Zero upper triangular Choleski factor of the error term"))

PCMFitModelB <- PCMFit(
  X = MGPMMammals::values,
  tree = MGPMMammals::tree,
  model = modelB,
  SE = MGPMMammals::SEs,
  metaI = PCMInfoCpp,
  numCallsOptim = 20,
  numGuessInitVecParams = 50000)

fitBMB <- PCMFitModelB$modelOptim
PCMLik(X = MGPMMammals::values,
       tree = MGPMMammals::tree,
       model = fitBMB,
       SE = MGPMMammals::SEs)

# Perform a phylogenetic PCA transformation of the data (excluding SEs),
# using the parameter Sigma of the best BM_B model as a matrix R, i.e.
# the rotation matrix V is built using the eigenvectors of R.
a <- fitBMB$X0
V <- eigen(fitBMB$`1`$Sigma_x[,,1] %*%t
           (fitBMB$`1`$Sigma_x[,,1]))$vectors
one <- rep(1, PCMTreeNumTips(MGPMMammals::tree))
valuesPPCA <- t((t(MGPMMammals::values) - one %*% t(a) ) %*% V)

#usethis::use_data(valuesPPCA)

SEsPPCA <- do.call(
  abind::abind,
  c(lapply(seq_len(PCMTreeNumTips(MGPMMammals::tree)), function(i) {
    VE <- diag(MGPMMammals::SEs[,i]^2)
    if(VE[1,1] == 0) {
      VE[1,1] <- 0.001
    }
    if(VE[2,2] == 0) {
      VE[2,2] <- 0.0001
    }
    if(packageVersion("PCMBase") >= "1.2.10") {
      unname(UpperChol(t(V) %*% VE %*% V))
    } else {
      unname(chol(t(V) %*% VE %*% V))
    }

  }), list(along = 3)))


fitBMB_rotated <- fitBMB

fitBMB_rotated$X0[] <- 0

# Note that, here the call to chol works because it is equivalent to calling
# sqrt because the rotated matrix is diagonal. If the rotated matrix was not
# diagonal, one should have called the function PCMBase::UpperChol. This
# function, however was implemented in PCMBase v1.2.10 and was not available at
# the time of writing this script.
fitBMB_rotated$`1`$Sigma_x[,,1] <- chol(
  t(V) %*% fitBMB$`1`$Sigma_x[,,1] %*% t(fitBMB$`1`$Sigma_x[,,1]) %*% V)

PCMLik(X = MGPMMammals::valuesPPCA,
       tree = MGPMMammals::tree,
       model = fitBMB_rotated,
       SE = MGPMMammals::SEsPPCA)
#usethis::use_data(SEsPPCA)
