vim9script
import autoload "oia/call.vim" as cll
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

def ChatCallback(text: string)
  add(b:oia_chat_msgs, msg.User([text]))

  const res = cll.Call(b:oia_chat_msgs, {})
  add(b:oia_chat_msgs, res)

  append(line('$'), split(res.content, '\n'))
enddef
export def ConfigureChat()
  b:oia_chat_msgs = []

  setbufvar(bufnr(), '&buftype', 'nofile')
  setbufvar(bufnr(), '&buftype', 'prompt')
  setbufvar(bufnr(), '&filetype', 'oia')
  setbufvar(bufnr(), '&swapfile', 0)
  prompt_setprompt(bufnr(), '> ')
  prompt_setcallback(bufnr(), ChatCallback)
  startinsert
enddef
