# This script can be run locally or on a cluster using a command like:
#
# bsub -M 100000 -n 50 -W 23:59 -R ib sh R --vanilla --slave -f ../../DetectShifts_MGPM_B_best_clade_2.R
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

prefixFiles = paste0("MGPM_B_best_clade_2")

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

listPCMOptions <- c(
  PCMOptions(),
  list(
    MGPMMammals.LowerLimit.Theta1 = min(values[1,]),
    MGPMMammals.LowerLimit.Theta2 = min(values[2,]),
    MGPMMammals.UpperLimit.Theta1 = max(values[1,]),
    MGPMMammals.UpperLimit.Theta2 = max(values[2,]),
    MGPMMammals.LowerLimit.Sigma_x12 = -1.0)
)

print(PCMOptions())

fitMappings <- PCMFitMixed(

  X = values, tree = MGPMMammals::tree, SE = SEs,

  modelTypes = MGPMDefaultModelTypes()[2],
  subModels = c(),

  metaIFun = PCMInfoCpp, positiveValueGuard = 5000,

  tableFits = tableFits,

  listPartitions = NULL,

  minCladeSizes = 20L,

  maxCladePartitionLevel = 100L, maxNumNodesPerCladePartition = 1L,

  listAllowedModelTypesIndices = "best-clade-2",

  argsConfigOptim1 = DefaultArgsConfigOptim(
    numCallsOptim = 100L,
    numRunifInitVecParams = 100000L,
    numGuessInitVecParams = 100000L),
  argsConfigOptim2 = DefaultArgsConfigOptim(
    numCallsOptim = 25L,
    numRunifInitVecParams = 2000L,
    numGuessInitVecParams = 25000L,
    numJitterRootRegimeFit = 2500L,
    sdJitterRootRegimeFit = 0.05,
    numJitterAllRegimeFits = 2500L,
    sdJitterAllRegimeFits = 0.05),
  argsConfigOptim3 = DefaultArgsConfigOptim(
    numCallsOptim = 4L,
    numRunifInitVecParams = 1000L,
    numGuessInitVecParams = 10000L,
    numJitterRootRegimeFit = 1000L,
    sdJitterRootRegimeFit = 0.05,
    numJitterAllRegimeFits = 1000L,
    sdJitterAllRegimeFits = 0.05),

  maxNumRoundRobins = 5,
  maxNumPartitionsInRoundRobins = 45,

  listPCMOptions = listPCMOptions,

  doParallel = TRUE,

  prefixFiles = prefixFiles,
  saveTempWorkerResults = TRUE,
  printFitVectorsToConsole = TRUE,
  verbose = TRUE,
  debug = FALSE)

save(fitMappings, file = paste0("FinalResult_", prefixFiles, ".RData"))

if(exists("cluster") && !is.null(cluster)) {
  parallel::stopCluster(cluster)
  # Don't forget to destroy the parallel cluster to avoid leaving zombie worker-processes.

  cluster <- NULL
}

