vim9script

export def Dev(lst: list<string>): dict<string>
  const msg = join(lst, "\n")
  return { role: 'developer', content: msg }
enddef
export def User(lst: list<string>): dict<string>
  const msg = join(lst, "\n")
  return { role: 'user', content: msg }
enddef

