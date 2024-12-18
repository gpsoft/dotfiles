" Encoding and format
" {{{
set encoding=utf-8
scriptencoding utf-8
set modeline
let g:vim_indent_cont=8
set fileencodings=utf-8,cp932,sjis,utf-16le,euc-jp
set fileformats=unix,dos,mac
" }}}

" Local constants
" {{{
if filereadable(expand("~/.vimrc.constants.local"))
    source ~/.vimrc.constants.local
endif
" }}}

" Manage plugins with minpac and plugpac
" Run :PackInstall from time to time
" {{{
syntax enable
filetype plugin indent on
call plugpac#Begin()
Pack 'k-takata/minpac', {'type': 'opt'}

" Themes
Pack 'jonathanfilip/vim-lucius'
Pack 'altercation/vim-colors-solarized'

" General purpose
Pack 'vim-scripts/mru.vim'
Pack 'tpope/vim-vinegar'
Pack 'jlanzarotta/bufexplorer'
Pack 'kien/ctrlp.vim'
Pack 'itchyny/lightline.vim'
Pack 'easymotion/vim-easymotion'
Pack 'christoomey/vim-tmux-navigator'
Pack 'tpope/vim-surround'
Pack 'tpope/vim-repeat'
" Pack 'tpope/vim-fugitive', {'on': ['Git', 'Gdiff', 'Gclog']}
Pack 'tpope/vim-fugitive'
Pack 'tpope/vim-dispatch'
Pack 'osyo-manga/vim-over'
Pack 'tpope/vim-abolish'

" Programming
if has('win32unix')
    " disable ultisnips on git bash
    " because it fails to load python dll(problem with handling dos style path?)
    let did_plugin_ultisnips=1
    autocmd BufReadPost,FileType * {
        b:did_autoload_ultisnips = 1
        b:did_autoload_ultisnips_map_keys = 1
    }
endif
Pack 'SirVer/ultisnips'
Pack 'tpope/vim-commentary'
Pack 'machakann/vim-swap'
Pack 'luochen1990/rainbow'
Pack 'keith/investigate.vim'

" LSP
" Pack 'prabirshrestha/async.vim'
" Pack 'prabirshrestha/asyncomplete.vim'
" Pack 'prabirshrestha/asyncomplete-lsp.vim'
" Pack 'prabirshrestha/vim-lsp'
" Pack 'mattn/vim-lsp-settings'

" Clojure
" Pack 'guns/vim-clojure-static', {'for': 'clojure'}
Pack 'tpope/vim-fireplace', {'for': 'clojure'}
Pack 'guns/vim-sexp', {'for': 'clojure'}
Pack 'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}

" Specific file type
Pack 'majutsushi/tagbar', {'for': ['php', 'javascript']}
Pack 'tpope/vim-projectionist'
Pack 'rhysd/devdocs.vim', {'for': ['php', 'javascript']}
Pack 'ap/vim-css-color',  {'for': 'css'}
Pack 'kannokanno/previm'
Pack 'tyru/open-browser.vim',  {'for': ['markdown', 'html']}
Pack 'vim-scripts/SQLUtilities', {'for': 'sql'}
Pack 'vim-scripts/Align', {'for': 'sql'}
Pack 'vim-scripts/dbext.vim'


if filereadable(expand("~/.vimrc.plugins.local"))
    source ~/.vimrc.plugins.local
endif

call plugpac#End()
" }}}

" Basic settings
" {{{
set t_Co=256
set background=dark

" Themes
augroup vimrc_color
    autocmd!
    autocmd ColorScheme lucius {
        highlight! LineNr ctermfg=247 ctermbg=238
        highlight! CursorLineNr ctermfg=172 ctermbg=240
        highlight! ColorColumn ctermbg=5
        highlight! Normal ctermbg=235
    }
augroup END
colorscheme lucius
" colorscheme slate

call matchadd('ColorColumn', '\%92v', 1000)
call matchadd('ColorColumn', '\%93v', 1000)

set notitle
set ruler
set laststatus=2
set showmode
set showcmd
set textwidth=0
set number
set splitright
set splitbelow
set relativenumber
"    Relativenumber can make scroll slow in terminal.

set ambiwidth=double
"    should be 'double' to show fullwidth chars(such as ■)
"    correctly.
" set list lcs=tab:»\ ,eol:¬,trail:©
set list lcs=tab:»\ ,eol:¬,trail:∙
"    need to update lcs depending on the terminal font
"    so that they don't include any fullwidth-caracter.

set autoindent
set smartindent
set smarttab
set backspace=indent,eol,start
set complete=.,w,b,u,t
set completeopt=menuone
set formatoptions+=j
set noautoread
set pastetoggle=<F2>
set showtabline=2

