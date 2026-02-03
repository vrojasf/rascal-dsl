module Plugin

import IO;
import ParseTree;
import util::Reflective;
import util::IDEServices;
import util::LanguageServer;
import Relation;

import Syntax;
import Checker;
import Generator4;

PathConfig pcfg = getProjectPathConfig(|project://rascaldsl|);
Language tdslLang = language(pcfg, "TDSL", "tdsl", "Plugin", "contribs");

// gen4 
data Command = gen4(Tree cst);

set[LanguageService] contribs() = {
  parser(start[Planning] (str program, loc src) {
    return parse(#start[Planning], program, src);
  }),

  // 
  lenses(rel[loc src, Command lens] (start[Planning] p) {
    return {
      <p.src, gen4(p.top, title="Generate text file")>
    };
  }),
  summarizer(Summary (loc _, start[Planning] p) {
    // 
    return check(p.top);
  }),

  executor(exec)
};

value exec(gen4(Tree cst)) {
  rVal = generator4(cst);
  outputFile = |project://rascaldsl/instance/output/generator4.txt|;
  writeFile(outputFile, rVal);
  edit(outputFile);
  return ("result": true);
}

void main() {
  registerLanguage(tdslLang);
}
