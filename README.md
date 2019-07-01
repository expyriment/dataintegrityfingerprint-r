Data Integrity Fingerprint (DIF)
================================

*Released under the MIT License*

Oliver Lindemann (oliver@expyriment.org) & Florian Krause (florian@expyriment.org)

General Documentation: http://expyriment.github.io/dataintegrityfingerprint


Usage
```
source('dif.R')

d = DIF('<DATA_PATH>')
print(d)
summary(d) # show checksums
write_checksums(d, filename="data.checksums")
```



