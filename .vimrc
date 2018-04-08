" Section: Options {{{1
"--------------------

set nocompatible                  " improved Vim experience
scriptencoding utf-8              " utf-8 all the way
set encoding=utf-8 nobomb         " do not use BOM
if has("eval")                    " Use 'cp1252' encoding instead of 'latin1'
    let &fileencodings=substitute(&fileencodings,"latin1","cp1252","")
endif
set fileformats=unix,dos,mac
set autoread                      " Automatically read outside changes to a file
set autowrite                     " Auto-save before commands like :next and :make
set hidden                        " Allow switch buffer without saving changes
set history=1000                  " Size of vim history
set clipboard=unnamed             " Yank to clipboard directly
set lazyredraw                    " See help
set noignorecase                  " Case insensitive search
set smartcase                     " Case insensitive searches become sensitive with capitals
set switchbuf=usetab
set nostartofline                 " Don't reset cursor to start of line when moving
set splitbelow                    " Open new horizontal split below the current window
set splitright                    " Open new vertical split rigth to the current window
set timeoutlen=1200               " A little bit more time for macros
set ttimeoutlen=50                " Make Esc work faster

" Subsection: Indent {{{2
"--------------------
set autoindent                    " Automatically insert indent after new line
set smartindent                   " Make autoindent even better
set expandtab                     " Use spaces instead of tab
set shiftround                    " Round intent to multiple of 'shiftwidth'
set shiftwidth=4                  " Indent size in spaces for autoindent commands (>> CTRL-T)
set tabstop=4                     " Tab size in spaces
" }}}2

set backspace=indent,eol,start    " Enable <BS> in insert mode
set formatoptions-=t              " Disable auto-wrap text
set formatoptions-=c              " Disable auto-wrap comments
set formatoptions-=o              " Do not insert comment leader on hitting 'o'
set formatoptions+=j              " Delete comment character when joining commented lines
set nrformats-=octal              " Do not treat '007' as octal number on <C-A> or <C-X>

" Subsection: Autocomplete {{{2
"--------------------
set wildmenu                      " Enhanced command line auto-complition
set wildmode=longest:full,full
set complete-=i                   " Disable parsing included files for autocompletion with <C-P> and <C-N> (:help 'include')
"set completeopt-=preview          " Do not show preview window for selected autocomlete option
set completeopt+=menu             " Show select menu for autocomplete.
set completeopt+=menuone          " Show select menu even if autocomplete menu contains a single option
set completeopt+=longest          " Only inset the longest common text of the match
set completeopt+=noselect         " Do not autoselect autocomplete option from menu.
" }}}2
" Subsection: Visual {{{2
"--------------------
if exists('+breakindent')         " same as +linebreak
    set wrap linebreak breakindent " Wrap long lines of text and auto-indent (only visualy)
    set showbreak=+>\             " String to put at the start of lines that have been wrapped
else
    set nowrap                    " Do not wrap lines which longer then viewpoint width
    set textwidth=0               " Disable line width restriction
endif
set relativenumber                " Show line number relative to the current line
set number                        " Show current line number
set cursorline                    " Highlight of the current line
set scrolloff=2                   " Min number of screen lines to keep above and below the cursor
set sidescrolloff=5               " Min number of screen columns to keep to the left and to the right of cursor
set title                         " Show filename in the window titlebar
set showtabline=2                 " Always display the tabline
set laststatus=2                  " Always display the statusline
set cmdheight=1                   " Size of command line
set display+=lastline
"set showcmd                      " Show (partial) command in status line
set incsearch                     " Highlight matches while typing search pattern
set hlsearch                      " Highlight search matches
set foldmethod=marker
set foldopen+=jump
set list                          " Show 'invisible' characters
if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
    let &listchars="tab:\u25b8\u0020,trail:\u2423,eol:\u00ac,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
    let &fillchars = "vert:\u259a,fold:\u002d"
else
    set listchars=tab:>\ ,trail:·,eol:¬,nbsp:_,extends:>,precedes:<
endif
" }}}2
" Subsection: GUI {{{2
"--------------------
if has("gui_running")
    set mouse=nvi
    set mousemodel=popup
    set winaltkeys=no
    set title icon
    set guioptions-=T
    set guioptions-=m
    set guioptions-=e
    set guioptions-=r
    set guioptions-=L
endif
" }}}2
" Subsection: File paths {{{2
"--------------------
set dictionary+=/usr/share/dict/words
setglobal tags=./tags
set viminfo=!,'20,<50,s10,h,n~/.vim/viminfo
set backupdir^=~/.vim/backups
set directory^=~/.vim/swaps
if exists('+undofile')
    set undodir^=~/.vim/undo
endif
if !empty($SUDO_USER) && $USER !=# $SUDO_USER
    set viminfo=
