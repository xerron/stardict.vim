# stardict.vim

Rapido acceso a diccionarios Stardict 2.4.2. (sdcv)

![stardict](https://cloud.githubusercontent.com/assets/1724033/5996081/a10308d0-aa6f-11e4-985b-9312f2c8cab6.gif)

## Dependencias

- sdcv 
- [Diccionarios stardict](http://abloz.com/huzheng/stardict-dic/)

Windows [sdcv](http://osspack32.googlecode.com/files/sdcv.exe)

## Uso

Abre una ventana con el significado de la palabra.

    Keymap: <LeaderLocal>K

Buscar el significado de una palabra.

    :Stardict <word>

Escoger el diccionario predeterminado.

    :StardictBooknameChoose

## Configuración

Default path:
    
    windows
    let g:stardict_dictionary_path=$STARDICT_DATA_DIR
    Unix
    let g:stardict_dictionary_path='/usr/share/stardict/dic/'

Custom keymap:
    
    let g:stardict_map_keys=0
    nnoremap <LocalLeader>d :StardictCurrentWord<CR>




