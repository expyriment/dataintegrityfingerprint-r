library(digest)

CHECKSUMS_SEPERATOR = "  "

#' Create a hash for a given file.
#'
#' Create a hash for a given file.
#' @param param TODO
#' @export export
#' @examples example

file_hash <- function(filename, hash_algorithm="sha256") {
  x = readBin(filename, what="raw", n=file.info(filename)$size)
  return(digest(x, algo=hash_algorithm,  serialize = F))
}


#' Create a Data Integrity Fingerprint
#'
#' Create a Data Integrity Fingerprint
#' @param param TODO
#' @export export
#' @examples example

data_integrity_fingerprint <- function(folder, hash_algorithm="sha256") {
  filelist = list.files(folder, recursive=T, all.files=T)
  hashes = c()
  for (f in filelist) {
    hashes = c(hashes,
               file_hash(filename=file.path(folder, f),
                         hash_algorithm=hash_algorithm))
  }

  rtn = list()
  rtn$folder = folder
  rtn$hash_algorithm = hash_algorithm
  rtn$checksums = data.frame(hash = hashes, file = filelist)
  class(rtn) = "DIF"
  return(sort(rtn))
}

#' Sort checksums of a data integrity fingerprint
#'
#' Sort checksums of a data integrity fingerprint
#' @param param TODO
#' @export export
#' @examples example

sort.DIF <- function(x) {
  # sorting byte-wise (captial letters first) like unix under locale "C"
  idx = order(x$checksums$hash, x$checksums$file, method="radix")
  x$checksums = x$checksums[idx, ]
  return(x)
}


#' print data_integrity_fingerprint
#'
#' print data_integrity_fingerprint
#' @param param TODO
#' @export export
#' @examples example

print.DIF <- function(x) {
  cat("Folder: ")
  cat(x$folder)
  cat(" (Files n=")
  cat(nrow(x$checksums))
  cat(")")
  cat("\nAlgorithm: ")
  cat(x$hash_algorithm)
  cat("\nMaster hash: ")
  cat(master_hash(x), "\n")
}

#' String representations of the checksums and filenames
#'
#' Sorted list of checksums for each file. Hash this list
#' @param param TODO
#' @export export
#' @examples example

checksums_str <- function(x) {
  rtn = ""
  for (i in 1:nrow(x$checksums)) {
    l = paste0(x$checksums[i,1], CHECKSUMS_SEPERATOR,
               x$checksums[i,2], sep="\n")
    rtn = paste0(rtn, l)
  }
  return(rtn)
}

#' TODO A Cat Function
#'
#' This function allows you to express your love of cats.
#' @param param TODO
#' @export export
#' @examples example

master_hash <- function(x) {
  return(digest(checksums_str(x), algo=x$hash_algorithm,  serialize = F))
}

#' TODO A Cat Function
#'
#' This function allows you to express your love of cats.
#' @param param TODO
#' @export export
#' @examples example
write_checksums <- function(x, filename) {
  fl <- file(filename)
  writeLines(checksums_str(x), fl, sep="")
  close(fl)
}

#' TODO A Cat Function
#'
#' This function allows you to express your love of cats.
#' @param param TODO
#' @export export
#' @examples example

load_checksums <- function(filename, hash_algorithm) {
  rtn = list()
  rtn$folder = NA
  rtn$hash_algorithm = hash_algorithm
  hashes = c()
  files = c()
  fl = file(filename, "r")
  while ( TRUE ) {
    line = readLines(fl, n = 1)
    if ( length(line) == 0 ) {
      break
    }
	line = unlist(strsplit(line, CHECKSUMS_SEPERATOR))
	hashes = c(hashes, line[1])
	files = c(files, line[2])
  }
  close(fl)
  rtn = data.frame(hash=hashes, file=files)
  class(rtn) = "DIF"
  return(sort(rtn))
}