endif
" }}}2
" Subsection: Plugin Settings {{{2
"--------------------
" CtrlP Settings {{{3
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_by_filename = 0
let g:ctrlp_regexp = 0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_open_multiple_files = 'i'
"let g:ctrlp_types = ['fil', 'mru']
let g:ctrlp_mruf_include = '\.py$\|\.php$|\.js$|\.json$|\.sh$|\.conf$|\.dist'
" }}}3
" Syntastic Settings {{{3
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_php_checkers = ['phpcs', 'phpstan', 'php']
let g:syntastic_php_phpcs_args = '--no-color --no-cache -q -w'
" }}}3
" ALE Settings {{{3
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 0
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:ale_maximum_file_size = 51200
" Error message format.
let g:ale_echo_cursor = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_info_str = 'I'
let g:ale_echo_msg_warning_str = 'W'
" }}}3
" PHPComplete {{{3
let g:phpcomplete_parse_docblock_comments = 1
let g:phpcomplete_add_class_extensions = ['pthreads']
let g:phpcomplete_add_constant_extensions = ['pthreads']
let g:phpcomplete_remove_function_extensions = ['memcache', 'mysql', 'sqlite']
let g:phpcomplete_remove_class_extensions = ['memcache']
let g:phpcomplete_remove_constant_extensions = ['memcache', 'mysql', 'sqlite']
" }}}3
" NERDTree Settings {{{3
let g:NERDTreeNaturalSort = 1
let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'
" }}}3
" Airline Settings {{{3
let g:airline_section_z = '%#__accent_bold#%3l/%L%#__restore__# :%3v'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffers_label = 'bufs'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tagbar#flags = 's'
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#syntastic#enabled = 0
" }}}3
" Startify {{{3
let g:startify_bookmarks = []
"let g:startify_list_order = ['files', 'bookmarks', 'sessions']
let g:startify_files_number = 8
let g:startify_enable_special = 0
let g:startify_update_oldfiles = 1
let g:startify_change_to_dir = 1
let g:startify_change_to_vcs_root = 1
let g:startify_session_dir = '~/.vim/session'
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_session_sort = 1
let g:startify_session_before_save = [
    \ 'echo "Cleaning up before saving.."',
    \ 'silent! NERDTreeClose'
    \ ]
" }}}3
" Tagbar {{{3
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
" }}}3
" GitGutter {{{3
let g:gitgutter_map_keys = 0
"let g:gitgutter_grep = 'grep --color=never'
" }}}3
" IndentLine {{{3
let g:indentLine_setColors = 0
let g:indentLine_setConceal = 0
let g:indentLine_faster = 1
let g:indentLine_char = '┆'
let g:indentLine_leadingSpaceEnabled = 0
let g:indentLine_bufNameExclude = ['_.*', 'NERD_tree.*', '.*\/vim\d\+\/doc\/.*', '.*\/\.vim\/.*\/doc\/.*']
let g:indentLine_enabled = 1
" }}}3
" NERDCommenter {{{3
let g:NERDCompactSexyComs = 0
let g:NERDDefaultAlign = 'left'
let g:NERDTrimTrailingWhitespaces = 1
" }}}3
" Syntax Highlight Settings {{{3
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_conceal = 0
let g:php_html_load = 0
let g:php_sql_query = 0
" }}}3
" }}}2
" }}}1
" Section: Commands {{{1
"--------------------
command! -bar -count=0 RFC :edit http://www.ietf.org/rfc/rfc<count>.txt|setl ro noma
command! -bar -nargs=? -bang Scratch :silent e<bang> Sess-Notes|set buftype=nofile bufhidden=hide noswapfile nobuflisted filetype=<args> modifiable

let s:my_clr=['gruvbox', 'hybrid', 'jellybeans', 'solarized']
for s:clr in s:my_clr
    execute "command! Clr".s:clr." :colorscheme ".s:clr
endfor

command! -bar -buffer Olink :call <SID>Open_url_in_cmd_brouser()
function! s:Open_url_in_cmd_brouser()
    let l:url_pattern='\(https\?\|mailto\):\/\/[^ >)}\]]\+'
    let l:oldreg=getreg('/', 1)
    execute 'normal! m`'
    if search(l:url_pattern, 'cw', line('.')) == 0
        execute 'normal! B'
    endif
    if search(l:url_pattern, 'cw', line('.'))
        let l:href=matchstr(getline(line('.')), l:url_pattern, col('.')-1)
        call system("links '" . l:href . "'")
        echom 'Url was opened in Links'
    endif
    call setreg('/', l:oldreg)
    execute 'normal ``'
endfunction
" }}}1
" Section: Plugins {{{1
"--------------------
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !mkdir -p ~/.vim/autoload
    silent !mkdir -p ~/.vim/plug.vim.bundle
    silent !wget -qO - 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' > ~/.vim/autoload/plug.vim
    autocmd VimEnter * PlugInstall --sync
    source ~/.vimrc
