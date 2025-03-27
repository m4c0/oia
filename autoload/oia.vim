vim9script
import autoload "oia/call.vim" as cll
import autoload "oia/chat.vim"
import autoload "oia/messages.vim" as msg

const scr_dir = expand('<sfile>:p:h')

def QuoteSnippet(preamble: string, line1: any, line2: any): list<string>
  var lines = [
    preamble,
    $'```{&syntax}',
  ]
  extend(lines, getline(line1, line2))
  add(lines, '```')
  return lines
enddef

export def Replace(prompt: string, line1: number, line2: number)
  const result = cll.Call([
    msg.Dev(readfile($'{scr_dir}/replace.md')),
    msg.Dev(QuoteSnippet("The entire file for reference:", 0, '$')),
    msg.User(QuoteSnippet(prompt, line1, line2)),
  ], {}).content
  deletebufline(bufnr(), line1, line2)
  appendbufline(bufnr(), line1 - 1, split(result, "\n"))
enddef

export def Think(prompt: string, line1: number, line2: number)
  echo cll.Call([
    msg.Dev(readfile($'{scr_dir}/think.md')),
    msg.Dev(QuoteSnippet("The entire file for reference:", 0, '$')),
    msg.User(QuoteSnippet(prompt, line1, line2)),
  ], {}).content
enddef
