vim9script

export class Argument
  var type: string
  var description: string
endclass
export class Function
  var Callback: func
  var description: string
  var parameters: dict<Argument>
endclass

export def Fn(Callback: func, desc: string, args: dict<Argument>): Function
  return Function.new(Callback, desc, args)
enddef
export def Arg(type: string, desc: string): Argument
  return Argument.new(type, desc)
enddef


