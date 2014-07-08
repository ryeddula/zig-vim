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

" start with nohightlights
nohl

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

" Tidy selected lines (or entire file) with _t:
nnoremap <silent> _t :%!perltidy -q<Enter>
vnoremap <silent> _t :!perltidy -q<Enter>


" Deparse obfuscated code
nnoremap <silent> _d :.!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> _d :!perl -MO=Deparse 2>/dev/null<cr>

" Perl Specific
let perl_include_pod=1
let perl_fold=1
let perl_nofold_subs=1

" In normal mode, press Space to toggle the current fold open/closed.
" However, if the cursor is not in a fold, move to the right (the default
" behavior)
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" syntax color complex things like @{${"foo"}}
let perl_extended_vars=1

" Folding
set foldmethod=syntax
set foldlevel=3
set foldlevelstart=1
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
autocmd FileType c,cpp,java,python,perl nested :TagbarOpen
" autocmd BufEnter * nested :call tagbar#autoopen(0)

if has("gui_running")
    set lines=24 " Needed on drpepper.
    set columns=40
    let &guicursor = &guicursor . ",a:blinkon0"
    colorscheme railscasts
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
    set t_ut= "disable background color erase to avoid bleeding in screen
    colorscheme railscasts
else
    colorscheme default
endif

" Neocomplete settings
let g:neocomplete#enable_at_startup = 1 " enable neocomplete on startup
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"
" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
" let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

let g:neocomplete#disable_auto_complete=1 " don't start autocompletion until tab is pressed.

" Syntastic settings
let g:syntastic_check_on_open=1
let g:syntastic_enable_perl_checker=1 " enable perl checks
let g:syntastic_auto_loc_list=1  " autoopen the errors window when the buffer has errors.
let g:syntastic_quiet_messages = {'level': 'warnings'}
let g:syntastic_enable_highlighting=1
let g:syntastic_auto_jump=1
let g:syntastic_loc_list_height=5
let g:syntastic_perl_checkers=['perl']
