vim9script
import autoload "oia/chat.vim"

const scr_dir = expand('<sfile>:p:h')

export def Replace(prompt: string, line1: number, line2: number)
  const result = chat.Chat([
    chat.Dev(readfile($'{scr_dir}/replace.md')),
    chat.Dev(["The entire file for reference:"]),
    chat.Dev(getline(0, '$')),
    chat.User(getline(line1, line2)),
    chat.User([prompt]),
  ])
  deletebufline(bufnr('.'), line1, line2)
  appendbufline(bufnr('.'), line1 - 1, split(result, "\n"))
enddef

export def Think(prompt: string, line1: number, line2: number)
  echo chat.Chat([
    chat.Dev(readfile($'{scr_dir}/think.md')),
    chat.Dev([$"We are using {&syntax}. The entire file for reference:"]),
    chat.Dev(getline(0, '$')),
    chat.User(getline(line1, line2)),
    chat.User([prompt]),
  ])
enddef