set timeout timeoutlen=600 ttimeoutlen=100
"    longer ttimeoutlen makes slow to move from insert mode to normal mode.
set wildmenu
set scrolloff=1
set sidescrolloff=3

set suffixesadd=.clj,.cljs,.rb  " for gf
set nrformats=unsigned          " format for <C-A> or <C-X>
set hidden

set ignorecase
set smartcase
set infercase
set incsearch
set hlsearch
set wrapscan
set history=200
set wildignore+=**/obj/**,**/debug/**,**/bin/**,**/lib/**
set foldlevelstart=99

set noundofile
set backup
set noswapfile
if has('win32unix')
    if isdirectory('/c/tmp/apptmp')
        set backupdir=/c/tmp/apptmp/bak
    elseif isdirectory('/d/tmp/apptmp')
        set backupdir=/d/tmp/apptmp/bak
    else
        set nobackup
        set noswapfile
    endif
elseif has('mac') || has('unix')
    set backupdir=/var/tmp/bak
    set backupskip=/tmp/*,/private/tmp/*
    if !isdirectory(&backupdir)
        call mkdir(&backupdir, 'p')
    endif
else
    if isdirectory('c:\tmp\apptmp\bak')
        set backupdir=c:\tmp\apptmp\bak
    elseif isdirectory('d:\tmp\apptmp\bak')
        set backupdir=d:\tmp\apptmp\bak
    else
        set nobackup
        set noswapfile
    endif
endif

"Block cursor in terminal.
if ( has('win32unix') )
    "let &t_ti.="\e[1 q"
    "let &t_te.="\e[0 q"
    let &t_SI.="\e[5 q"
    let &t_EI.="\e[1 q"
    " set t_ve+=[?81;0;112c
endif

" }}}

" IME
" {{{

" function! TurnOffIme()
"   call system('fcitx-remote -c')
" endfunction
set noimdisable
set iminsert=0
set imsearch=-1
" inoremap <silent> <C-[> <ESC>:set iminsert=0<CR>:call TurnOffIme()<CR>

set noimcmdline
inoremap <silent> <C-[> <ESC>:set iminsert=0<CR>
if has('unix') && !has('win32unix') && !has('mac')
    function! ImeOff()
        exec system("fcitx-remote -c")
    endfunction
    autocmd! InsertLeave * call ImeOff()
endif

" }}}

" Tab
" {{{
" set sw=0 sts=0 ts=4 noet
augroup vimrc_tab
    autocmd!
    autocmd FileType * setlocal sw=0 sts=0 ts=4 noet
    autocmd FileType css setlocal sw=4 noet " need sw(bug?)
    autocmd FileType clojure setlocal sw=2 ts=2 et " need sw(bug?)
    autocmd FileType markdown setlocal ts=2 et
    autocmd FileType ruby setlocal ts=2 et
    autocmd FileType sql setlocal ts=2 et
    autocmd FileType mru setlocal ts=32 et
augroup END
" }}}

" Cursorline
" {{{
augroup vimrc_cursorline
    autocmd!
    autocmd InsertLeave,WinEnter * set cursorline
    autocmd InsertEnter,WinLeave * set nocursorline
augroup END
" }}}

" Grep
" {{{
if executable('rg')
    set grepprg=rg\ -i\ --vimgrep\ --no-heading\ --ignore-file\ ~/.gitignore_global
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" }}}

" FileType
" {{{
augroup vimrc_ft
    autocmd!
    autocmd BufNewFile,BufRead *.log set filetype=messages
    if has('mac')
        " MacVimでは、mdを開いた後でsplitするとfiletypeがmodula2に戻ってしまう。
        " しかたないのでvim本体を修正した。
        " /Applications/MacVim.app/Contents/Resources/vim/runtime/filetype.vim
    else
        " autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    endif

    autocmd FileType messages setlocal autoread
    autocmd FileType vim setlocal keywordprg=:help
    autocmd FileType gitcommit setlocal spell
augroup END

    "autocmd bufwritepost .vimrc source $MYVIMRC
    autocmd bufwritepost *.md call previm#refresh()

    autocmd BufRead vim setlocal foldlevel=0
    autocmd FileType text setlocal textwidth=0
    autocmd FileType vim setlocal textwidth=0
    "    Global setting doesn't work for some filetypes
" }}}

" FileType(js)
" {{{
augroup vimrc_js
    autocmd!
    autocmd FileType javascript {
        noremap <script> <buffer> <silent> ]]
                \ :call <SID>NextPhpSection(1, 0, 0)<cr>
        noremap <script> <buffer> <silent> [[
                \ :call <SID>NextPhpSection(1, 1, 0)<cr>
        noremap <script> <buffer> <silent> ][
                \ :call <SID>NextPhpSection(2, 0, 0)<cr>
        noremap <script> <buffer> <silent> []
                \ :call <SID>NextPhpSection(2, 1, 0)<cr>
        vnoremap <script> <buffer> <silent> ]]
                \ :<c-u>call <SID>NextPhpSection(1, 0, 1)<cr>
        vnoremap <script> <buffer> <silent> [[
                \ :<c-u>call <SID>NextPhpSection(1, 1, 1)<cr>
        vnoremap <script> <buffer> <silent> ][
                \ :<c-u>call <SID>NextPhpSection(2, 0, 1)<cr>
        vnoremap <script> <buffer> <silent> []
                \ :<c-u>call <SID>NextPhpSection(2, 1, 1)<cr>
    }
augroup END
" }}}

" FileType(php)
" {{{
augroup vimrc_php
    autocmd!
    autocmd BufNewFile,BufRead *.ctp set filetype=php
    autocmd FileType php {
        setlocal foldmethod=indent | normal zR
        setlocal indentkeys=0{,0},0),:,!^F,o,O,e,*<Return>,=?>,=>,=*/
        setlocal autoindent
        setlocal smartindent
        noremap <script> <buffer> <silent> ]]
                \ :call <SID>NextPhpSection(1, 0, 0)<cr>
        noremap <script> <buffer> <silent> [[
                \ :call <SID>NextPhpSection(1, 1, 0)<cr>
        noremap <script> <buffer> <silent> ][
                \ :call <SID>NextPhpSection(2, 0, 0)<cr>
        noremap <script> <buffer> <silent> []
                \ :call <SID>NextPhpSection(2, 1, 0)<cr>
        vnoremap <script> <buffer> <silent> ]]
                \ :<c-u>call <SID>NextPhpSection(1, 0, 1)<cr>
        vnoremap <script> <buffer> <silent> [[
                \ :<c-u>call <SID>NextPhpSection(1, 1, 1)<cr>
        vnoremap <script> <buffer> <silent> ][
                \ :<c-u>call <SID>NextPhpSection(2, 0, 1)<cr>
        vnoremap <script> <buffer> <silent> []
                \ :<c-u>call <SID>NextPhpSection(2, 1, 1)<cr>
    }
augroup END

let php_htmlInStrings=0
let php_sql_query=0
let php_baselib=1
let php_parent_error_close=0
" let php_folding=1   " it may slow vim down

function! s:NextPhpSection(type, backwards, visual)
    if a:visual
        normal! gv
    endif

    let pattern = '\v^\s*(public|private|protected){0,1}\s*function\s+'
    " Note that using {0,1} instead of ? for backward search

    if a:type == 1
        call search(pattern, a:backwards ? 'bW' : 'W')
        return
    endif

    let c = line('.')                 " current
    let pos = getpos('.')
    let ct = search(pattern, 'bWc')   " closest top
    if ct <= 0
        return
    endif
    call search('{')
    execute 'silent normal! %\r'
    let cb = line('.')                " closest bottom

    if a:backwards && c > cb
        return
    endif
    if !a:backwards && c < cb
        return
    endif

    if a:backwards
        call search(pattern, 'bW')
    endif
    if search(pattern, a:backwards ? 'bW' : 'W') <= 0
        call setpos('.', pos)
        return
    endif
    call search('{')
    execute 'silent normal! %\r'
endfunction

" function! s:PhpIndent() range
"     let t = &filetype
"     let &filetype='php'
"     execute a:firstline . ',' .a:lastline . 'normal! =='
"     let &filetype = t
" endfunction
" command! -range PhpIndent <line1>,<line2>call s:PhpIndent()
" xnoremap g= :PhpIndent<CR>
" }}}

" FileType(css)
" {{{
augroup vimrc_css
    autocmd FileType css setlocal iskeyword+=-
augroup END
" }}}

" FileType(markdown)
" {{{
let g:markdown_fenced_languages = ['clojure', 'bash=sh']
let g:markdown_minlines = 150
" }}}

" FileType(Clojure)
" {{{
augroup vimrc_clj
    autocmd!
    " autocmd BufNewFile,BufRead *.cljs set filetype=clojure
    autocmd BufNewFile,BufRead *.boot set filetype=clojure

    autocmd FileType clojure setlocal lispwords+=defproject,provided,tabular,domonad,with-monad,defmonad,deftask,go-loop
    " autocmd FileType clojure setlocal iskeyword-=/
    " autocmd FileType clojure setlocal iskeyword-=.
    " autocmd FileType clojure setlocal complete+=k~/dotfiles/dic/clojure.txt

    autocmd FileType clojure nnoremap <buffer> cpP :Eval<CR>
    autocmd FileType clojure nnoremap <buffer> <silent> cp@ ya):silent !Eval (#?(:clj clojure.pprint/pprint :cljs cljs.pprint/pprint) 0)<CR>:redraw!<CR>:Last<CR>:setlocal modifiable<CR>:%s/\r//ge<CR>:%yank<CR>:q!<CR>%p
    autocmd FileType clojure nnoremap <buffer> <silent> cpR :Eval (if-let [r (resolve 'user/reset)] (do (with-out-str (r)) 'reset!) (symbol "No reset func; use cpe"))<CR>
    autocmd FileType clojure nnoremap <buffer> <silent> cpe :Require!<CR>
    autocmd FileType clojure nnoremap <buffer> <C-]> :split<CR>:normal ]<C-D><CR>
    autocmd FileType clojure nnoremap <buffer> g<C-]> :normal ]<C-D><CR>

    autocmd FileType clojure command! -buffer Publics Eval (clojure.pprint/pprint (sort (keys (ns-publics *ns*))))

    autocmd FileType clojure call EnableClojureFolding()
    function! GetClojureFold()
        if getline(v:lnum) =~ '^('
            return ">1"
        else
            return "="
        endif
    endfunction

    function! EnableClojureFolding()
        setlocal foldexpr=GetClojureFold()
        setlocal foldmethod=expr
        setlocal nofoldenable
    endfunction