endif
call plug#begin('~/.vim/plug.vim.bundle')
" Themes and color schemes
Plug 'altercation/vim-colors-solarized'
Plug 'nanotech/jellybeans.vim'
Plug 'morhetz/gruvbox'
Plug 'w0ng/vim-hybrid'

" Visual goodies
Plug 'vim-airline/vim-airline'         " Prity statusline
Plug 'vim-airline/vim-airline-themes'  " Themes fot statusline
Plug 'mhinz/vim-startify'              " Fancy start screen
"Plug 'Yggdroot/indentLine'             " Highlight indent level

" Syntax highlight
"Plug 'plasticboy/vim-markdown'
"Plug 'chr4/nginx.vim'
"Plug 'exu/pgsql.vim'

" Miscellaneous plugins
Plug 'a1black/vim-misc'                " My Vim commands
"Plug 'xolox/vim-misc'                  " Library required for all plugins by Xolox

" Filesystem and search
"Plug 'scrooloose/nerdtree'             " File system tree explorer
"Plug 'Xuyuanp/nerdtree-git-plugin'     " Git status in NERDTree
Plug 'tpope/vim-vinegar'               " Extension for built-in netrw plugin
Plug 'ctrlpvim/ctrlp.vim'              " Fuzzy finder

" Editing tools
Plug 'scrooloose/nerdcommenter'        " Code commenting tool
Plug 'godlygeek/tabular'               " Text aligning
"Plug 'vimwiki/vimwiki'                 " Personal Wiki for Vim :meh
"Plug 'mtth/scratch.vim'                " Note taking
Plug 'tpope/vim-surround'              " Surrounding text with quoates and tags (HTML)
Plug 'a1black/vim-quickfixtoggle'      " Quickfix window toggling

" Vim functionality enhancement
Plug 'easymotion/vim-easymotion'       " Enhanced motion in Vim
Plug 'tpope/vim-unimpaired'            " Create mappings for square brackets
Plug 'tpope/vim-repeat'                " Enhanced repeat in Vim

" Version control systems
Plug 'airblade/vim-gitgutter'          " Git status in sign column
"Plug 'mhinz/vim-signify'               " VCS status in sign column
Plug 'tpope/vim-fugitive'              " Git plugin fot Vim

" Development
Plug 'w0rp/ale'                        " Lint engine
"Plug 'vim-syntastic/syntastic'         " Lint engine
"Plug 'SirVer/ultisnips'                " Code snippet engine
"Plug 'honza/vim-snippets'              " Code snippet library
"Plug 'tpope/vim-dispatch'              " :Make command for Vim.
"Plug 'janko-m/vim-test'                " Test invokation plugin
Plug 'majutsushi/tagbar'               " On-the-fly in-memory tags creation
"Plug 'xolox/vim-easytags'              " Automated tag generation
"Plug 'Valloric/YouCompleteMe'          " Code completion tool

" HTML/CSS/JS related packages
"Plug 'elzr/vim-json'                   " JSON syntax highlight
"Plug 'pangloss/vim-javascript'         " JavaScript syntax highlight
"Plug 'othree/html5.vim'                " HTML5 syntax highlight
"Plug 'mattn/emmet-vim'                 " HTML5 and XML programming enhantment

" PHP related packages
Plug 'StanAngeloff/php.vim'                           " Syntax highlight
Plug 'vim-php/tagbar-phpctags.vim', {'for': 'php'}    " Enhanced Tagbar for PHP code
Plug 'shawncplus/phpcomplete.vim', {'for': 'php'}     " PHP code completion

