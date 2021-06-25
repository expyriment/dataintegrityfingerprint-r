Data Integrity Fingerprint (DIF)
================================

*Released under the MIT License*

Oliver Lindemann (oliver@expyriment.org) & Florian Krause (florian@expyriment.org)

General Documentation: http://expyriment.github.io/DIF

### Installing

To install the latest development version, you can use `install_github` from the `devtools` package:

```R
## install devtools if necessary
install.packages('devtools')

## install package
library(devtools)
install_github('expyriment/dataintegrityfingerprint-r', subdir='dataintegrityfingerprint')
```


### Usage
```R
library(dataintegrityfingerprint)

d = DIF('<DATA_PATH>')
print(d)
write_checksums(d, filename="data.checksums")
```