augroup END

"let g:clojure_fold = 1
" let g:clojure_highlight_references = 1
" let g:clojure_align_multiline_strings = 0
let g:clojure_align_subforms = 1
" }}}

" Plugins
" :PlugInstall
" {{{
" NETRW
" let g:netrw_keepdir=0
let g:netrw_keepj="keepj"
" let g:netrw_liststyle=3
" let g:netrw_silent=1
autocmd FileType netrw setl bufhidden=delete

" LSP
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')

" MATCHIT
runtime macros/matchit.vim

" VIM-CLOJURE-STATIC
" let g:clojure_fuzzy_indent = 1
" let g:clojure_fuzzy_indent_patterns = [
"         \ '^\(future-\)\?facts\?$',
"         \ '^prerequisites\?$'
"         \ ]
" let g:clojure_maxlines = 300

" MRU
let MRU_Max_Entries = 100
let MRU_Exclude_Files = '^crontab\.\|MERGE_MSG\|COMMIT_EDITMSG\|^c:\\tmp\\.*\|^c:\\temp\\.*'
let MRU_Filename_Format = {
        \ 'formatter': 'fnamemodify(v:val,":t")."\t- ".v:val',
        \ 'parser': '\t- \zs.*\ze$',
        \ 'syntax': '\v^.*\t- '
        \ }

