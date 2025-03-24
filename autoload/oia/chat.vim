vim9script
import "./call.vim"

export def Chat(msgs: list<any>): string
  return call.Call(msgs, {}).content
enddef
