% Copyright

implement main

clauses
    run() :-
        %Token = gdiplus::startUp(),
        TaskWindow = taskWindow::new(),
        TaskWindow:show(),
        gdiplus::shutDown(1).

end implement main

goal
    mainExe::run(main::run).
