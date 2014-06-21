Recommended vim version: 7.4

Installing the submodules
-------------------------
git submodule update --init --recursive

Updating all submodules in one go
---------------------------------
git submodule update --remote --merge

Special Module information
==========================

Tagbar
------
Requires excuberant ctags: http://ctags.sourceforge.net/

YouCompleteMe
-------------
```bash
cd ~/.vim/bundle/vim-youcompleteme/
./install.sh --clang-completer
```

