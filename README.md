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

cPanel Snippets
---------------
* Clone the vim snippets repo to a location outside of the repo.
* Create a symlink to that location in the 'bundle' directory:
```
cd bundle
ln -s /path/to/cpanel-vim-snippets/ ./cpanel-snippets
```
