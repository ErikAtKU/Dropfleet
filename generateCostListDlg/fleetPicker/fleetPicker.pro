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
        shipCountNameList := [shipCountName_ctl],
        foreach _Var = std::fromTo(1, 30) do
            ShipCountName_ctl = shipCountName::new(groupBox_ctl),
            ShipCountName_ctl:setRect(vpiDomains::rct(3, 0, 143, 16)),
            ShipCountName_ctl:setFBS(ucmToulon::getFleetBuilderStats()),
            ShipCountName_ctl:setVisible(true),
            shipCountNameList := list::append(shipCountNameList, [ShipCountName_ctl])
        end foreach,
        onScroll(vertScroll_ctl, vpiDomains::sc_lineUp, 0).

clauses
    new() :-
        userControlSupport::new(),
        generatedInitialize().

predicates
    onScroll : scrollControl::scrollListener.
clauses
    onScroll(_Source, _ScrollType, ThumbPosition) :-
        Count = list::length(shipCountNameList),
        CtlHeight = shipCountName_ctl:getHeight(),
        Height = groupBox_ctl:getHeight(),
        MaxCount = Height div CtlHeight,
        Factor = if Count < MaxCount then -2 * (ThumbPosition div 20) else -2 * (7 * ThumbPosition * (1 + Count - MaxCount) div 100) end if,
        PosSet = varM_integer::new(Factor),
        foreach ShipCount in shipCountNameList do
            ShipCount:setPosition(3, PosSet:value),
            PosSet:add(14)
        end foreach.

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
        groupBox_ctl := groupBox::new(This),
        groupBox_ctl:setText("GroupBox"),
        groupBox_ctl:setRect(vpiDomains::rct(4, 2, 164, 166)),
        groupBox_ctl:setAnchors([control::left, control::top, control::right, control::bottom]),
        shipCountName_ctl := shipCountName::new(groupBox_ctl),
        shipCountName_ctl:setRect(vpiDomains::rct(3, 0, 143, 14)),
        vertScroll_ctl := scrollControl::newVertical(groupBox_ctl),
        vertScroll_ctl:setRect(vpiDomains::rct(143, 0, 155, 154)),
        vertScroll_ctl:setAnchors([control::top, control::right, control::bottom]),
        vertScroll_ctl:addScrollListener(onScroll).
% end of automatic code

end implement fleetPicker
