import
  httpclient, re, os, terminal,
  strformat, sequtils

const moby = "https://moby-thesaurus.org/"

func toString*(s: seq[string]): string =
  result = s.len.newStringOfCap
  for s1 in s:
    result.add(s1)

proc findSynonyms*(s: string): seq[string] =
  var
    syns: seq[string]
    f: int
    l: int
  while true:
    f = find(s, re"(?<=>)([A-Za-z])\w+(?=<)", f+l)
    l = matchLen(s, re"(?<=>)([A-Za-z])\w+(?=<)", f)
    if f == -1: break
    syns.add(s[f..<f+l])
  return syns

# TODO: Add separation between synonyms and related words in the resulting string
when isMainModule:
  if paramCount() < 1:
    echo "Usage: syn <term(s)>"
    quit(1)
  var
    c = newHttpClient()
    cols = 0
    output: string
  let
    termw = terminalWidth()
    argString = commandLineParams().toString
    resp = c.getContent(moby & argString)
    syns = resp.findSynonyms.deduplicate
  if commandLineParams()[0] == "-g":
    var s: string
    for syn in syns:
      s &= &"{syn} "
    echo s
  for i, syn in syns:
    if termw < cols + syn.len+2:
      cols = 0
      output &= "\n"
    else:
      cols += syn.len+2
      if i == syns.len-1: output &= syn
      else: output &= &"{syn}, "
  echo output
