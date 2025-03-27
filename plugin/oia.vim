vim9script
import autoload "oia.vim"
import autoload "oia/chat.vim"

augroup Oia
  au!
  au BufNew,BufNewFile oia://chat/* chat.Configure()
  au InsertLeave       oia://chat/* chat.Leave()
augroup END

command! -nargs=1 -range=% Oreplace oia.Replace(<q-args>, <line1>, <line2>)
command! -nargs=1 -range=% Othink oia.Think(<q-args>, <line1>, <line2>)
