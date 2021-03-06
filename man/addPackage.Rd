% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/addPackages.R
\name{addPackage}
\alias{addPackage}
\title{Add packages to a miniCRAN repository.}
\usage{
addPackage(pkgs = NULL, path = NULL, repos = getOption("repos"),
  type = "source", Rversion = R.version, writePACKAGES = TRUE,
  deps = TRUE, quiet = FALSE)
}
\arguments{
\item{pkgs}{Character vector of packages to download}

\item{path}{Destination download path. This path is the root folder of your new repository.}

\item{repos}{URL(s) of the 'contrib' sections of the repositories, e.g. \code{"http://cran.us.r-project.org"}. Passed to \code{\link{available.packages}}}

\item{type}{Possible values are (currently) "source", "mac.binary" and "win.binary": the binary types can be listed and downloaded but not installed on other platforms.  Passed to \code{\link{download.packages}}.}

\item{Rversion}{numeric version of the R system for which to fetch packages. See \code{\link{R_system_version}}.}

\item{writePACKAGES}{If TRUE, calls \code{\link{write_PACKAGES}} to update the repository PACKAGES file.}

\item{deps}{logical indicating whether the package dependencies should be added (default \code{TRUE}).}

\item{quiet}{If TRUE, suppress status messages (if any), and the progress bar during download.}
}
\value{
Installs the packages, rebuilds the package index, and invisibly returns the number of packages writen to the index files.
}
\description{
Add packages to a miniCRAN repository.
}
\examples{
### `checkVersions` and `add.packages.miniCRAN` require an existing miniCRAN repo

# Specify list of packages to download
revolution <- c(CRAN = "http://mran.microsoft.com")
pkgs <- c("foreach")

pdb <- cranJuly2014

\dontrun{
  pdb <- pkgAvail(repos=revolution, type="source")
}

pkgList <- pkgDep(pkgs, availPkgs=pdb, repos=revolution, type="source", suggests=FALSE)
pkgList

\dontrun{
  # Create temporary folder for miniCRAN
  dir.create(pth <- file.path(tempdir(), "miniCRAN"))

  # Make repo for source and win.binary
  makeRepo(pkgList, path=pth, repos=revolution, type="source")
  makeRepo(pkgList, path=pth, repos=revolution, type="win.binary")

  # Add other versions of a package (and assume these were added previously)
  oldVers <- data.frame(package=c("foreach", "codetools", "iterators"),
                        version=c("1.4.0", "0.2-7", "1.0.5"),
                        stringsAsFactors=FALSE)
  pkgs <- oldVers$package
  addOldPackage(pkgs, path=pth, vers=oldVers$version, repos=revolution, type="source")
  # NOTE: older binary versions would need to be build from source

  # List package versions in the miniCRAN repo (produces warning about duplicates)
  pkgVersionsSrc <- checkVersions(pkgs, path=pth, type="source")
  pkgVersionsBin <- checkVersions(pkgs, path=pth, type="win.binary")

  # After inspecting package versions, remove old versions
  basename(pkgVersionsSrc) # "foreach_1.4.0.tar.gz"  "foreach_1.4.2.tar.gz"
  basename(pkgVersionsBin) # "foreach_1.4.0.zip"     "foreach_1.4.2.zip"
  file.remove(c(pkgVersionsSrc[1], pkgVersionsBin[1]))

  # Rebuild package index after adding/removing files
  updateRepoIndex(pth, type=c("source", "win.binary"), Rversion=R.version)
  
  pkgAvail(pth, type="source")

  # Add new packages (from CRAN) to the miniCRAN repo
  addPackage("Matrix", path=pth, repos=revolution, type="source")
  addPackage("Matrix", path=pth, repos=revolution, type="win.binary")

  # Delete temporary folder
  unlink(pth, recursive=TRUE)
}
}
\seealso{
Other update repo functions: \code{\link{addOldPackage}},
  \code{\link{checkVersions}}, \code{\link{makeRepo}},
  \code{\link{updatePackages}}
}

