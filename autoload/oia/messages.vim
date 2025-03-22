vim9script

export class Message
  this.role: string
  this.content: string
endclass
export def Dev(lst: list<string>): Message
  const msg = join(lst, "\n")
  return Message.new('developer', msg)
enddef
export def User(lst: list<string>): Message
  const msg = join(lst, "\n")
  return Message.new('user', msg)
enddef

export def Convert(msgs: list<Message>): list<dict<string>>
  var args: list<dict<string>>
  for msg in msgs
    add(args, {
      role: msg.role,
      content: msg.content,
    })
  endfor
  return args
enddef

