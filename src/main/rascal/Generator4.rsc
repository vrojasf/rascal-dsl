module Generator4

import IO;
import Set;
import List;
import Syntax;
import String;

str generator4(cst) {
  rVal =
    "Info of the planning DepartmentABC
    'All Persons:
    '       <for (person <- { name | /(PersonTasks) `Person <ID name> <Task+ tasks>` := cst }) {><person>
    '       <}>
    'All actions of tasks:
    '======
    '        <printTaskWithDuration(cst)>
    '=====
    'Other way of listing all tasks:
    '        <printTaskWithoutDuration(cst)>
    '";
  return rVal;
}

str printTaskWithDuration(cst) {
  rVal = [];
  visit (cst) {
    case (Task) `Task <Action action> priority: <INT prio> <Duration? duration>`:
      rVal += "        <printAction(action)> <prio> <printDuration(duration)>";
  }
  return intercalate(" &\n", rVal);
}

str printTaskWithoutDuration(cst) {
  rVal = [];
  for (a <- { action | /(Task) `Task <Action action> priority: <INT prio> <Duration? duration>` := cst }) {
    rVal += "<printAction(a)>";
  }
  return intercalate(" ,\n", rVal);
}

str printAction(action) {
  if (/(LunchAction)   `Lunch <ID location>`      := action) return "Lunch at location <location>";
  if (/(MeetingAction) `Meeting <STRING topic>`   := action) return "Meeting with topic <replaceAll("<topic>", "\"", "")>";
  if (/(PaperAction)   `Report <ID report>`       := action) return "Paper for journal <report>";
  if (/(PaymentAction) `Pay <INT amount> euro`    := action) return "Pay <amount> Euro";
  return "Unknown action!";
}

str printDuration(duration) {
  
  rVal = "";
  if (/(Duration) `duration: <INT dl> <TimeUnit unit>` := duration) {
    u = "";
    if (/(Minute) `min`  := unit) u = "m";
    if (/(Hour)   `hour` := unit) u = "h";
    if (/(Day)    `day`  := unit) u = "d";
    if (/(Week)   `week` := unit) u = "w";
    return "with duration: <dl> <u>";
  }
  return rVal;
}
