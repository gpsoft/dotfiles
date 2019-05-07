let g:gp_tmux_repl_pane = '{left}'
let g:gp_repl_ns = 'lumo.repl'

function! s:EvalOnTmuxRepl(expr) abort
    let cmdline = 'tmux send-keys -t '.g:gp_tmux_repl_pane
            \ .' "'.escape(a:expr, '\"$').'"'
            \ .' Enter'
    call system(cmdline)
endfunction

function! s:CurNsOnTmuxRepl() abort
    " REPLペインの最後の1行が
    " hoge.core=>
    " のようなプロンプトになっていると想定する。
    let cmdline = 'tmux capture-pane -t '.g:gp_tmux_repl_pane
            \ .' -p'
            \ .' |tail -n 1'
            \ .' |cut -d = -f 1'
    let cur_ns = trim(system(cmdline))
    return cur_ns
endfunction

function! s:EvalExpr(expr, ns) abort
    let expr = a:expr
    let cur_ns = s:CurNsOnTmuxRepl()
    if cur_ns != a:ns
        let expr = "(in-ns '".a:ns.") ".expr
    endif
    call s:EvalOnTmuxRepl(expr)
endfunction

function! s:NsOfBuffer() abort
  let head = getbufline('%', 1, 10)
  let blank = '^\s*\%(;.*\)\=$'
  call filter(head, 'v:val !~# blank')
  let keyword_group = '[A-Za-z0-9_?*!+/=<>.-]'
  let lines = join(head[0:49], ' ')
  let lines = substitute(lines, '"\%(\\.\|[^"]\)*"\|\\.', '', 'g')
  let lines = substitute(lines, '\^\={[^{}]*}', '', '')
  let lines = substitute(lines, '\^:'.keyword_group.'\+', '', 'g')
  let ns = matchstr(lines, '\C^(\s*\%(in-ns\s*''\|ns\s\+\)\zs'.keyword_group.'\+\ze')
  return ns
endfunction

function! s:CurExpr(type) abort
    let skip = 'synIDattr(synID(line("."),col("."),1),"name") =~? "comment\\|string\\|char\\|regexp"'
  let sel_save = &selection
  let cb_save = &clipboard
  let reg_save = @@
  try
    set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
    if a:type ==# 'inner'
      let open = '[[{(]'
      let close = '[]})]'
      if getline('.')[col('.')-1] =~# close
        let [line1, col1] = searchpairpos(open, '', close, 'bn', skip)
        let [line2, col2] = [line('.'), col('.')]
      else
        let [line1, col1] = searchpairpos(open, '', close, 'bcn', skip)
        let [line2, col2] = searchpairpos(open, '', close, 'n', skip)
      endif
      while col1 > 1 && getline(line1)[col1-2] =~# '[#''`~@]'
        let col1 -= 1
      endwhile
      call setpos("'[", [0, line1, col1, 0])
      call setpos("']", [0, line2, col2, 0])
      silent exe "normal! `[v`]y"
    elseif a:type ==# 'outer'
      call searchpair('(','',')', 'Wbcr', skip)
      silent exe "normal! vaby"
    else
      silent exe "normal! `[v`]y"
    endif
    redraw
    return @@
  finally
    let @@ = reg_save
    let &selection = sel_save
    let &clipboard = cb_save
  endtry
endfunction

function! s:TmEval(type)
    let expr = s:CurExpr(a:type)
    let this_ns = s:NsOfBuffer()
    call s:EvalExpr(expr, this_ns)
endfunction

function! s:TmDoc()
    let sym = expand('<cword>')
    let expr = '('.g:gp_repl_ns.'/doc '.sym.')'
    let this_ns = s:NsOfBuffer()
    call s:EvalExpr(expr, this_ns)
endfunction

command! TmEvalInner silent! call <SID>TmEval('inner')
command! TmEvalOuter silent! call <SID>TmEval('outer')
command! TmDoc silent! call <SID>TmDoc()

augroup cljs_tmux_repl
    autocmd!
    autocmd BufNewFile,BufReadPost *.cljs nnoremap <leader>cpp :TmEvalInner<CR>
    autocmd BufNewFile,BufReadPost *.cljs nnoremap <leader>cpP :TmEvalOuter<CR>
    autocmd BufNewFile,BufReadPost *.cljs nnoremap <leader>K :TmDoc<CR>
augroup END

