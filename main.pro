% Copyright

implement main

clauses
    run() :-
        Token = gdiplus::startUp(),
        TaskWindow = taskWindow::new(),
        TaskWindow:show(),
        gdiplus::shutDown(Token).

end implement main

goal
    mainExe::run(main::run).
