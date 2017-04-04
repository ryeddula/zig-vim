" Set ctags path
if has("mac")
    let g:tagbar_ctags_bin = "/usr/local/bin/ctags"
else
    let g:tagbar_ctags_bin = "/usr/bin/ctags"
endif

if executable('/opt/rh/python33/root/bin/python3.3')
    let g:python3_host_prog = '/opt/rh/python33/root/bin/python3.3'
elseif executable('/opt/rh/python33/root/usr/bin/python')
    let g:python3_host_prog = '/opt/rh/python33/root/usr/bin/python'
endif

if has('multi_byte')      " Make sure we have unicode support
   scriptencoding utf-8    " This file is in UTF-8
   set encoding=utf-8      " Default encoding should always be UTF-8
   set encoding=utf8
endif

execute pathogen#infect()
syntax on
filetype plugin indent on

" --------------------------------------------
" Basic vim settings
" --------------------------------------------

let mapleader="," " Set leader to ',' instead of '\'
"To open a new empty buffer
nmap <leader>t :enew<CR>
" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
nmap <leader>k :bprevious<CR>
" Close the current buffer and move to the previous one. This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

set mouse=
set incsearch              " Enable incremental searching
" Neovim feature for 'live' substitution
if exists('&inccommand')
  set inccommand=split
endif
set hlsearch               " Highlight search matches
set ignorecase             " Ignore case when searching...
set smartcase              " ...except when we don't want it
set infercase              " Attempt to figure out the correct case<F37>

