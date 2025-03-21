vim9script
import autoload "oia/chat.vim"

const instructions = chat.Dev('
      \ You are a simple agent embedded as a code editor plugin.
      \ Your sole responsibility is to take a block of text and a prompt from the user and work on that
      \ based exclusively on what the prompt asks.
      \ Return should contain only the code and should not contain any formatting.
      \ ')

export def Work(prompt: string, line1: number, line2: number)
  const code = join(getline(line1, line2), "\n")
  const result = chat.Chat([ instructions, chat.User(code), chat.User(prompt) ])
  deletebufline(bufnr('.'), line1, line2)
  appendbufline(bufnr('.'), line1 - 1, split(result, "\n"))
enddef
