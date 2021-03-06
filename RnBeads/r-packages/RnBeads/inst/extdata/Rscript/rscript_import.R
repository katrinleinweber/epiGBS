library(argparse)
suppressPackageStartupMessages(library(RnBeads))

ap <- ArgumentParser()
ap$add_argument("-x", "--xml", action="store", help="Configuration xml file")
ap$add_argument("-o", "--output", action="store", help="Output directory")
ap$add_argument("-c", "--cores", action="store", type="integer", default=1, help="Number of cores used for the analysis")
cmdArgs <- ap$parse_args()
module.name <- "import"

logger.start(fname=NA)
logger.status(c("...Started module:",module.name))

logger.start("Configuring Analysis")
	rnb.settings <- rnb.xml2options(cmdArgs$xml,return.full.structure=TRUE)

	data.source <- rnb.settings$analysis.params[["data.source"]]
	data.type <- rnb.settings$analysis.params[["data.type"]]
	report.dir <- rnb.settings$analysis.params[["dir.reports"]]
	analysis.options <- rnb.settings$options

	if ("preanalysis.script" %in% names(rnb.settings)){
		source(rnb.settings$preanalysis.script)
	} 
	## Set options
	if (length(analysis.options) != 0) {
		do.call(rnb.options, analysis.options)
	}

	logger.machine.name()

	if (cmdArgs$cores > 1) {
		parallel.setup(cmdArgs$cores)
	}

	aname <- rnb.getOption("analysis.name")
	if (!(is.null(aname) || is.na(aname) || nchar(aname) == 0)) {
		logger.info(c("Analysis Title:", aname))
	}
	ncores <- parallel.getNumWorkers()
	if (ncores == -1) {
		ncores <- 1L
	}
	logger.info(c("Number of cores:", ncores))
	rm(aname, ncores)
logger.completed()

logger.start(fname=c(file.path(report.dir,paste0("analysis_",module.name,".log")),NA))

################################################################################
# main script
################################################################################
if (rnb.getOption("import")) {
	if (is.character(data.source) || is.list(data.source) || inherits(data.source, "RnBSet")) {
		result <- rnb.run.import(data.source, data.type, report.dir)
		rnb.set <- result$rnb.set
	} else {
		stop("invalid value for data.source")
	}
} else if (inherits(data.source, "RnBSet")) {
	rnb.set <- data.source 
} else if (inherits(data.source, "MethyLumiSet")) {
	rnb.set <- as(data.source, "RnBeadSet")
} else {
	logger.warning("Cannot proceed with the supplied data.source. Check the option import")
	logger.completed()
	if (!is.null(logfile)) {
		logger.close()
	}
}

logger.start("Saving")
save.rnb.set(rnb.set, file.path(cmdArgs$output,paste0(module.name,"_RnBSet")), archive=FALSE)
logger.completed()

logger.status(c("...Completed module:",module.name))
quit(save='no')
