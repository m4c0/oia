vim9script
import autoload "oia/chat.vim"

export def Replace(prompt: string, line1: number, line2: number)
  const instructions = chat.Dev('
        \ You are a simple agent embedded as a code editor plugin.
        \ Your sole responsibility is to take a block of text and a prompt from the user and work on that
        \ based exclusively on what the prompt asks.
        \ The input is part of a bigger code, so the result must be indented in a way it feels natural when replacing the original code.
        \ Assume the programming language is always the latest version (example: C++23, Java 21, etc).
        \ Return should contain only the code and should not contain any formatting.
        \ ')

  const code = join(getline(line1, line2), "\n")
  const result = chat.Chat([
    instructions,
    chat.Dev($"We are using {&syntax}. Results must be valid for that language."),
    chat.User(code),
    chat.User(prompt),
  ])
  deletebufline(bufnr('.'), line1, line2)
  appendbufline(bufnr('.'), line1 - 1, split(result, "\n"))
enddef

export def Think(prompt: string, line1: number, line2: number)
  const instructions = chat.Dev('
        \ You are a simple agent embedded as a code editor plugin.
        \ Your sole responsibility is to take a block of text and a prompt from the user and reason
        \ on the user request.
        \ If discussing code, assume the programming language is always the latest version (example: C++23, Java 21, etc).
        \ Be concise and avoid going beyond the request.
        \ ')

  const code = join(getline(line1, line2), "\n")
  echo chat.Chat([
    instructions,
    chat.Dev($"We are using {&syntax}."),
    chat.User(code),
    chat.User(prompt),
  ])
enddef
