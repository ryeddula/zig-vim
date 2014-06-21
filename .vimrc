" Set ctags path
if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        let g:tagbar_ctags_bin = "/usr/local/bin/ctags"
    else
        let g:tagbar_ctags_bin = "/usr/bin/ctags"
    endif
endif

let g:airline_theme = 'murmur'

execute pathogen#infect()
syntax on
filetype plugin indent on

let g:airline_powerline_fonts = 1

" Set leader to ',' instead of '\'
let mapleader=","

" use visual bell instead of beeping
set vb

" incremental search
set incsearch

" syntax highlighting
set bg=light
syntax on

" autoindent
autocmd FileType perl set autoindent|set smartindent

" 4 space tabs
autocmd FileType perl set tabstop=4|set shiftwidth=4|set expandtab|set softtabstop=4

" show matching brackets
autocmd FileType perl set showmatch

" show line numbers
autocmd FileType perl set number

" check perl code with :make
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

" dont use Q for Ex mode
map Q :q

" make tab in v mode ident code
vmap <tab> >gv
vmap <s-tab> <gv

" make tab in normal mode ident code
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>

" comment/uncomment blocks of code (in vmode)
vmap _c :s/^/#/gi<Enter>
vmap _C :s/^#//gi<Enter>

" my perl includes pod
let perl_include_pod = 1

" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1

" Tidy selected lines (or entire file) with _t:
nnoremap <silent> _t :%!perltidy -q<Enter>
vnoremap <silent> _t :!perltidy -q<Enter>


" Deparse obfuscated code
nnoremap <silent> _d :.!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> _d :!perl -MO=Deparse 2>/dev/null<cr>

" Perl Specific
let perl_include_pod = 1
let perl_fold = 1

" Folding
set foldmethod=syntax
set foldlevel=2
set foldnestmax=2
highlight Folded ctermbg=darkblue ctermfg=yellow

" Tab Spacing
set expandtab
set tabstop=4
set shiftwidth=4

" Exception Highlighting
match ErrorMsg '\s\+$'
"match Error /\%81v.\+/

" Tagbar
nmap <F8> :TagbarOpen fj<CR>
nmap <F9> :TagbarToggle<CR>
let g:tagbar_compact = 1
let g:tagbar_show_linenumbers = 0 " Show absolute line numbers
let g:tagbar_iconchars = ['+', '-']
let g:tagbar_width = 25
let g:tagbar_sort = 0
" autocmd VimEnter * nested :call tagbar#autoopen(1)
autocmd FileType perl nested :TagbarOpen
" autocmd BufEnter * nested :call tagbar#autoopen(0)

if has("gui_running")
    set lines=24 " Needed on drpepper.
    set columns=40
    let &guicursor = &guicursor . ",a:blinkon0"
    colorscheme hybrid
    if has("gui_gtk")
        set guifont=Monospace\ 14
        set lines=43
        augroup set
          au FileType gitcommit    set lines=24
          au FileType asciidoc    set lines=24
          au FileType review        set columns=81
        augroup end
    elseif has("gui_kde")
    elseif has("gui_x11")
    elseif has("gui_macvim")
        set guifont=Monaco\ 10
    else
    endif
elseif &t_Co == 256
    colorscheme hybrid
else
    colorscheme hybrid
endif

