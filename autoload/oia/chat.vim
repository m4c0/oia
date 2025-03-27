vim9script
import "./call.vim" as cll
import "./messages.vim" as msg

const scr_dir = expand('<sfile>:p:h')

def Callback(text: string)
  add(b:oia_chat_msgs, msg.User([text]))

  const res = cll.Call(b:oia_chat_msgs, {})
  add(b:oia_chat_msgs, res)

  append(line('$'), split(res.content, '\n'))
enddef
export def Configure()
  b:oia_chat_msgs = [msg.Dev(readfile($'{scr_dir}/chat.md'))]

  setbufvar(bufnr(), '&buftype', 'nofile')
  setbufvar(bufnr(), '&buftype', 'prompt')
  setbufvar(bufnr(), '&filetype', 'oia')
  setbufvar(bufnr(), '&swapfile', 0)
  prompt_setprompt(bufnr(), '> ')
  prompt_setcallback(bufnr(), Callback)
  startinsert
enddef
export def Leave()
  setlocal nomodified
enddef
