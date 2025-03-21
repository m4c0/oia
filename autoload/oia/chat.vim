vim9script
import "./call.vim"

class ChatMessage
  this.role: string
  this.content: string
endclass
export def Dev(msg: string): ChatMessage
  return ChatMessage.new('developer', msg)
enddef
export def User(msg: string): ChatMessage
  return ChatMessage.new('user', msg)
enddef

export def Chat(msgs: list<ChatMessage>): string
  var args: list<dict<string>>
  for msg in msgs
    add(args, {
      role: msg.role,
      content: msg.content,
    })
  endfor
  return call.Call(args, []).content
enddef
