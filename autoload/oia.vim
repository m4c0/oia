vim9script
import autoload "oia/chat.vim"
import autoload "oia/messages.vim" as msg

const scr_dir = expand('<sfile>:p:h')

export def Replace(prompt: string, line1: number, line2: number)
  const result = chat.Chat([
    msg.Dev(readfile($'{scr_dir}/replace.md')),
    msg.Dev(["The entire file for reference:"]),
    msg.Dev(getline(0, '$')),
    msg.User(getline(line1, line2)),
    msg.User([prompt]),
  ])
  deletebufline(bufnr('.'), line1, line2)
  appendbufline(bufnr('.'), line1 - 1, split(result, "\n"))
enddef

export def Think(prompt: string, line1: number, line2: number)
  echo chat.Chat([
    msg.Dev(readfile($'{scr_dir}/think.md')),
    msg.Dev([$"We are using {&syntax}. The entire file for reference:"]),
    msg.Dev(getline(0, '$')),
    msg.User(getline(line1, line2)),
    msg.User([prompt]),
  ])
enddef