" UltiSnips
if has('win32unix')
    let g:UltiSnipsExpandTrigger="<M-C-tab>"
else
    let g:UltiSnipsSnippetsDir=expand("$HOME/dotfiles/vimfiles/UltiSnips")
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-j>"
    let g:UltiSnipsJumpBackwardTrigger="<c-k>"
    let g:UltiSnipsEditSplit="vertical"
endif

" Tagbar
let g:tagbar_width=50
let g:tagbar_type_php={
        \ 'kinds': [
        \ 'n:namespaces',
        \ 'c:classes',
        \ 't:traits',
        \ 'i:interfaces',
        \ 'd:constant definitions:0:0',
        \ 'f:functions']}
let g:tagbar_type_javascript={
        \ 'kinds': [
        \ 'f:functions:1']}

" BufExplorer
let g:bufExplorerShowDirectories=0
let g:bufExplorerShowNoName=0
let g:bufExplorerShowUnlisted=0
let g:bufExplorerSortBy='fullpath'

" Open-Browser & previm
" let g:netrw_browsex_viewer="firefox-bin"
if exists('g:vimrc_local_browser')
    let g:previm_open_cmd=g:vimrc_local_browser
endif
let g:netrw_nogx = 1
let g:openbrowser_message_verbosity = 1
let g:previm_show_header = 0

" SQLUtilities
let g:sqlutil_load_default_maps = 0
let g:sqlutil_align_where = 0
let g:sqlutil_align_comma = 1

" Easymotion
let g:EasyMotion_do_mapping=0
let g:EasyMotion_keys = 'ASDFGHJKL;ERUIOVNMBW'
let g:EasyMotion_use_upper = 1
let g:EasyMotion_smartcase = 1
let g:EasyMotion_verbose = 0
"let g:EasyMotion_use_migemo = 1  " Moved to .vimrc.local

