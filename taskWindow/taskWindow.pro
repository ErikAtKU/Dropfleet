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
    onHelpAbout(TaskWin, _MenuTag) :-
        fleetBuilder::buildFleet_nd(500,
            [
                tuple(1, 1, shaltariEmerald::getFleetBuilderStats()),
                tuple(0, 0, shaltariAmber::getFleetBuilderStats()),
                tuple(0, 0, shaltariGranite::getFleetBuilderStats()),
                tuple(0, 0, shaltariObsidian::getFleetBuilderStats()),
                tuple(0, 0, shaltariJet::getFleetBuilderStats()),
                tuple(0, 2, shaltariAquamarine::getFleetBuilderStats()),
                tuple(0, 0, shaltariTurquoise::getFleetBuilderStats()),
                tuple(0, 0, shaltariBasalt::getFleetBuilderStats()),
                tuple(0, 0, shaltariOnyx::getFleetBuilderStats()),
                tuple(0, 0, shaltariAzurite::getFleetBuilderStats()),
                tuple(3, 3, shaltariVoidgate::getFleetBuilderStats()),
                tuple(0, 4, shaltariTopaz::getFleetBuilderStats()),
                tuple(0, 4, shaltariJade::getFleetBuilderStats()),
                tuple(0, 4, shaltariAmethyst::getFleetBuilderStats()),
                tuple(0, 1, shaltariOpal::getFleetBuilderStats())
            ]),
        !.
    onHelpAbout(TaskWin, _MenuTag) :-
        fleetBuilder::buildFleet_nd(500,
            [
                tuple(0, 2, ucmNewOrleans::getFleetBuilderStats()),
                tuple(0, 6, ucmLysander::getFleetBuilderStats()),
                tuple(0, 1, ucmMadrid::getFleetBuilderStats()),
                tuple(0, 0, ucmOsaka::getFleetBuilderStats()),
                tuple(0, 1, ucmLima::getFleetBuilderStats()),
                tuple(0, 1, ucmSanFransisco::getFleetBuilderStats()),
                tuple(0, 2, ucmSeattle::getFleetBuilderStats()),
                tuple(0, 1, ucmStPetersburg::getFleetBuilderStats()),
                tuple(0, 0, ucmWashington::getFleetBuilderStats()),
                tuple(0, 0, ucmTaipei::getFleetBuilderStats()),
                tuple(0, 0, ucmKyiv::getFleetBuilderStats())
            ]),
        !.
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
        displayImage::displayImage(This, ucmToulon::getImageFile()).
% This code is maintained automatically, do not update it manually.%  16:45:34-1.3.2022

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
        addMenuItemListener(resourceIdentifiers::id_file_new, onFileNew).
% end of automatic code

end implement taskWindow