" PYTHON related packages
"Plug 'klen/python-mode', {'for': 'python'}            " Tool set for python development
"Plug 'davidhalter/jedi-vim', {'for': 'python'}        " Code autocompletion for python
call plug#end()
" }}}1
" Section: Mappings {{{1
"--------------------
" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Clear the highlighting search results
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>
" Exit insert and return cursor to last position
inoremap <silent> <C-C> <Esc>`^
" Break undo sequence
inoremap <C-U> <C-G>u<C-U>
" Copy/paste to system clipboard
map Y y$
map <leader>cp "+p
" Window split resize
nnoremap <silent> <C-w><C-h> :vertical resize -5<CR>
nnoremap <silent> <C-w><C-j> :resize +5<CR>
nnoremap <silent> <C-w><C-k> :resize -5<CR>
nnoremap <silent> <C-w><C-l> :vertical resize +5<CR>
" Save/close shortcats
nnoremap <leader>s :update<CR>
nnoremap <leader>S :wall<CR>
nnoremap <silent> <leader>wq :exit<CR>
nnoremap <silent> <leader>qa :qall!<CR>
nnoremap <silent> <leader>bd :lclose<CR>:bdelete<CR>
nnoremap <silent> <leader>x :close<CR>

map      <silent> <F1> <Esc>g<C-G>
map!     <silent> <F1> <Esc>g<C-G>
nnoremap <silent> <F1> :if exists(':Startify')<Bar>exe 'Startify'<Bar>else<Bar>echoerr 'Startify is not available.'<Bar>endif<CR>
nnoremap <silent> <F2> :pclose<CR>
nnoremap <silent> <F3> :Ltoggle<CR>
nnoremap <silent> <F4> :Ctoggle<CR>
nnoremap <silent> <F5> :if exists(':TagbarToggle')<Bar>exe 'TagbarToggle'<Bar>else<Bar>echoerr 'Tagbar is not available.'<Bar>endif<CR>
nnoremap <silent> <F6> :if &previewwindow<Bar>pclose<Bar>elseif exists(':Gdiff')<Bar>exe 'Gdiff'<Bar>else<Bar>echoerr 'Fugitive is not available.'<Bar>endif<CR>
nnoremap <silent> <F7> :echo '<F7>'<CR>
nnoremap <silent> <F8> :echo '<F8>'<CR>
nmap     <silent> <F9> :echo '<F9>'<CR>
"Open app menu   <F10>
"Fullscreen mod  <F11>
set  pastetoggle=<F12>

" GitGutter
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterUndoHunk
nmap <Leader>hp <Plug>GitGutterPreviewHunk
" Movement
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
nmap [s <Plug>(ale_previous_wrap)
nmap ]s <Plug>(ale_next_wrap)
nmap [S <Plug>(ale_first)
nmap ]S <Plug>(ale_last)

" Inspired by tpope/unimpared
nmap [oy :set syntax=ON<CR>
nmap ]oy :set syntax=OFF<CR>
nmap =oy :set syntax=<C-R>=&syntax == "OFF" ? "ON" : "OFF"<CR><CR>

" Insert time
inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y"],'strftime(v:val)')+[localtime()]),0)<CR>
" }}}1
" Section: Autocommands {{{1
"--------------------
if has("autocmd")
    filetype plugin indent on
    augroup Misc " {{{2
        autocmd!
        autocmd FocusLost * silent! wall
        autocmd! CursorHold     " @see help
        " Open NERDTree when vim starts without file provided
"        autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
        " Open NERDTree when vim opens directory
"        autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
        " Close vim if only NERDTree window is opened
        autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())| q | endif
    augroup END " }}}2
    augroup FileTypeCheck " {{{2
        autocmd!
        autocmd BufNewFile,BufRead *.todo,*.txt,README,INSTALL,TODO if &ft == '' | set ft=text | endif
        autocmd BufNewFile,BufRead *.phpt set ft=php
    augroup END " }}}2
    augroup FileTypeOptions " {{{2
        autocmd!
        autocmd FileType help nnoremap <silent><buffer> q :q<CR>
        autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
        autocmd FileType gitcommit setlocal spell
        autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
        autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
    augroup END " }}}2
endif
" }}}1
" Section: Themes and highlights " {{{1
"--------------------
function! s:initfont()
    if has("unix")
        set guifont=Monospace\ Medium\ 13
    elseif has("win32")
        set guifont=Consolas:h11,Courier\ New:h10
    endif
endfunction
if (&t_Co > 2 || has("gui_running")) && has("syntax")
    if !exists("syntax_on") && !exists("syntax_manual")
        syntax on
    endif
    syntax sync minlines=100
    " Colorschemes settings
    let g:loaded_togglebg = 1
    let g:solarized_termcolors=256
    let g:gruvbox_termcolors=256
    " Airline color settings
    let g:airline_theme='jellybeans'
    let g:airline_powerline_fonts=1
    " Indent Line settings
    let g:indentLine_color_term = 246
    " Switch colorscheme for specific file type
    let g:a1black_misc_colorscheme_php='hybrid'
    " Set colorscheme
    set background=dark
    if has('gui_running')
        colorscheme gruvbox
    else
        colorscheme solarized
    endif

    augroup VisualOptions
        autocmd!
        "autocmd VimEnter * if !has('gui_running') | set background=dark | colorscheme solarized | endif
        " Uncomment redraw of statusline if Airline starts without colors
        autocmd VimEnter * if exists(":AirlineRefresh") == 2 | AirlineRefresh | endif
        "autocmd GuiEnter * set background=dark | colorscheme gruvbox
        autocmd GuiEnter * call <SID>initfont()
    augroup END
endif
" }}}1

if filereadable(expand("~/.vim/vimrc.local"))
    source ~/.vim/vimrc.local
elseif filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" vi: fdm=marker ts=4 sw=4 et
