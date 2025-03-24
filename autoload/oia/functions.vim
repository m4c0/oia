vim9script

export def Fn(Callback: func, desc: string, args: dict<any>): dict<any>
  return { callback: Callback, description: desc, parameters: args }
enddef
export def Arg(type: string, desc: string): dict<string>
  return { type: type, description: desc }
enddef


