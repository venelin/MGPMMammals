# This script can be run locally or on a cluster using a command like:
#
# bsub -M 50000 -n 50 -W 23:59 -R ib sh R --vanilla --slave -f ../../DetectShifts_bootstrap_MGPM_A_F_best_clade_RR.R
#
library(ape)
library(PCMBase)
library(PCMBaseCpp)
library(PCMFit)
library(data.table)
library(MGPMMammals)


args <- commandArgs(trailingOnly = TRUE)
if(length(args) > 0) {
  id <- as.integer(args[1])
} else {
  id <- 1
}

prefixFiles = paste0("bootstrap_MGPM_A_F_best_clade_RR_id_", id)

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

  print(tableFits)
  print(dim(tableFits))

  tempFiles <- list.files(pattern = paste0("^", prefixFiles, ".*.RData"))
  if(length(tempFiles) > 0) {
    cat("Loading previously stored tableFits from temporary files (", toString(tempFiles), ")...\n")
    tableFitsTempFiles <- rbindlist(
      lapply(tempFiles, function(file) {
        load(file)
        fits
      }))

    print(tableFitsTempFiles)
    print(dim(tableFitsTempFiles))

    tableFits <- rbindlist(list(tableFits, tableFitsTempFiles))
  }

  setkey(tableFits, hashCodeTree,hashCodeStartingNodesRegimesLabels,hashCodeMapping)

  tableFits <- unique(tableFits, by = key(tableFits))
  tableFits[, duplicated:=FALSE]

  print(tableFits)
}

options(PCMBase.Value.NA = -1e20)
options(PCMBase.Lmr.mode = 11)

print(PCMOptions())


fitMappings <- PCMFitMixed(
  X = MGPMMammals::valuesBootstrapBestFitToDataWithSEs$X[[id]][
    , seq_len(PCMTreeNumTips(MGPMMammals::tree))],

  tree = MGPMMammals::tree,
  SE = MGPMMammals::SEs,

  metaIFun = PCMInfoCpp, positiveValueGuard = 10000,

  tableFits = tableFits,

  listPartitions = NULL,

  minCladeSizes = 20,

  maxCladePartitionLevel = 100L, maxNumNodesPerCladePartition = 1L,

  listAllowedModelTypesIndices = "best-clade",

  argsConfigOptim1 = DefaultArgsConfigOptim(
    numCallsOptim = 200,
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
  argsConfigOptim3 = DefaultArgsConfigOptim(
    numCallsOptim = 4,
    numRunifInitVecParams = 1000,
    numGuessInitVecParams = 10000,
    numJitterRootRegimeFit = 1000,
    sdJitterRootRegimeFit = 0.05,
    numJitterAllRegimeFits = 1000,
    sdJitterAllRegimeFits = 0.05),

  maxNumRoundRobins = 5,
  maxNumPartitionsInRoundRobins = 8,

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

