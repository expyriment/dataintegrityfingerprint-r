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


#' Create a XXXX
#'
#' Create a XXX
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
  rtn$file_hash_list = data.frame(hash = hashes, file = filelist)
  # sorting list
  #   byte-wise sorting (Capital letters first) like unix under locale "C"
  idx = order(rtn$file_hash_list$file, method="radix")
  rtn$file_hash_list = rtn$file_hash_list[idx, ]
  class(rtn) = "DIF"
  return(rtn)
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
  cat(nrow(x$file_hash_list))
  cat(")")
  cat("\nAlgorithm: ")
  cat(x$hash_algorithm)
  cat("\nMaster hash: ")
  cat(dif(x), "\n")
}

#' String representations of the checksums and filenames
#'
#' Sorted list of checksums for each file. Hash this list
#' @param param TODO
#' @export export
#' @examples example

checksums <- function(dif_obj) {
  rtn = ""
  for (i in 1:nrow(dif_obj$file_hash_list)) {
    l = paste0(dif_obj$file_hash_list[i,1], CHECKSUMS_SEPERATOR,
               dif_obj$file_hash_list[i,2], sep="\n")
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

dif <- function(dif_obj) {

  # make list of concatenate hashes and file names
  lst = c()
  for( i in 1:nrow(dif_obj$file_hash_list)) {
    lst = c(lst, paste0(dif_obj$file_hash_list[i, 'hash'], dif_obj$file_hash_list[i, 'file']))
  }
  # sorting byte-wise (capital letters first) like Unix under locale "C"
  idx = order(lst, method="radix")
  # concatenate sorted list
  concat_sorted = paste0(lst[idx], collapse='')
  # return hash concat_sorted
  return(digest(concat_sorted, algo=dif_obj$hash_algorithm,  serialize = F))
}

#' TODO A Cat Function
#'
#' This function allows you to express your love of cats.
#' @param param TODO
#' @export export
#' @examples example
write_checksums <- function(dif_obj, filename) {
  fl <- file(filename)
  writeLines(checksums(dif_obj), fl, sep="")
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

