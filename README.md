# Presentation

makefly2hugo gives opportunity to import Makefly's weblog engine post into Hugo.

# Installation

    git clone https://github.com/blankoworld/makefly2hugo.git makefly2hugo

# Preparation

```bash
cd makefly
./makefly backup
cp mbackup/20160119-2058_makefly.tar.gz /path/to/makefly2hugo
```
It creates a backup file in *mbackup* directory. For an example **20160119-2058\_makefly.tar.gz**.

Place it into **makefly2hugo** git

Then do:

```bash
cd makefly2hugo
tar xvf 20160119-2058_makefly.tar.gz
bash makefly2hugo.sh
```
