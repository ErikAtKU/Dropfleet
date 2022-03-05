% Copyright

implement fleetPicker inherits userControlSupport
    open core, vpiDomains

facts
    shipCountNameList : shipCountName* := [].

clauses
    new(Parent) :-
        new(),
        setContainer(Parent),
        shipCountName_ctl:setFBS(ucmTokyo::getFleetBuilderStats()),
        shipCountNameList := [shipCountName_ctl].

clauses
    new() :-
        userControlSupport::new(),
        generatedInitialize().

predicates
    onScroll : scrollControl::scrollListener.
clauses
    onScroll(_Source, _ScrollType, ThumbPosition) :-
        Count = list::length(shipCountNameList),
        CtlHeight = shipCountName_ctl:getHeight() + 1,
        Height = groupBox_ctl:getHeight(),
        MaxCount = Height div CtlHeight,
        Factor = if Count < MaxCount then -2 * (ThumbPosition div 20) else -1 * (CtlHeight * ThumbPosition * (1 + Count - MaxCount) div 100) end if,
        PosSet = varM_integer::new(Factor),
        foreach ShipCount in shipCountNameList do
            ShipCount:setPosition(3, PosSet:value),
            PosSet:add(CtlHeight)
        end foreach.

clauses
    addShipList(Ships) :-
        [First | Rest] = Ships,
        !,
        deleteAllOthers(),
        shipCountName_ctl:setFBS(First),
        shipCountName_ctl:setVisible(true),
        shipCountNameList := [shipCountName_ctl],
        foreach FBS in Rest do
            ShipCountName_ctl = shipCountName::new(groupBox_ctl),
            W = ShipCountName_ctl:getWidth(),
            H = ShipCountName_ctl:getHeight(),
            ShipCountName_ctl:setRect(vpiDomains::rct(3, 0, 3 + W, H)),
            ShipCountName_ctl:setFBS(ucmToulon::getFleetBuilderStats()),
            ShipCountName_ctl:setFBS(FBS),
            ShipCountName_ctl:show(),
            shipCountNameList := list::append(shipCountNameList, [ShipCountName_ctl])
        end foreach,
        if [_, SecondShipCount | _] = shipCountNameList then
            shipCountName_ctl:setRect(SecondShipCount:getRect())
        end if,
        vertScroll_ctl:setThumbPosition(0),
        onScroll(vertScroll_ctl, vpiDomains::sc_lineUp, vertScroll_ctl:getThumbPosition()).
    addShipList(_Ships) :-
        deleteAllOthers().

predicates
    deleteAllOthers : ().
clauses
    deleteAllOthers() :-
        shipCountName_ctl:setVisible(false),
        ShipCountVars = list::remove(shipCountNameList, shipCountName_ctl),
        foreach ShipCount in ShipCountVars do
            ShipCount:setVisible(false),
            ShipCount:destroy()
        end foreach,
        shipCountNameList := [].

predicates
    onFrameScroll : window::scrollListener.
clauses
    onFrameScroll(_Source, ScrollCode, _ThumbPosition) :-
        Mod = if ScrollCode = 1 then -1 elseif ScrollCode = 2 then 1 else 0 end if,
        vertScroll_ctl:setThumbPosition(vertScroll_ctl:getThumbPosition() + Mod),
        onScroll(vertScroll_ctl, ScrollCode, vertScroll_ctl:getThumbPosition()).

% This code is maintained automatically, do not update it manually.
facts
    groupBox_ctl : groupBox.
    shipCountName_ctl : shipCountName.
    vertScroll_ctl : scrollControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("fleetPicker"),
        setSize(168, 168),
        addVScrollListener(onFrameScroll),
        groupBox_ctl := groupBox::new(This),
        groupBox_ctl:setText("Fleet Picker"),
        groupBox_ctl:setRect(vpiDomains::rct(4, 2, 164, 166)),
        groupBox_ctl:setAnchors([control::left, control::top, control::right, control::bottom]),
        shipCountName_ctl := shipCountName::new(groupBox_ctl),
        shipCountName_ctl:setRect(vpiDomains::rct(3, 0, 143, 12)),
        vertScroll_ctl := scrollControl::newVertical(groupBox_ctl),
        vertScroll_ctl:setRect(vpiDomains::rct(143, 0, 155, 154)),
        vertScroll_ctl:setAnchors([control::top, control::right, control::bottom]),
        vertScroll_ctl:addScrollListener(onScroll).
% end of automatic code

end implement fleetPicker
