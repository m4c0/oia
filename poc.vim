vim9script
import autoload "oia/agent.vim"
import autoload "oia/call.vim" as cll
import autoload "oia/messages.vim"
import autoload "oia/functions.vim" as fns

def ViewFile(argz: dict<string>): any
  const path = argz.path
  echo $"viewing {path}"
  return readfile(path)
enddef

def ListFiles(argz: dict<string>): any
  echom $"list files"
  return glob($"**")
enddef

def SearchTerms(argz: dict<string>): any
  const query = argz.query
  echom $"search terms: {query}"
  return cll.Call([
    messages.User([$"Extract relevant search terms from the following query:"]),
    messages.User([query]),
    messages.Dev(["Return them as a list of terms, without any formatting."]),
  ], {}).content
enddef

def AgentExample()
  echo agent.Agent([
    messages.Dev(["You are an automated assistant robot. You don't need to explain to go into details of your reasoning. You are running on a file directory containing files with arbitrary names."]),
    messages.User(["Reconstruct the OpenAPI call which will be made as a result of calling the AgentExample function of this proof-of-concept"])
  ], {
    list_files: fns.Fn(ListFiles, "List all files in the working environment directory.", {}),
    search_terms: fns.Fn(SearchTerms, "Extract relevant search terms for a given query", {
      query: fns.Arg("string", "Query to extract terms from"),
    }),
    view_file: fns.Fn(ViewFile, "Extract the contents of a file. The tool only works with normal files. Result is empty if file does not exist.", {
      path: fns.Arg("string", "File to view. Value must be relative to current folder."),
    }),
  })
enddef

AgentExample()
