# This script can be run locally or on a cluster using a command like:
#
# bsub -M 100000 -n 100 -W 23:59 -R ib sh R --vanilla --slave -f ../../DetectShifts_SURFACEOUOnPPCAData_best_clade.R
#
library(ape)
library(PCMBase)
library(PCMBaseCpp)
library(PCMFit)
library(data.table)
library(MGPMSimulations)

prefixFiles = "SURFACEOUOnPPCAData_best_clade"

if(!exists("cluster") || is.null(cluster)) {
  if(require(doMPI)) {
    # using MPI cluster as distributed node cluster (possibly running on a cluster)
    # Get the number of cores. Assume this is run in a batch job.
    p = strtoi(Sys.getenv('LSB_DJOB_NUMPROC'))
    cluster <- startMPIcluster(count = p-1, verbose = TRUE)
    doMPI::registerDoMPI(cluster)
  } else {
    cluster <- parallel::makeCluster(parallel::detectCores(logical = TRUE),
                                     outfile = paste0("log_", prefixFiles, ".txt"))
    doParallel::registerDoParallel(cluster)
  }
}

tableFits <- NULL
# try using a previously stored tableFits from a previous run that was interupted
fileCurrentResults <- paste0("CurrentResults_", prefixFiles, ".RData")
if(file.exists(fileCurrentResults)) {
  cat("Loading previously stored tableFits from file", fileCurrentResults, "...\n")

  # this should load a list object named listResults containg a named entry "tableFits":
  load(fileCurrentResults)

  tableFits <- listResults$tableFits

  tempFiles <- list.files(pattern = paste0("^", prefixFiles, ".*.RData"))
  if(length(tempFiles) > 0) {
    cat("Loading previously stored tableFits from temporary files (", toString(tempFiles), ")...\n")
    tableFitsTempFiles <- rbindlist(
      lapply(tempFiles, function(file) {
        load(file)
        fits
      }))
    tableFits <- rbindlist(list(tableFits, tableFitsTempFiles))
  }

  setkey(tableFits, hashCodeTree,hashCodeStartingNodesRegimesLabels,hashCodeMapping)

  tableFits <- unique(tableFits, by = key(tableFits))
  tableFits[, duplicated:=FALSE]

  print(tableFits)
}

options(PCMBase.Value.NA = -1e20)
options(PCMBase.Lmr.mode = 11)
options(PCMBase.Threshold.EV = 1e-7)

print(PCMOptions())


fitMappings <- PCMFitMixed(
  X = MGPMMammals::valuesPPCA, tree = MGPMMammals::tree, SE = MGPMMammals::SEsPPCA,

  modelTypes = MGPMSurfaceOUType(),
  subModels = c(),
  argsMixedGaussian = Args_MixedGaussian_MGPMSurfaceOUType(),

  metaIFun = PCMInfoCpp, positiveValueGuard = 10000,

  tableFits = tableFits,

  listPartitions = NULL,

  minCladeSizes = 20,

  maxCladePartitionLevel = 100L, maxNumNodesPerCladePartition = 1L,

  listAllowedModelTypesIndices = "best-clade",

  argsConfigOptim1 = DefaultArgsConfigOptim(
    numCallsOptim = 400,
    numRunifInitVecParams = 100000,
    numGuessInitVecParams = 50000),
  argsConfigOptim2 = DefaultArgsConfigOptim(
    numCallsOptim = 4,
    numRunifInitVecParams = 1000,
    numGuessInitVecParams = 10000,
    numJitterRootRegimeFit = 1000,
    sdJitterRootRegimeFit = 0.05,
    numJitterAllRegimeFits = 1000,
    sdJitterAllRegimeFits = 0.05),

  doParallel = TRUE,

  prefixFiles = prefixFiles,
  saveTempWorkerResults = TRUE,
  printFitVectorsToConsole = FALSE,
  verbose = TRUE,
  debug = FALSE)

save(fitMappings, file = paste0("FinalResult_", prefixFiles, ".RData"))

if(exists("cluster") && !is.null(cluster)) {
  parallel::stopCluster(cluster)
  # Don't forget to destroy the parallel cluster to avoid leaving zombie worker-processes.

  cluster <- NULL
}