" DevDocs
augroup devdocs-vim
  autocmd!
  autocmd FileType php nmap <buffer>K <Plug>(devdocs-under-cursor)
  autocmd FileType javascript nmap <buffer>K <Plug>(devdocs-under-cursor)
  autocmd FileType css nmap <buffer>K <Plug>(devdocs-under-cursor)
augroup END

" }}}

" Plugins(Lightline)
" {{{
let g:lightline = {
        \ 'colorscheme': 'jellybeans',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component': {
        \   'readonly': '%{&readonly?"\u2b64":""}',
        \ },
        \ 'component_function': {
        \   'fugitive': 'MyFugitive',
        \ },
        \ 'component_visible_condition': {
        \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
        \ },
        \ 'mode_map': {
        \   'n' : 'N',
        \   'i' : 'I',
        \   'R' : 'R',
        \   'v' : 'V',
        \   'V' : 'VL',
        \   'c' : 'C',
        \   "\<C-v>": 'VB'},
        \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
        \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
        \ }
function! MyFugitive()
    if exists("*FugitiveHead")
        let _ = FugitiveHead()
        return strlen(_) ? "\u2b60"._ : ''
    endif
    return ''
endfunction
function! AlterWombat()
    "Inactive status line is too dark, let's lighten it up a bit.
    hi! LightLineLeft_inactive_0
            \ ctermbg=243 ctermfg=234 guibg=#808080 guifg=#000000
    hi! LightLineLeft_inactive_0_1
            \ ctermbg=238 ctermfg=243 guibg=#444444 guifg=#808080
    hi! LightLineMiddle_inactive
            \ ctermbg=238 guibg=#444444
    hi! LightLineRight_inactive_1_2
            \ ctermbg=238 ctermfg=238 guibg=#444444 guifg=#444444
endfunction
augroup vimrc_ll
    autocmd!
    autocmd VimEnter * call AlterWombat()
    autocmd WinEnter * call AlterWombat()
augroup END
call AlterWombat()
" }}}

" Plugins(Ctrlp)
" {{{
let g:ctrlp_map = '<Nop>'
" let g:ctrlp_max_files  = 5000
" let g:ctrlp_max_depth = 6
" let g:ctrlp_clear_cache_on_exit = 0
" let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:8,results:30'
let g:ctrlp_working_path_mode = 'wra'
let g:ctrlp_by_filename = 0
let g:ctrlp_prompt_mappings = {
        \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>', '<c-q>'],
        \ }
let g:ctrlp_custom_ignore = '\v(out|target|bin|vendor)/*'
if executable('rg')
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
endif
" }}}

" Plugins(Rainbow)
" {{{
"RAINBOW
let g:rainbow_conf = {
        \	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
        \	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
        \	'guis': [''],
        \	'cterms': [''],
        \	'operators': '',
        \	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
        \	'separately': {
        \		'*': {},
        \		'clojure': {
        \			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3']
        \		},
        \		'css': 0,
        \	}
        \}
let g:rainbow_active = 1
" }}}
"
" Plugins(Vim-sexp)
" {{{
let g:sexp_mappings = {
        \ 'sexp_round_head_wrap_list':      '<Leader><Leader>(',
        \ 'sexp_round_tail_wrap_list':      '<Leader><Leader>)',
        \ 'sexp_square_head_wrap_list':     '<Leader><Leader>[',
        \ 'sexp_square_tail_wrap_list':     '<Leader><Leader>]',
        \ 'sexp_curly_head_wrap_list':      '<Leader><Leader>{',
        \ 'sexp_curly_tail_wrap_list':      '<Leader><Leader>}',
        \ 'sexp_round_head_wrap_element':   '<Leader><Leader>e(',
        \ 'sexp_round_tail_wrap_element':   '<Leader><Leader>e)',
        \ 'sexp_square_head_wrap_element':  '<Leader><Leader>e[',
        \ 'sexp_square_tail_wrap_element':  '<Leader><Leader>e]',
        \ 'sexp_curly_head_wrap_element':   '<Leader><Leader>e{',
        \ 'sexp_curly_tail_wrap_element':   '<Leader><Leader>e}',
        \ 'sexp_insert_at_list_head':       '<Leader><Leader>h',
        \ 'sexp_insert_at_list_tail':       '<Leader><Leader>l',
        \ 'sexp_splice_list':               '<Leader><Leader>@',
        \ 'sexp_raise_list':                '<Leader><Leader>o',
        \ 'sexp_raise_element':             '<Leader><Leader>O',
        \ }

"let g:sexp_enable_insert_mode_mappings = 0
" }}}

