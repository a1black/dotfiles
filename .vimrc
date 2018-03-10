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
"set clipboard=unnamed             " Yank to clipboard directly
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
set formatoptions+=j              " Delete comment character when joining commented lines
set nrformats-=octal              " Do not treat '007' as octal number on <C-A> or <C-X>

set wildmenu                      " Enhanced command line auto-complition
set wildmode=longest:full,full
set wildignore+=tags,*.pyc        " File patterns ignored on file complition
set complete-=i                   " Do not parse current and included files for <C-P>

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
set cursorline                    " Highlight current line
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

set pastetoggle=<F12>
if has("gui_running")
    set mouse=nvi
    set mousemodel=popup
endif
set winaltkeys=no

" Subsection: Plugin Settings {{{2
" CtrlP Settings {{{3
set wildignore+=*/tmp/*,*/log/*,*/.git/*,*/.svn/*,*.so,*.swp,*.tmp,*.zip,*.tar
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_by_filename = 0
let g:ctrlp_regexp = 0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_open_multiple_files = '5ijr'

" Syntastic Settings {{{3
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_html_checkers = ['tidy', 'htmlhint', 'eslint']
let g:syntastic_python_checkers = ['flake8', 'mypy', 'python']
let g:syntastic_yaml_checkers = ['yamllint']

" ALE Settings {{{3
let g:ale_open_list = 0
let g:ale_sign_column_always = 1
let g:ale_list_window_size = 8

" NERDTree Settings {{{3
let g:NERDTreeNaturalSort = 1
let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'

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

" Tagbar {{{3
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1

" GitGutter {{{3
let g:gitgutter_map_keys = 0
"let g:gitgutter_grep = 'grep --color=never'
" IndentLine {{{3
let g:indentLine_setColors = 1
let g:indentLine_char = '┆'
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_bufNameExclude = ['_.*', 'NERD_tree.*', '.*\/vim\d\+\/doc\/.*']
let g:indentLine_enabled = 1
" }}}2

" Section: Commands {{{1
command! -bar -count=0 RFC :edit http://www.ietf.org/rfc/rfc<count>.txt|setl ro noma
command! -bar -nargs=? -bang Scratch :silent e<bang> Sess-Notes|set buftype=nofile bufhidden=hide noswapfile nobuflisted filetype=<args> modifiable

command! -bar Invert :let &background = (&background=="light"?"dark":"light")
let s:my_clr=['solarized', 'gruvbox', 'zenburn', 'hybrid', 'jellybeans', 'molokai']
for s_my_clr in s:my_clr
    execute "command! -bar Clr" . s_my_clr . " :colorscheme " . s_my_clr
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
Plug 'jnurmine/Zenburn'
Plug 'morhetz/gruvbox'
Plug 'w0ng/vim-hybrid'
Plug 'tomasr/molokai'
" Visual goodies
Plug 'vim-airline/vim-airline'         " Prity statusline
Plug 'vim-airline/vim-airline-themes'  " Themes fot statusline
Plug 'mhinz/vim-startify'              " Fancy start screen
" Language packages
Plug 'plasticboy/vim-markdown'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
"Plug 'chr4/nginx.vim'
"Plug 'exu/pgsql.vim', {'for': 'sql'}
"Plug 'StanAngeloff/php.vim', {'for': 'php'}
"Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}
"Plug 'kurayama/systemd-vim-syntax', {'for': 'vim'}
"Plug 'keith/tmux.vim', {'for': 'conf'}
" Filesystem and search
Plug 'scrooloose/nerdtree'             " File system tree explorer
Plug 'Xuyuanp/nerdtree-git-plugin'     " Git status in NERDTree
"Plug 'tpope/vim-vinegar'               " NERDTree extension
"Plug 'ctrlpvim/ctrlp.vim'              " Fuzzy finder
"Plug 'junegunn/fzf', {'dir':'~/.fzf','do':'./install --all'} " Fuzzy finder
" Editing tools
Plug 'scrooloose/nerdcommenter'        " Code commenting tool
Plug 'godlygeek/tabular'               " Text aligning
"Plug 'SirVer/ultisnips'                " Code snippet engine
"Plug 'honza/vim-snippets'              " Code snippet library
"Plug 'vimwiki/vimwiki'                 " Personal Wiki for Vim :meh
"Plug 'mtth/scratch.vim'                " Note taking
"Plug 'tpope/vim-surround'              " Surrounding text with quoates and tags (HTML)
" Version control systems
Plug 'airblade/vim-gitgutter'          " Git status in sign column
"Plug 'mhinz/vim-signify'               " VCS status in sign column
Plug 'tpope/vim-fugitive'              " Git plugin fot Vim
" Test and Error
Plug 'w0rp/ale'                        " Lint engine
"Plug 'vim-syntastic/syntastic'         " Lint engine
"Plug 'tpope/vim-dispatch'              " Compiler plugin
"Plug 'janko-m/vim-test'                " Test invokation plugin
" Ctags and code completion
Plug 'majutsushi/tagbar'               " On-the-fly in-memory tags creation
"Plug 'shawncplus/phpcomplete.vim'      " Enhanced php code completion
"Plug 'Valloric/YouCompleteMe'          " Code completion tool
" Program languages
"Plug 'klen/python-mode', {'for': 'python'}            " Tool set for python development
"Plug 'davidhalter/jedi-vim', {'for': 'python'}        " Code autocompletion for python
"Plug 'mattn/emmet-vim', {'for': ['css','html','xml']} " HTML5 and XML programming enhantment
" Motion and mappings
Plug 'easymotion/vim-easymotion'       " Enhanced motion in Vim
Plug 'tpope/vim-unimpaired'            " Create mappings for square brackets
Plug 'tpope/vim-repeat'                " Enhanced repeat in Vim
Plug 'Yggdroot/indentLine'             " Highlight indent level
call plug#end()

" Section: Mappings {{{1
" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Clear the highlighting search results
nnoremap <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>
nnoremap Y y$
        " Exit insert and return cursor to last position
inoremap <C-C> <Esc>`^
        " Break undo sequence
inoremap <C-U> <C-G>u<C-U>
inoremap <M-o> <C-O>o
inoremap <M-O> <C-O>O
inoremap <M-I> <C-O>^
inoremap <M-A> <C-O>$
xnoremap <M-A> $h
" Window split resize
nnoremap <silent> <C-w><C-h> :vertical resize -5<CR>
nnoremap <silent> <C-w><C-j> :resize +5<CR>
nnoremap <silent> <C-w><C-k> :resize -5<CR>
nnoremap <silent> <C-w><C-l> :vertical resize +5<CR>
" Copy/paste to system clipboard
nnoremap <leader>y "+y
nnoremap <leader>p "+p
xnoremap <leader>y "+y
xnoremap <leader>Y "+Y
xnoremap <leader>p "+p
" Save/close shortcats
nnoremap <leader>s :update<CR>
nnoremap <leader>S :wall<CR>
nnoremap <leader>wq :exit<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>qa :qall!<CR>
nnoremap <leader>x :close<CR>

map      <silent> <F1> <Esc>g<C-G>
map!     <silent> <F1> <Esc>g<C-G>
nnoremap <silent> <F1> :SSave!<CR>
nnoremap <silent> <F2> :SLoad!<CR>
nnoremap <silent> <F3> :if &previewwindow<Bar>pclose<Bar>elseif exists(':Gstatus')<Bar>exe 'Gstatus'<Bar>else<Bar>ls<Bar>endif<CR>
nnoremap <silent> <F4> :if &previewwindow<Bar>pclose<Bar>elseif exists(':Gblame')<Bar>exe 'Gblame'<Bar>else<Bar>ls<Bar>endif<CR>
nnoremap <silent> <F5> :NERDTreeToggle<CR>
nnoremap <silent> <F6> :TagbarToggle<CR>
nnoremap <silent> <F7> :Ltoggle<CR>
nnoremap <silent> <F8> :Ctoggle<CR>
nmap     <silent> <F9> <Plug>(ale_toggle_buffer)
"Open app menu    <F10>
"Fullscreen mod   <F11>
"Toggle paste mod <F12>

" GitGutter
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterUndoHunk
nmap <Leader>hp <Plug>GitGutterPreviewHunk
" Movement
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
nmap [e <Plug>(ale_previous_wrap)
nmap ]e <Plug>(ale_next_wrap)
nmap [E <Plug>(ale_first)
nmap ]E <Plug>(ale_last)

" Insert time
inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y"],'strftime(v:val)')+[localtime()]),0)<CR>

" Section: Autocommands {{{1
"--------------------
if has("autocmd")
    filetype plugin indent on
    augroup Misc " {{{2
        autocmd!
        autocmd FocusLost * silent! wall
        autocmd! CursorHold     " @see help
        " Open NERDTree when vim starts without file provided
"        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
        " Open NERDTree when vim opens directory
"        autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
        " Close vim if only NERDTree window is opened
        autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())| q | endif
    augroup END " }}}2
    augroup FileTypeCheck " {{{2
        autocmd!
        autocmd BufNewFile,BufRead *.todo,*.txt,README,INSTALL,TODO if &ft == '' | set ft=text | endif
    augroup END
    augroup FileTypeOptions " {{{2
        autocmd!
        autocmd FileType help nnoremap <silent><buffer> q :q<CR>
        autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
        autocmd FileType gitcommit setlocal spell
        autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
        autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
    augroup END " }}}2
endif

" Section: Themes and highlights " {{{1
function! s:initfont()
    if has("unix")
        set guifont=Monospace\ Medium\ 13
    elseif has("win32")
        set guifont=Consolas:h11,Courier\ New:h10
    endif
endfunction
if (&t_Co > 2 || has("gui_running")) && has("syntax")
    if exists("syntax_on") || exists("syntax_manual")
    else
        syntax on
    endif
    " Colorschemes settings
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
    let g:molokai_original=1
    " Airline color settings
    let g:airline_theme='jellybeans'
    let g:airline_powerline_fonts=1
    " Indent Line settings
    let g:indentLine_color_term = 246

    augroup VisualOptions
        autocmd!
        autocmd VimEnter * if !has("gui_running") && exists(":Clrsolarized") == 2 | Clrsolarized | endif
        autocmd VimEnter * if !has("gui_running") | set background=light | endif
"        " Uncomment redraw of statusline if Airline starts without colors
        autocmd VimEnter * if exists(":AirlineRefresh") == 2 | AirlineRefresh
"        | endif
        autocmd GuiEnter * set background=light title icon guioptions-=T guioptions-=m guioptions-=e guioptions-=r guioptions-=L
        autocmd GuiEnter * if exists(":Clrgruvbox") == 2 | Clrgruvbox | endif
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
