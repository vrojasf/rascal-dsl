module Checker

import Syntax;
import String;
import Message;
import util::LanguageServer;
import ParseTree;

Summary check(Planning p ) {
    overLimit = {<"<a>", pay.src> | /pay:(PaymentAction) `Pay <INT a> euro` := p, toInt("<a>") > 10000};
    tasks = {<"<prio>", prio.src> | /(Task) `Task <Action action> priority : <INT prio> <Duration? duration>` := p};
    tasksWithSamePrio = {<n1, p1> | <n1, p1> <- tasks, <n2, p2> <- tasks, n1 == n2, p1 != p2};
    durations = {<"<dl>", dur.src> | /dur:(Duration) `duration : <INT dl> <TimeUnit unit>` := p, "<unit>" == "min", toInt("<dl>") % 60 == 0};

    return summary(p.src,
        messages = {<l, warning("There is a budget limit of 10000. So <e> is too big. ", l)> 
                   | e <- overLimit<0>, l <-overLimit[e]} +
                   {<l, error("Priorities need to be unique: <e> is used somewhere else. ", l)> 
                   | e <- tasksWithSamePrio<0>, l <-tasksWithSamePrio[e]} +
                   {<l, warning("Rewrite duration in <toInt(e)/60> hours. ", l)> 
                   | e <- durations<0>, l <-durations[e]}
    );
}
