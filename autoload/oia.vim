vim9script
import autoload "oia/chat.vim"

const scr_dir = expand('<sfile>:p:h')

export def Replace(prompt: string, line1: number, line2: number)
  const code = join(getline(0, '$'), "\n")
  const snip = join(getline(line1, line2), "\n")
  const result = chat.Chat([
    chat.Dev(join(readfile($'{scr_dir}/replace.md'), "\n")),
    chat.Dev("The entire file for reference:"),
    chat.Dev(code),
    chat.User(snip),
    chat.User(prompt),
  ])
  deletebufline(bufnr('.'), line1, line2)
  appendbufline(bufnr('.'), line1 - 1, split(result, "\n"))
enddef

export def Think(prompt: string, line1: number, line2: number)
  const code = join(getline(0, '$'), "\n")
  const snip = join(getline(line1, line2), "\n")
  echo chat.Chat([
    chat.Dev(join(readfile($'{scr_dir}/think.md'), "\n")),
    chat.Dev($"We are using {&syntax}. The entire file for reference:"),
    chat.Dev(code),
    chat.User(snip),
    chat.User(prompt),
  ])
enddef