" Plugins(Dbext)
" {{{
let g:dbext_map_prefix = '<Leader>q'
let g:dbext_default_profile_hoge='type=MYSQL:host=192.168.1.100:user=mysql:passwd=mysql:dbname=hoge'
let g:dbext_default_profile_fuga='type=MYSQL:host=192.168.1.100:user=mysql:passwd=mysql:dbname=fuga'
let g:dbext_default_MYSQL_extra = '--default-character-set=utf8'
if !exists("g:dbext_default_profile")
    let g:dbext_default_profile = 'hoge'
endif
let g:dbext_default_buffer_lines = 20
let g:dbext_default_always_prompt_for_variables=0
function! DBextPostResult(db_type, buf_nr)
    setlocal ts=16
endfunction
" }}}

" Plugins(tmux-navigator)
" {{{
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-w>h :TmuxNavigateLeft<cr>
nnoremap <silent> <C-w>j :TmuxNavigateDown<cr>
nnoremap <silent> <C-w>k :TmuxNavigateUp<cr>
nnoremap <silent> <C-w>l :TmuxNavigateRight<cr>
nnoremap <silent> <C-w>p :TmuxNavigatePrevious<cr>
" }}}

" Plugins(investigate)
" {{{
let g:investigate_url_for_php="http://php.net/search.php?show=quickref&pattern=^s"
" }}}

" Keymap for grep guard
augroup grepGuard
    function! GrepGuard() abort
        nmap <buffer> <Leader>gg :echoe 'Do NOT vimgrep on quickfix or netrw!'<CR>
        nmap <buffer> <Leader>gG :echoe 'Do NOT vimgrep on quickfix or netrw!'<CR>
    endfunction
    au!
    au FileType qf call GrepGuard()
    au FileType netrw call GrepGuard()
augroup END

" Custom commands
" {{{

" :Repl
" Clojure REPL.
if has('mac')
    function! Repl(dir)
        let script = "!osascript"
                \ . " -e 'tell application \"iTerm\"'"
                \ . " -e '  make new terminal'"
                \ . " -e '  tell the current terminal'"
                \ . " -e '    activate current session'"
                \ . " -e '    launch session \"Default session\"'"
                \ . " -e '    tell the last session'"
                \ . " -e '      write text \"cd " . a:dir . "; lein repl\"'"
                \ . " -e '    end tell'"
                \ . " -e '    end tell'"
                \ . " -e 'end tell'"
        execute script
    endfunction
    command! Repl silent! call Repl(expand("%:p:h"))
elseif has('unix') && !has('win32unix')
else
    command! Repl !start cmd.exe /c cd /d "%:h"&& lein.bat repl
endif


" :PigBoot, :PigFig, :PigNode
" ClojureScript Browser REPL
let g:fireplace_cljs_repl =
      \ '(cider.piggieback/cljs-repl (figwheel.main.api/repl-env "dev"))'
command! PigBoot execute('Piggieback (adzerk.boot-cljs-repl/repl-env)')
command! PigFigSidecar execute('Piggieback (figwheel-sidecar.repl-api/repl-env)')
command! PigFigMain execute('Piggieback (figwheel.main.api/repl-env "dev")')
command! PigFig execute('Piggieback (figwheel.main.api/repl-env "dev")')
command! PigNode execute('Piggieback (cljs.repl.node/repl-env)')

" :Dos
" Command prompt for Windows.
if ( has('win32') || has('win64') )
    command! Dos !start cmd.exe /k cd /d "%:h"
endif

" :Marks
" List marks and jump to one.
function! s:Marks()
    marks
    echo 'Jump to mark: '
    let marks = nr2char(getchar())
    redraw
    execute 'normal! `' . marks
endfunction
command! Marks call s:Marks()

" s:VSetSearch()
" Search selected text
function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

" :ToggleSyntax
" Toggle syntax on/off.
function! s:ToggleSyntax()
    if exists("g:syntax_on")
        syntax off
    else
        syntax enable
    endif
endfunction
command! ToggleSyntax call s:ToggleSyntax()

function! ToggleFold()
    if &foldlevel > 0
        setlocal foldenable
        setlocal foldlevel=0
    else
        setlocal foldlevel=99
    endif
endfunction

" :Qargs
" Set arglist to files in quickfix list.
" Thanks to Drew Neil
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
    let buffer_numbers = {}
    for quickfix_item in getqflist()
        let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
    endfor
    return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

" :Blog
if exists('g:vimrc_local_path_notes')
    function! s:openBlogDir()
        execute 'Sexp '.g:vimrc_local_path_notes.'/gpblog/content/md/posts'
    endfunction
    command! Blog call <SID>openBlogDir()
endif

