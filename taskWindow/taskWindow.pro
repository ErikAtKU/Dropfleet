% Copyright

implement taskWindow inherits applicationWindow
    open core, vpiDomains

constants
    mdiProperty : boolean = true.

clauses
    new() :-
        applicationWindow::new(),
        generatedInitialize().

predicates
    onShow : window::showListener.
clauses
    onShow(_, _CreationData) :-
        _MessageForm = messageForm::display(This).

class predicates
    onDestroy : window::destroyListener.
clauses
    onDestroy(_).

class predicates
    onHelpAbout : window::menuItemListener.
clauses
    onHelpAbout(TaskWin, _MenuTag).

predicates
    onFileExit : window::menuItemListener.
clauses
    onFileExit(_, _MenuTag) :-
        close().

predicates
    onSizeChanged : window::sizeListener.
clauses
    onSizeChanged(_) :-
        vpiToolbar::resize(getVPIWindow()).

predicates
    onFileNew : window::menuItemListener.
clauses
    onFileNew(_Source, _MenuTag) :-
        displayImage::displayImage(This, ucmToulon::getFleetBuilderStats()).

predicates
    onFileOpen : window::menuItemListener.
clauses
    onFileOpen(_Source, _MenuTag).

predicates
    onEditUndo : window::menuItemListener.
clauses
    onEditUndo(_Source, _MenuTag) :-
        _ = generateCostListDlg::display(This, generateCostListDlg::scourge, []).

predicates
    onEditRedo : window::menuItemListener.
clauses
    onEditRedo(_Source, _MenuTag) :-
        _ = generateCostListDlg::display(This, generateCostListDlg::shaltari, fleet::myShaltariShips).

predicates
    onEditCut : window::menuItemListener.
clauses
    onEditCut(_Source, _MenuTag) :-
        _ = generateCostListDlg::display(This, generateCostListDlg::ucm, fleet::myUCMShips).

predicates
    onEditCopy : window::menuItemListener.
clauses
    onEditCopy(_Source, _MenuTag) :-
        _ = generateCostListDlg::display(This, generateCostListDlg::phr, []).

predicates
    onEditPaste : window::menuItemListener.
clauses
    onEditPaste(_Source, _MenuTag).
% This code is maintained automatically, do not update it manually.%  13:49:15-5.3.2022

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("Dropfleet Tools"),
        setDecoration(titlebar([closeButton, maximizeButton, minimizeButton])),
        setBorder(sizeBorder()),
        setState([wsf_ClipSiblings]),
        whenCreated({  :- projectToolbar::create(getVpiWindow()) }),
        addSizeListener({  :- vpiToolbar::resize(getVpiWindow()) }),
        setMdiProperty(mdiProperty),
        menuSet(resMenu(resourceIdentifiers::mnu_TaskMenu)),
        addShowListener(onShow),
        addSizeListener(onSizeChanged),
        addDestroyListener(onDestroy),
        addMenuItemListener(resourceIdentifiers::id_help_about, onHelpAbout),
        addMenuItemListener(resourceIdentifiers::id_file_exit, onFileExit),
        addMenuItemListener(resourceIdentifiers::id_file_new, onFileNew),
        addMenuItemListener(resourceIdentifiers::id_file_open, onFileOpen),
        addMenuItemListener(resourceIdentifiers::id_edit_undo, onEditUndo),
        addMenuItemListener(resourceIdentifiers::id_edit_redo, onEditRedo),
        addMenuItemListener(resourceIdentifiers::id_edit_cut, onEditCut),
        addMenuItemListener(resourceIdentifiers::id_edit_copy, onEditCopy),
        addMenuItemListener(resourceIdentifiers::id_edit_paste, onEditPaste).
% end of automatic code

end implement taskWindow
