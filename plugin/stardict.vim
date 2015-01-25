" stardict.vim - Acceso rapido a los diccionarios de stardict
" Version: 0.1
" Maintainer: E. Manuel Cerrón Angeles <xerron.angels@gmail.com>
" Date: 2015-01-14
" Licence: MIT

if exists("g:loaded_stardict")
  finish
endif

let g:loaded_stardict=1

let s:save_cpo = &cpo
set cpo&vim

let s:path = expand("<sfile>:p:h")

if !exists("g:stardict_keep_focus")
  s:stardict_keep_focus=1
else 
  s:stardict_keep_focus=g:stardict_keep_focus
endif

function! s:FindLastWindow()
  if exists('g:stardict_window')
    return bufwinnr(g:stardict_window)
  endif
  return -1
endfunction

function! s:Lookup(word)
  let winnr = s:FindLastWindow()
  if winnr >= 0
    execute winnr . 'wincmd w'
  else
    silent keepalt belowright split thesaurus
    let g:stardict_window = bufnr('%')
  endif
  setlocal noswapfile nobuflisted nospell nowrap modifiable
  setlocal buftype=nofile bufhidden=hide
  1,$d
  let expl=system('sdcv -n ' . a:word)
  normal! ggdG
  put =expl
  " exec "silent 0r !" . s:path . "/thesaurus-lookup " . a:word
  normal! Vgqgg
  exec 'resize ' . (line('$')-1)
  setlocal nomodifiable filetype=thesaurus
  nnoremap <silent> <buffer> q :q<CR>
  " Volver a la ventana actual.
  if s:stardict_keep_focus == 1
    execute winnr . 'wincmd w'
  endif
endfunction

function! StardictBalloonContent()
  let expl=system('sdcv -n ' .
        \ v:beval_text .
        \ '|fmt -cstw 40')
  return expl
endfunction

" set bexpr=StardictBalloon()
" set beval

function! StardictBufferContent()
  let expl=system('sdcv -n ' . expand("<cword>"))
  return expl
endfunction

if !exists('g:stardict_map_keys')
  let g:stardict_map_keys=1
endif

if g:stardict_map_keys
  nnoremap <unique> <LocalLeader>K :StardictCurrentWord<CR>
  " nmap F :call StardictOpen()<CR>
endif

command! StardictCurrentWord :call <SID>Lookup(expand('<cword>'))
command! Stardict :call <SID>Lookup(expand('<cword>'))
command! -nargs=1 Thesaurus :call <SID>Lookup(<f-args>)

" perro 
"
let &cpo = s:save_cpo


