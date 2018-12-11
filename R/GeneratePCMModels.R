#' List of possible BM parameterizations
ListParameterizationsBM <- function() {
  list(
    X0 = list(
      c("VectorParameter", "_Omitted")
    ),
    Sigma_x =
      list(
        c("MatrixParameter", "_UpperTriangularWithDiagonal", "_WithNonNegativeDiagonal"),
        c("MatrixParameter", "_Diagonal", "_WithNonNegativeDiagonal"),
        c("MatrixParameter", "_ScalarDiagonal", "_WithNonNegativeDiagonal")
      ),

    Sigmae_x = list(
      c("MatrixParameter", "_UpperTriangularWithDiagonal", "_WithNonNegativeDiagonal"),
      c("MatrixParameter", "_Diagonal", "_WithNonNegativeDiagonal"),
      c("MatrixParameter", "_ScalarDiagonal", "_WithNonNegativeDiagonal"),
      c("MatrixParameter", "_Omitted"))
  )
}

#' List of possible OU parameterizations
ListParameterizationsOU <- function() {
  list(
    X0 = list(
      c("VectorParameter", "_Omitted")),

    H = list(
      c("MatrixParameter", "_Schur", "_WithNonNegativeDiagonal", "_Transformable"),
      c("MatrixParameter", "_Schur", "_UpperTriangularWithDiagonal", "_WithNonNegativeDiagonal", "_Transformable"),
      c("MatrixParameter", "_Schur", "_Diagonal", "_WithNonNegativeDiagonal", "_Transformable"),
      c("MatrixParameter", "_Schur", "_ScalarDiagonal", "_WithNonNegativeDiagonal", "_Transformable"),

      c("MatrixParameter", "_Schur", "_WithNonNegativeDiagonal", "_Transformable", "_Global"),
      c("MatrixParameter", "_Schur", "_UpperTriangularWithDiagonal", "_WithNonNegativeDiagonal", "_Transformable", "_Global"),
      c("MatrixParameter", "_Schur", "_Diagonal", "_WithNonNegativeDiagonal", "_Transformable", "_Global"),
      c("MatrixParameter", "_Schur", "_ScalarDiagonal", "_WithNonNegativeDiagonal", "_Transformable", "_Global")),

    Theta = list(
      c("VectorParameter")),

    Sigma_x = list(
      c("MatrixParameter", "_UpperTriangularWithDiagonal", "_WithNonNegativeDiagonal"),
      c("MatrixParameter", "_Diagonal", "_WithNonNegativeDiagonal"),
      c("MatrixParameter", "_ScalarDiagonal", "_WithNonNegativeDiagonal"),

      c("MatrixParameter", "_UpperTriangularWithDiagonal", "_WithNonNegativeDiagonal", "_Global"),
      c("MatrixParameter", "_Diagonal", "_WithNonNegativeDiagonal", "_Global"),
      c("MatrixParameter", "_ScalarDiagonal", "_WithNonNegativeDiagonal", "_Global")),

    Sigmae_x = list(
      c("MatrixParameter", "_UpperTriangularWithDiagonal", "_WithNonNegativeDiagonal"),
      c("MatrixParameter", "_Diagonal", "_WithNonNegativeDiagonal"),
      c("MatrixParameter", "_ScalarDiagonal", "_WithNonNegativeDiagonal"),
      c("MatrixParameter", "_Omitted"))
  )
}

GeneratePCMModels <- function() {
  PCMGenerateParameterizations(structure(0.0, class="BM"), listParameterizations = ListParameterizationsBM())
  PCMGenerateParameterizations(structure(0.0, class="OU"), listParameterizations = ListParameterizationsOU())
}


PCMParamLowerLimit.BM <- function(o, k, R, ...) {
  o <- NextMethod()
  k <- attr(o, "k", exact = TRUE)
  R <- length(attr(o, "regimes", exact = TRUE))

  if(is.Global(o$Sigma_x)) {
    if(!is.Diagonal(o$Sigma_x)) {
      o$Sigma_x[1, 2] <- -.0
    }
  } else {
    if(!is.Diagonal(o$Sigma_x)) {
      for(r in seq_len(R)) {
        o$Sigma_x[1, 2, r] <- -.0
      }
    }
  }
  o
}