set lazyredraw             " Lazy Redraw (faster macro execution)
set wildmenu               " Menu on completion please
set wildmode=longest,full  " Match the longest substring, complete with first
set wildignore+=*.o,*~,*/tmp/*,*.so,*.swp,*.zip,*.cmb.*js " Ignore temp files in wildmenu

set noerrorbells           " Disable error bells
set visualbell             " Turn visual bell on
set t_vb=                  " Make the visual bell emit nothing
set showcmd                " Show the current command

" Never really use these, so disable them.
" use screen/tmux in order to avoid 'terminal' disconnects
set nobackup
set noswapfile

" start with nohightlights
nohl

set tabstop=4              " 4 spaces for tabs
set shiftwidth=4           " 4 spaces for indents
set smarttab               " Tab next line based on current line
set expandtab             " Spaces for indentation
set autoindent             " Automatically indent next line
if has('smartindent')
   set smartindent            " Indent next line based on current line
endif

set showmatch " show matching brackets
set number " show line numbers

set cursorline
set scrolloff=10
set sidescroll=1
set sidescrolloff=15

" better wrapping
set wrap linebreak
set showbreak=" "

if &t_Co == 256
    set t_ut= "disable background color erase to avoid bleeding in screen

    " NOTE: 'base16-*' colorschemes usually require
    " you to be running a base16-shell: https://github.com/chriskempson/base16-shell
    " And some of them require this variable to be set:
    "let base16colorspace=256  " Access colors present in 256 colorspace
    if has('termguicolors')
        set termguicolors
    endif

    set background=dark
    colorscheme PaperColor
else
    colorscheme default
endif

let g:deoplete#enable_at_startup = 1

" Show trailing whitespace visually
if has('multi_byte') || has("gui_running")
   if v:version >= 700
      set list listchars=tab:»·,trail:✗,extends:…,nbsp:‗
   else
      set list listchars=tab:»·,trail:✗,extends:…
   endif
else
   if v:version >= 700
      set list listchars=tab:>-,trail:.,extends:>,nbsp:_
   else
      set list listchars=tab:>-,trail:.,extends:>
   endif
endif

" dont use Q for Ex mode
map Q :q

vmap <silent> <Tab> >gv " tab indents selection
vmap <silent> <S-Tab> <gv " shift-tab unindents

" make tab in normal mode ident code
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>

" Turn on spellcheck when writing git commit messages, cause #spalleing
if has("spell")
    autocmd FileType gitcommit set spell spelllang=en
endif

" Locally (local to block) rename a variable
function! Refactor()
    call inputsave()
    let @z=input("What do you want to rename '" . @z . "' to? ")
    call inputrestore()
endfunction

nmap gr "zyiw:call Refactor()<cr>mx:silent! norm gd<cr>[{V%:s/<C-R>//<c-r>z/g<cr>`x

" --------------------------------------------
" TIDY/FORMAT CODE.
" Tidy selected lines (or entire file) with _t:
" --------------------------------------------
vnoremap <silent> _t :call <SID>DoTidy(1)<CR>
nnoremap <silent> _t :call <SID>DoTidy(0)<CR>
vnoremap <silent> _T :call <SID>NonPrintable()<CR>
nnoremap <silent> _T :call <SID>NonPrintable()<CR>

function! s:DoTidy(visual) range
    let cmd = "cat"
    let winview = winsaveview()
    if &ft == "perl"
        let cmd = "perltidy -q"
    elseif &ft == "python"
        let cmd = "pythontidy"
    elseif &ft == "javascript"
        if executable('/usr/local/cpanel/3rdparty/node/bin/jsfmt')
            let cmd = "/usr/local/cpanel/3rdparty/node/bin/jsfmt"
        else
            let cmd = "/usr/local/cpanel/3rdparty/node/bin/js-beautify --config=~/.jsbeautifyrc --file -"
        endif
    endif
    if a:visual == 0
        let text = ":%!" . cmd
        execute text
    elseif a:visual == 1
        let text = ":'<,'>!" . cmd
        execute text
    end
    call winrestview(winview)
endfunction

function! NonPrintable()
   setlocal enc=utf8
   if search('[^\x00-\xff]') != 0
     call matchadd('Error', '[^\x00-\xff]')
     echo 'Non printable characters in text'
   else
     setlocal enc=latin1
     echo 'All characters are printable'
   endif
 endfunction

" --------------------------------------------
" Plugin settings.
" --------------------------------------------

" airline settings
let g:airline_theme = 'papercolor'
let g:airline_powerline_fonts = 1
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Ensures that the buffer of the old file will only be hidden when you switch to the new file,
" so that when you switch back, you still have your undo history.
set hidden
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

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
autocmd FileType c,cpp,java,python,perl nested :TagbarOpen

" Signify
let g:signify_vcs_list = [ 'git' ]
let g:signify_realtime = 1


" Syntastic settings
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_perl_checker = 1 " enable perl checks
let g:syntastic_auto_loc_list = 1  " autoopen the errors window when the buffer has errors.
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
" TODO: it appears that jshint shows stuff as warnings... so need to
" conditionally suppress warnings only perl files for now.
autocmd FileType perl let g:syntastic_quiet_messages = {'level': 'warnings'}
autocmd FileType html let g:syntastic_html_tidy_ignore_errors = [ "<cptext> unexpected or duplicate quote mark", "discarding unexpected <cpanel>", "discarding unexpected <cptext>", "<cptext> is not recognized!",  "<cpanel> is not recognized!", "<cptext> attribute with missing trailing quote mark" ]
let g:syntastic_enable_highlighting = 1
let g:syntastic_auto_jump = 0 " dont automatically jump to the first error
let g:syntastic_loc_list_height = 5
let g:syntastic_perl_checkers = ['perl', 'perlcritic']
let g:syntastic_perl_lib_path = ['./lib']
let g:syntastic_perl_perlcritic_args = '--profile ~/.perlcriticrc --stern --theme legacy'
let g:syntastic_perl_perl_args = '-Mstrict'

" TODO: Should probably just add this to my path instead...
if executable('/usr/local/cpanel/3rdparty/node/bin/jshint')
    let g:syntastic_javascript_checkers = ['jshint']
    let g:syntastic_javascript_jshint_exec = '/usr/local/cpanel/3rdparty/node/bin/jshint'
    let g:syntastic_javascript_jshint_args = "--verbose --config ~/.jshintrc"
    let g:ale_javascript_jshint_executable = '/usr/local/cpanel/3rdparty/node/bin/jshint'
    let g:ale_javascript_jshint_use_global = 1
    let g:ale_jshint_config_loc = "~/.jshintrc"
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
autocmd BufNewFile,BufRead *.tt setf tt2html | :TagbarClose
autocmd BufNewFile,BufRead *.tmpl,*.ptt set filetype=tt2html | :TagbarClose
" cursorcolumn slows down vim too much in these files
if (&ft == "javascript") || (&ft == "tt2html") || (&ft == "html")
    set nocursorcolumn
endif

" Folding
set foldlevel=3
set foldlevelstart=1
set foldnestmax=2
highlight Folded ctermbg=darkblue ctermfg=yellow
let perl_include_pod = 1
let perl_fold = 1
let perl_fold_packages = 1
let perl_nofold_blocks = 1
let perl_nofold_subs = 1
let perl_nofold_anonymous_subs = 1
let perl_want_scope_in_variables=1
let perl_extended_vars=1

" In normal mode, press Space to toggle the current fold open/closed.
" However, if the cursor is not in a fold, move to the right (the default
" behavior)
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" UltiSnips
let g:UltiSnipsSnippetDirectories=["UltiSnips", "bundle/cpanel-snippets"]

let g:ctrlp_cmd = 'CtrlP'
nmap <leader>p :CtrlP<CR>
let g:ctrlp_working_path_mode = 'rac'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$|(min|cmb|-.+).js$',
  \ }