" :Sql
" Open Dbext
fu! OpenTabForSql(...)
    if a:0 >= 1
        silent execute('DBSetOption profile='.a:1)
        let g:dbext_default_profile = a:1
    endif
    let f = '\Users\gpsoft\sql\scratchpad.sql'
    if exists('g:vimrc_local_sql_scratchpad')
        let f = g:vimrc_local_sql_scratchpad
    endif
    let bn = bufwinnr(f)
    if bn > 0
        :exe bn.'wincmd w'
    else
        silent execute('tabe '.f.' | normal gg,qlt')
    endif
endfunc
command! -nargs=? Sql call OpenTabForSql(<f-args>)

" TortoiseSVN
fu! TortoiseCommand(com, others)
    let filename = expand("%:p")
    if filename==''
        if &ft=='netrw'
            " let filename = eval('g:netrw_dirhist_'.g:netrw_dirhist_cnt)
            let filename = eval('g:netrw_dirhist_'.g:netrw_dirhistcnt)
        else 
            let filename = getcwd()
        endif
    endif
    let svn = 'start C:\Progra~1\TortoiseSVN\bin\TortoiseProc.exe'
    silent execute('!'.svn.' /command:'.a:com.' /path:"'.filename.'" /notempfile '.a:others)
endfunc
fu! TortoiseBlame()
    let filename = expand("%:p")
    let linenum = line(".")
    let others = '/line:'.linenum.' /closeonend'
    call TortoiseCommand('blame', others)
endfunc

":PasteReplace()
"Replace selected text with unnamed register
"without breaking unnamed register.
function! PasteReplace()
    normal! gv"_d
    if col('.') >= col('$') - 1
        normal! p
    else
        normal! P
    endif
endfunction

":OpenBrowserCurrent
command! OpenBrowserCurrent execute "OpenBrowser" "file:///" . expand('%:p:gs?\\?/?')

":DiffThem()
"diff with clipboard
function! DiffThem()
    rightbelow vsplit __DiffThem__
    setlocal buftype=nofile
    normal! ggdG
    normal! "+P
    diffoff!
    windo diffthis
endfunction
" }}}

" Experimental
" {{{

" if you feel vim is too slow...
set lazyredraw
" set regexpengine=1

" html
" let g:html_indent_script1="inc"
" let g:html_indent_style1="inc"
" let g:html_indent_inctags="html,body,head"

" haskell
"let g:haskell_conceal = 0

" folding markdown
function! MarkdownLevel()
    let h = matchstr(getline(v:lnum), '\v^#{1,3}[^#]')
    if empty(h)
        return "="
    else
        " return ">" . len(h)
        return ">1"
    endif
endfunction
autocmd FileType markdown setlocal foldmethod=expr foldexpr=MarkdownLevel() foldlevel=99
" }}}

" Key mappings
" {{{

let mapleader = ","
noremap \ ,

" File system
nnoremap <C-Q> :q<CR>
nnoremap <C-T> :w<CR>
nnoremap <Leader>E :Ex<CR>
nnoremap <Leader>S :Hex<CR>
nnoremap <Leader>V :Vex!<CR>
nnoremap <Leader>ve :split $HOME/dotfiles/vimrc<CR>
nnoremap <silent> <Leader>vs :so $MYVIMRC<CR>
nnoremap <Leader>m :MRU<CR>
nnoremap <silent> <Leader>l :BufExplorerHorizontalSplit<CR>
nnoremap <Leader>o :CtrlPMixed<CR>
nnoremap <Leader>cs :split ~/dotfiles/cheat<CR>
nnoremap <Leader>cv :split ~/dotfiles/cheat/vim.md<CR>
nnoremap <Leader>cg :split ~/dotfiles/cheat/git.md<CR>
nnoremap <Leader>ct :split ~/dotfiles/cheat/tmux.md<CR>
if exists('g:vimrc_local_path_notes')
    execute 'nnoremap <Leader>n :Ex' g:vimrc_local_path_notes.'<CR>'
endif
nnoremap <Leader>a :A<CR>
nnoremap <Leader>aa :A<CR>
nnoremap <Leader>av :AV<CR>
nnoremap <Leader>as :AS<CR>
nnoremap <Leader>at :AT<CR>
nnoremap <C-G> 1<C-G>

" Moving around
nmap <C-F> <Leader><Leader>f
nmap <C-F><C-F> <Leader><Leader>n
nmap <Leader><Leader>f <Plug>(easymotion-overwin-f)
nmap <Leader><Leader>w <Plug>(easymotion-bd-W)
nmap <Leader><Leader>n :let @/='\<\v[0-9a-zA-Z]' \| :call EasyMotion#Search(0,2,0) \| :let @/=''<CR>
nnoremap <Leader>t :TagbarOpenAutoClose<CR>
nnoremap <Leader>T :echo tagbar#currenttag('[%s]', 'not in a function?')<CR>
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j
xnoremap k gk
xnoremap j gj
xnoremap gk k
xnoremap gj j
nnoremap <C-]> :split<CR>:exe "tjump ".expand('<cword>')<CR>
nnoremap g<C-]> <C-]>

