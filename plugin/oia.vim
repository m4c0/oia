vim9script
import autoload "oia.vim"

command! -nargs=1 -range=% Oia oia.Work(<q-args>, <line1>, <line2>)
command! -nargs=1 -range=% Othink oia.Think(<q-args>, <line1>, <line2>)
