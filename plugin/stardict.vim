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
  let g:stardict_keep_focus=1
endif

" Devuelve la lista de booknames
function! BooknameList()
  if exists('g:stardict_booknames')
    return g:stardict_booknames 
  endif
  let s:result =  system('sdcv -l')
  let s:booknames = split(s:result) 
  call remove(s:booknames, 0 , 3) 
  let s:len = len(s:booknames)
  let s:count = 1
  while s:count <= s:len/2
    call remove(s:booknames, s:count) 
    let s:count += 1
  endwhile
  let g:stardict_booknames = s:booknames
  return g:stardict_booknames
endfunction

" Buscar la ultima ventana stardict
function! s:FindLastWindow()
  if exists('g:stardict_window')
    return bufwinnr(g:stardict_window)
  endif
  return -1
endfunction

" Imprimir resultado de busqueda
function! s:Lookup(word)
  let winnr = s:FindLastWindow()
	let cur_winnr = winnr()
  if winnr >= 0
    execute winnr . 'wincmd w'
  else
    silent keepalt belowright split thesaurus
    let g:stardict_window = bufnr('%')
  endif
  setlocal noswapfile nobuflisted nospell wrap modifiable
  setlocal buftype=nofile bufhidden=hide
  1,$d
  let s:dict_path=''
  let s:bookname=''
  if exists("g:stardict_dictionary_path")
    let s:dict_path='--data-dir=' . g:stardict_dictionary_path . ' '
  endif
  if exists("g:stardict_current_bookname")
    let s:bookname='--use-dict=' . g:stardict_current_bookname . ' '
  endif
  let expl=system('sdcv -n ' . s:dict_path . s:bookname . a:word)
  " normal! ggdG
  put =expl
  " exec "silent 0r !" . s:path . "/thesaurus-lookup " . a:word
  normal! Vgqgg
  exec 'resize ' . (line('$')+1)
  setlocal nomodifiable filetype=thesaurus
  nnoremap <silent> <buffer> q :q<CR>
  " Volver a la ventana actual.
  if g:stardict_keep_focus > 0
    execute cur_winnr . 'wincmd w'
  endif
endfunction

if !exists('g:stardict_map_keys')
  let g:stardict_map_keys=1
endif

if g:stardict_map_keys
  nnoremap <unique> <LocalLeader>K :StardictCurrentWord<CR>
endif

command! StardictCurrentWord :call <SID>Lookup(expand('<cword>'))
command! -nargs=1 Stardict :call <SID>Lookup(<f-args>)

let &cpo = s:save_cpo