" Searching
nmap <Leader>gg :vim //j %%**<CR>:copen<CR><C-w>J:setlocal nowrap<CR>
nmap <Leader>gG :vim //j %%../**<CR>:copen<CR><C-w>J:setlocal nowrap<CR>
nmap <Leader>GG :let @/=expand("<cword>")<CR>:let @g="grep! ".@/." ."<CR>:exe("grep! ".@/." .")<CR>:copen<CR><C-w>J:setlocal nowrap<CR>
nnoremap <silent> * :let @/="\\<".expand("<cword>")."\\>" \| :call histadd('search', @/) \| set hlsearch<CR>
nnoremap <silent> g* :let @/=expand("<cword>") \| :call histadd('search', @/) \| set hlsearch<CR>
nnoremap <silent> <C-l> :<C-u>nohlsearch \|redraw!<CR>

" Git(fugitive)
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gd :Gdiff<CR>
" nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gb :Git blame -w -M<CR>
nnoremap <Leader>gl :exe ':Git! ll --follow -- '.expand('%')<CR><C-w>k
" nnoremap <Leader>gL :Gclog! --all<CR>:copen<CR><C-w>J
nnoremap <Leader>gL :Git -p lg --all<CR>
nnoremap <Leader>gR :Gread<CR>
nnoremap <Leader>gW :Gwrite<CR>
" nnoremap <Leader>gp :Git push<CR>

" Indentation
nnoremap <Leader>F migg=G`izz
nnoremap <Leader>f mi=i}`izz

" Copy&Pasting
nnoremap gyy "+yy
nnoremap gY "+yy
vnoremap gy "+y
nnoremap gp "+gp
nnoremap gP "+gP
nnoremap <F2> :set invpaste<CR>
inoremap <C-G><C-V> <F2><C-R>+<F2>

" Folding
nnoremap <Space> zA
" nnoremap g<Space> zi
nnoremap <silent> g<Space> :<C-U>call ToggleFold()<CR>

" Arrange windows
nnoremap <silent> <C-P> :res +2<CR>
nnoremap <silent> <C-N> :res -2<CR>

" Open-Browser & previm
nnoremap <Leader>p :PrevimOpen<CR>
nnoremap <Leader>bf :OpenBrowserCurrent<CR>
" nmap gx <Plug>(openbrowser-smart-search)

" Spell check
"nnoremap <silent> <Leader>s :setlocal spell! spelllang=en_us,cjk<CR>:ToggleSyntax<CR>
" nnoremap <silent> <Leader>s :let @z=expand('<cword>')<CR> :tabnew<CR>:setlocal spell! spelllang=en_us,cjk <CR>:put z<CR>
nnoremap <silent> <Leader>s :let @z=expand('<cword>')<CR> :tabnew<CR>:setlocal spell! spelllang=en_us,cjk <CR>I[z=] <C-R>z<Esc>

" Insert mode
inoremap <C-w> <Nop>
inoremap <C-u> <Nop>
inoremap <C-t> <Esc>:w<CR>

" Command Window
cnoremap <expr> %% getcmdtype()==':' ? expand('%:h').'/' : '%%'
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Visual mode
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
xnoremap <Leader>p :<C-u>call PasteReplace()<CR>

" Tortoise svn
nnoremap <Leader>td : call TortoiseCommand('diff', '')<CR>
nnoremap <Leader>tl : call TortoiseCommand('log', '')<CR>
nnoremap <Leader>tc : call TortoiseCommand('commit', '')<CR>
nnoremap <Leader>tb : call TortoiseBlame()<CR>

" Investigate
nnoremap gK :call investigate#Investigate('n')<CR>
vnoremap gK :call investigate#Investigate('v')<CR>

" Misc
nnoremap <silent> <Leader>q :copen 10<CR><C-w>J
nnoremap <Leader>r :OverCommandLine<CR>%s/
nnoremap <Leader>` :Marks<CR>
nnoremap <Leader>w :setlocal wrap!<CR>
nnoremap <Leader>% :let @+=expand('%:p')\| :echo "Current file path copied to clipboard."<CR>
nnoremap <Leader>d :call DiffThem()<CR>

" }}}

" Local config
" {{{
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
" }}}

" vim:fdm=marker:fmr={{{,}}}:sw=4:sts=4:ts=4:et:
