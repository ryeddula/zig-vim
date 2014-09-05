" Set ctags path
if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        let g:tagbar_ctags_bin = "/usr/local/bin/ctags"
    else
        let g:tagbar_ctags_bin = "/usr/bin/ctags"
    endif
endif

execute pathogen#infect()
syntax on
filetype plugin indent on

" airline settings
let g:airline_theme = 'murmur'
let g:airline_powerline_fonts = 1
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Ensures that the buffer of the old file will only be hidden when you switch to the new file,
" so that when you switch back, you still have your undo history.
set hidden
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Set leader to ',' instead of '\'
let mapleader=","

" To open a new empty buffer
nmap <leader>t :enew<cr>
" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

" use visual bell instead of beeping
set vb

" search
set ignorecase
set smartcase
set incsearch
set hlsearch
set gdefault

" syntax highlighting
set bg=light

" start with nohightlights
nohl

" autoindent
set autoindent
set smartindent

" 4 space tabs
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

" show matching brackets
set showmatch

" show line numbers
set number

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
autocmd FileType perl nnoremap <silent> _t :%!perltidy -q<Enter>
autocmd FileType perl vnoremap <silent> _t :!perltidy -q<Enter>
autocmd FileType javascript nnoremap <silent> _t :%!uglifyjs -b<Enter>
autocmd FileType javascript vnoremap <silent> _t :!uglifyjs -b<Enter>

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

" Exception Highlighting
match ErrorMsg '\s\+$'
"match Error /\%81v.\+/

" cursor position
set cursorline
set cursorcolumn
set scrolloff=4
set sidescroll=1
set sidescrolloff=15

" better wrapping
set wrap linebreak
set showbreak=" "

" Tagbar
nmap <F8> :TagbarOpen fj<CR>
nmap <F9> :TagbarToggle<CR>
let g:tagbar_compact = 1
let g:tagbar_show_linenumbers = 0 " Show absolute line numbers
let g:tagbar_iconchars = ['+', '-']
let g:tagbar_width = 25
let g:tagbar_sort = 0
" This fixes error such as:
"   E432: Tags file not sorted: /usr/share/vim/vim74/doc/tags
"   E432: Tags file not sorted: /usr/share/vim/vim74/doc/tags
"   E426: tag not found: executable()@en
set notagbsearch
" autocmd VimEnter * nested :call tagbar#autoopen(1)
autocmd FileType c,cpp,java,python,perl nested :TagbarOpen
" autocmd BufEnter * nested :call tagbar#autoopen(0)

if has("gui_running")
    set lines=24 " Needed on drpepper.
    set columns=40
    let &guicursor = &guicursor . ",a:blinkon0"
    colorscheme Tomorrow-Night
    if has("gui_gtk")
        set guifont=Monospace\ 14
        set lines=43
        augroup set
          au FileType gitcommit    set lines=24
          au FileType asciidoc     set lines=24
          au FileType review       set columns=80
        augroup end
    elseif has("gui_kde")
    elseif has("gui_x11")
    elseif has("gui_macvim")
        set guifont=Monaco\ 10
    else
    endif
elseif &t_Co == 256
    set t_ut= "disable background color erase to avoid bleeding in screen
    colorscheme Tomorrow-Night
else
    colorscheme default
endif

" Syntastic settings
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_perl_checker = 1 " enable perl checks
let g:syntastic_auto_loc_list = 1  " autoopen the errors window when the buffer has errors.
" TODO: it appears that jshint shows stuff as warnings... so need to
" conditionally suppress warnings only perl files for now.
"let g:syntastic_quiet_messages = {'level': 'warnings'}
let g:syntastic_enable_highlighting = 1
let g:syntastic_auto_jump = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_perl_checkers = ['perl']
" TODO: Should probably just add this to my path instead...
if executable('/usr/local/cpanel/3rdparty/node/bin/jshint')
    let g:syntastic_javascript_checkers = ['jshint']
    let g:syntastic_javascript_jshint_exec = '/usr/local/cpanel/3rdparty/node/bin/jshint'
    let g:syntastic_javascript_jshint_args = "--verbose --config ~/.jshintrc"
endif
if has("unix")
    let g:syntastic_error_symbol = '✗✗'
    let g:syntastic_style_error_symbol = '✠✠'
    let g:syntastic_warning_symbol = '∆∆'
    let g:syntastic_style_warning_symbol = '≈≈'
else
    let g:syntastic_error_symbol = 'X'
    let g:syntastic_style_error_symbol = '>'
    let g:syntastic_warning_symbol = '!'
    let g:syntastic_style_warning_symbol = '>'
endif
" map the quit calls to also close the syntastic error windows, so it doesn't
" hold us up unnecessarily
cabbrev q lcl\|q


" Associate *.tt files with template toolkit
" TODO: figure why this doesn't get auto detected...
autocmd BufNewFile,BufRead *.tt setf tt2html

" Turn on spellcheck when writing git commit messages, cause #spalleing
if has("spell")
    autocmd FileType gitcommit set spell spelllang=en_us
endif

" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>
