vim9script

export class Message
  var role: string
  var content: string
endclass
export def Dev(lst: list<string>): Message
  const msg = join(lst, "\n")
  return Message.new('developer', msg)
enddef
export def User(lst: list<string>): Message
  const msg = join(lst, "\n")
  return Message.new('user', msg)
enddef