PCMParamUpperLimit.BM <- function(o, k, R, ...) {
  o <- NextMethod()
  k <- attr(o, "k", exact = TRUE)
  R <- length(attr(o, "regimes", exact = TRUE))

  if(is.Global(o$Sigma_x)) {
    o$Sigma_x[1, 1] <- o$Sigma_x[2, 2] <- 1.0
    if(!is.Diagonal(o$Sigma_x)) {
      o$Sigma_x[1, 2] <- 1.0
    }
  } else {
    for(r in seq_len(R)) {
      o$Sigma_x[1, 1, r] <- o$Sigma_x[2, 2, r] <- 1.0
      if(!is.Diagonal(o$Sigma_x)) {
        o$Sigma_x[1, 2, r] <- 1.0
      }
    }
  }
  o
}

PCMParamLowerLimit.OU <- function(o, k, R, ...) {
  o <- NextMethod()
  k <- attr(o, "k", exact = TRUE)
  R <- length(attr(o, "regimes", exact = TRUE))

  if(is.Global(o$Theta)) {
    o$Theta[1] <- 0.0
    o$Theta[2] <- -1.2
  } else {
    for(r in seq_len(R)) {
      o$Theta[1, r] <- 0.0
      o$Theta[2, r] <- -1.2
    }
  }
  if(is.Global(o$Sigma_x)) {
    if(!is.Diagonal(o$Sigma_x)) {
      o$Sigma_x[1, 2] <- -.0
    }
  } else {
    if(!is.Diagonal(o$Sigma_x)) {
      for(r in seq_len(R)) {
        o$Sigma_x[1, 2, r] <- -.0
      }
    }
  }
  o
}

PCMParamUpperLimit.OU <- function(o, k, R, ...) {
  o <- NextMethod()
  k <- attr(o, "k", exact = TRUE)
  R <- length(attr(o, "regimes", exact = TRUE))

  if(is.Global(o$Theta)) {
    o$Theta[1] <- 7.8
    o$Theta[2] <- 3.8
  } else {
    for(r in seq_len(R)) {
      o$Theta[1, r] <- 7.8
      o$Theta[2, r] <- 3.8
    }
  }
  if(is.Global(o$Sigma_x)) {
    o$Sigma_x[1, 1] <- o$Sigma_x[2, 2] <- 1.0
    if(!is.Diagonal(o$Sigma_x)) {
      o$Sigma_x[1, 2] <- 1.0
    }
  } else {
    for(r in seq_len(R)) {
      o$Sigma_x[1, 1, r] <- o$Sigma_x[2, 2, r] <- 1.0
      if(!is.Diagonal(o$Sigma_x)) {
        o$Sigma_x[1, 2, r] <- 1.0
      }
    }
  }
  o
}

SimulatedModels <- function() {
  c(
    # BM; independent traits
    "BM__Omitted_X0__Diagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x",
    # BM; dependent traits
    "BM__Omitted_X0__UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x",
    # OU; independent traits (diagonal H and diagonal Sigma)
    "OU__Omitted_X0__Schur_Diagonal_WithNonNegativeDiagonal_Transformable_H__Theta__Diagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x",
    # OU; dependtent traits (diagonal H and non-diagonal Sigma)
    "OU__Omitted_X0__Schur_Diagonal_WithNonNegativeDiagonal_Transformable_H__Theta__UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x",
    # OU; dependent traits (Symmetric H and non-diagonal Sigma)
    "OU__Omitted_X0__Schur_UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Transformable_H__Theta__UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x",
    # OU; dependent traits with causality (non-symmetric H and non-diagonal Sigma)
    "OU__Omitted_X0__Schur_WithNonNegativeDiagonal_Transformable_H__Theta__UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x"
  )
}

ArgsMixedGaussian_SimulatedModels <- function() {
  list(
    Sigmae_x = structure(0.0, class = c("MatrixParameter", "_Omitted"),
                         description = "upper triangular Choleski factor of the non-phylogenetic variance-covariance"))
  }



