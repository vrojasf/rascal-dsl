module Generator3

import IO;
import Set;
import List;
import AST;
import Syntax;
import String;

import Parser;
import Implode;

str generator3(cast) {
    ast = implode(cast);
    rVal =
        "Info of the planning DepartmentABC
        'All Persons:
        '       <for (person <- {name | /personTasks(name, _) := ast }) {><person>
        '       <}>
        'All actions of tasks:
        '======
        '        <printTaskWithDuration(ast)>
        '=====
        'Other way of listing all tasks:
        '        <printTaskWithoutDuration(ast)>
        '";
    return rVal;
}

str printTaskWithDuration(ast) {
    rVal = [];

    // Capturamos action y duration (y descartamos prio con _), como hace la guía
    for (<a, d> <- [ <action, duration> | /task(action, _, duration) := ast ]) {
        rVal += "<printAction(a)> <printDuration(d)>";
    }

    return intercalate(" &\n", rVal);
}

str printTaskWithoutDuration(ast) {
    rVal = [];

    // Sacamos solo action (y descartamos prio y duration con _)
    for (a <- { action | /task(action, _, _) := ast }) {
        rVal += "<printAction(a)>";
    }

    return intercalate(" ,\n", rVal);
}

str printAction(action) {
    if (/lunchAction(location)  := action) return "Lunch at location <location>";
    if (/meetingAction(topic)   := action) return "Meeting with topic <replaceAll(topic, "\"", "")>";
    if (/paperAction(report)    := action) return "Paper for journal <report>";
    if (/paymentAction(amount)  := action) return "Pay <amount> Euro";
    return "Unknown action!";
}

str printDuration(list[Duration] durations) {
    // duration es opcional en la gramática → aquí llega como lista vacía o lista con 1 elemento
    if (durations == []) return "";

    // tomamos el primero (solo hay 1 en este tutorial)
    dur = durations[0];

    u = "";
    visit (dur.unit) {
        case minute(): u = "m";
        case hour():   u = "h";
        case day():    u = "d";
        case week():   u = "w";
    }

    return "with duration: <dur.dl> <u>";
}
