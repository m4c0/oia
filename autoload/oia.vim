vim9script
import autoload "oia/chat.vim"

export def Replace(prompt: string, line1: number, line2: number)
  const instructions = chat.Dev($'
        \ You are a simple agent embedded as a code editor plugin.
        \ Your sole responsibility is to take a block of text and a prompt from the user and work on that
        \ based exclusively on what the prompt asks.
        \ The input is part of a bigger code, so the result must be indented in a way it feels natural when replacing the original code.
        \ Assume the programming language is always the latest version (example: C++23, Java 21, etc).
        \ Return should contain only the code and should not contain any formatting.
        \ The code editor will remove the input and replace it with your output - therefore the final result must be valid {&syntax}.
        \ Do not include surrounding code in the response.
        \ ')

  const code = join(getline(0, '$'), "\n")
  const snip = join(getline(line1, line2), "\n")
  const result = chat.Chat([
    instructions,
    chat.Dev("The entire file for reference:"),
    chat.Dev(code),
    chat.User(snip),
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