InferredModel_BM <- function() {
  c(
    "BM__Omitted_X0__UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x"
  )
}

ArgsMixedGaussian_BM <- function() {
  list(
    Sigmae_x = structure(0.0, class = c("MatrixParameter", "_Omitted"),
                         description = "upper triangular Choleski factor of the non-phylogenetic variance-covariance")
  )
}



InferredModel_OU <- function() {
  c(
    "OU__Omitted_X0__Schur_WithNonNegativeDiagonal_Transformable_H__Theta__UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x"
  )
}
ArgsMixedGaussian_OU <- function() {
  list(
    Sigmae_x = structure(0.0, class = c("MatrixParameter", "_Omitted"),
                         description = "upper triangular Choleski factor of the non-phylogenetic variance-covariance")
  )
}


InferredModel_SurfaceOU <- function() {
  c(
    "OU__Omitted_X0__Schur_ScalarDiagonal_WithNonNegativeDiagonal_Transformable_Global_H__Theta__Diagonal_WithNonNegativeDiagonal_Global_Sigma_x__Omitted_Sigmae_x"
  )
}

ArgsMixedGaussian_SurfaceOU <- function() {
  list(
    H = structure(0.0,
                  class = c("MatrixParameter", "_Schur", "_ScalarDiagonal", "_WithNonNegativeDiagonal", "_Transformable", "_Global"),
                  description = "adaptation rate matrix"),
    Sigma_x = structure(0.0,
                        class = c("MatrixParameter", "_Diagonal", "_WithNonNegativeDiagonal", "_Global"),
                        description = "unit-time variance parameter of the OU-process"),
    Sigmae_x = structure(0.0, class = c("MatrixParameter", "_Omitted"),
                         description = "upper triangular Choleski factor of the non-phylogenetic variance-covariance")
  )
}

InferredModel_ScalarOU <- function() {
  c(
    "OU__Omitted_X0__Schur_ScalarDiagonal_WithNonNegativeDiagonal_Transformable_Global_H__Theta__UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Global_Sigma_x__Omitted_Sigmae_x"
  )
}
ArgsMixedGaussian_ScalarOU <- function() {
  list(
    H = structure(0.0,
                  class = c("MatrixParameter", "_Schur", "_ScalarDiagonal", "_WithNonNegativeDiagonal", "_Transformable", "_Global"),

                  description = "adaptation rate matrix"),
    Sigma_x = structure(0.0,
                        class = c("MatrixParameter", "_UpperTriangularWithDiagonal", "_WithNonNegativeDiagonal", "_Global"),
                        description = "upper triangular Choleski factor for unit time variance of the OU-process"),
    Sigmae_x = structure(0.0, class = c("MatrixParameter", "_Omitted"),
                         description = "upper triangular Choleski factor of the non-phylogenetic variance-covariance")
  )
}

InferredModel_MixedGaussian <- function() {
  c(
    # BM; independent traits
    "BM__Omitted_X0__Diagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x",
    # BM; dependent traits
    "BM__Omitted_X0__UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x",
    # OU; independent traits (diagonal H and diagonal Sigma)
    "OU__Omitted_X0__Schur_Diagonal_WithNonNegativeDiagonal_Transformable_H__Theta__Diagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x",
    # OU; dependtent traits (diagonal H and non-diagonal Sigma)
    "OU__Omitted_X0__Schur_Diagonal_WithNonNegativeDiagonal_Transformable_H__Theta__UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x",
    # OU; dependent traits (Symmetric H and non-diagonal Sigma)
    "OU__Omitted_X0__Schur_UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Transformable_H__Theta__UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x",
    # OU; dependent traits with causality (non-symmetric H and non-diagonal Sigma)
    "OU__Omitted_X0__Schur_WithNonNegativeDiagonal_Transformable_H__Theta__UpperTriangularWithDiagonal_WithNonNegativeDiagonal_Sigma_x__Omitted_Sigmae_x"
  )
}

ArgsMixedGaussian_MixedGaussian <- function() {
  ArgsMixedGaussian_SimulatedModels()
}

