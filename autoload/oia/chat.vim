vim9script
import "./call.vim"
import "./messages.vim" as msg

export def Chat(msgs: list<msg.Message>): string
  return call.Call(msg.Convert(msgs), []).content
enddef
