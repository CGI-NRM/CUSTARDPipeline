printprint <- function(i = '') { print(paste0("print('", i, "')"))}

GenotypeFiltering <- function(inGenotypes, minPresent = 75, maxPresent = 10000, createRDS = FALSE, rdsName = "filteredGenotypes.rds") {
  nLoci <- ncol(inGenotypes) - 1
  sumEmpties <- function(x) {return(sum(grepl("^$", x)))}
  
  filteredGenotypes <- inGenotypes[apply(inGenotypes, 1, sumEmpties) <= (nLoci - minPresent), ]
  filteredGenotypes <- filteredGenotypes[apply(filteredGenotypes, 1, sumEmpties) >= (nLoci - maxPresent), ]
  
  if(createRDS == TRUE) {
    saveRDS(filteredGenotypes, file = rdsName)
  }
  return(filteredGenotypes)
}

ParseGenotypes <- function(genotypePath = "Genotyped_SNPs/") {
  snpCsvFiles <- list.files(genotypePath, pattern = ".csv", full.names = TRUE)
  loadedFiles <- lapply(snpCsvFiles, read.table, sep = ',', header = TRUE, check.names = FALSE)
  loadedGenotypes <- cbind(Status = 'Loaded', do.call(rbind, loadedFiles))
  loadedGenotypes[is.na(loadedGenotypes)] <- ''
  loadedGenotypes$Sample <- toupper(loadedGenotypes$Sample)
  loadedGenotypes$Status[duplicated(loadedGenotypes$Sample)] <- "Duplicated" # mark duplications of names # moved up
  loadedGenotypes$Status[grepl("NEGATIVE|POSITIVE", loadedGenotypes$Sample)] <- "Control" # mark controls # moved down
  return(loadedGenotypes)
}

QCMarking <- function(inGenotypes, minPresent = 75, maxPresent = 10000, targetStatus = c(""), newStatus = "Pass") {
  nLoci <- ncol(inGenotypes) - 2
  sumEmpties <- function(x) {return(sum(grepl("^$", x)))}
  inGenotypes$Status[apply(inGenotypes, 1, sumEmpties) <= (nLoci - minPresent) & apply(inGenotypes, 1, sumEmpties) >= (nLoci - maxPresent) & grepl(paste(targetStatus, sep = "|"), inGenotypes$Status)] <- newStatus
  return(inGenotypes)
}

SplitLocus <- function(x, dataSet) {
  columnName <- colnames(dataSet)[x]
  # print(columnName)
  twoCols <- do.call(rbind, strsplit(dataSet[, x], ""))
  colnames(twoCols) <- c(paste0(columnName, "1"), paste0(columnName, "2"))
  return(twoCols)
}

LoadAMData <- function(inData, targetStatus = c("")) {
  # Prepare data (filter by targeted sample status and remove status column):
  inData <- inData[, !lapply(inData, unique) == ''] # does this matter with allelematch?
  inData <- inData[grepl(do.call(paste, c(as.list(targetStatus), sep = "|")), inData$Status), -c(1)]
  
  # Split loci into two columns:
  inData[inData == ''] <- "NN" # change missing data to NN
  splitDataset <- as.data.frame(cbind(Sample = inData$Sample, do.call(cbind, lapply(1:ncol(inData[, -c(1)]), SplitLocus, inData[, -c(1)]))))
  
  # Load data:
  snpLoadedSplit <- allelematch::amDataset(multilocusDataset = splitDataset, missingCode = "N", indexColumn = "Sample")
  bearAlleleKey <- rep(1:(ncol(splitDataset[, -c(1)]) / 2), each = 2)
  return(list(Data = snpLoadedSplit, AlleleKey = bearAlleleKey))
}