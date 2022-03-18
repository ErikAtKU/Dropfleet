% Copyright

implement damagePicker inherits userControlSupport
    open core, vpiDomains

facts
    shipDamagePickerList : shipDamagePicker* := [].

clauses
    new(Parent) :-
        new(),
        setContainer(Parent),
        shipDamagePicker_ctl:setFBS(ucmTokyo::getFleetBuilderStats()),
        shipDamagePickerList := [shipDamagePicker_ctl].

clauses
    new() :-
        userControlSupport::new(),
        generatedInitialize().

predicates
    onScroll : scrollControl::scrollListener.
clauses
    onScroll(_Source, _ScrollType, ThumbPosition) :-
        (ThumbPosition < 0 or 100 < ThumbPosition),
        !.
    onScroll(_Source, _ScrollType, ThumbPosition) :-
        Count = list::length(shipDamagePickerList),
        CtlHeight = shipDamagePicker_ctl:getHeight() + 1,
        Height = groupBox_ctl:getHeight(),
        MaxCount = Height div CtlHeight,
        Factor = if Count < MaxCount then -2 * (ThumbPosition div 20) else -1 * (CtlHeight * ThumbPosition * (1 + Count - MaxCount) div 100) end if,
        PosSet = varM_integer::new(Factor),
        foreach ShipCount in shipDamagePickerList do
            ShipCount:setPosition(3, PosSet:value),
            PosSet:add(CtlHeight)
        end foreach.

clauses
    addShipList(Models) :-
        Ships = [ SingleShip || tuple(_, _, SingleShip) in Models ],
        [First | Rest] = Ships,
        !,
        deleteAllOthers(),
        shipDamagePicker_ctl:setFBS(First),
        shipDamagePicker_ctl:setVisible(true),
        shipDamagePickerList := [shipDamagePicker_ctl],
        foreach FBS in Rest do
            ShipDamagePicker_ctl = shipDamagePicker::new(groupBox_ctl),
            W = ShipDamagePicker_ctl:getWidth(),
            H = ShipDamagePicker_ctl:getHeight(),
            ShipDamagePicker_ctl:setRect(vpiDomains::rct(3, 0, 3 + W, H)),
            ShipDamagePicker_ctl:setFBS(FBS),
            ShipDamagePicker_ctl:show(),
            shipDamagePickerList := list::append(shipDamagePickerList, [ShipDamagePicker_ctl])
        end foreach,
        if [_, SecondShipCount | _] = shipDamagePickerList then
            shipDamagePicker_ctl:setRect(SecondShipCount:getRect())
        end if,
        vertScroll_ctl:setThumbPosition(0),
        onScroll(vertScroll_ctl, vpiDomains::sc_lineUp, vertScroll_ctl:getThumbPosition()).
    addShipList(_Ships) :-
        deleteAllOthers().

clauses
    setPoints(Points) :-
        foreach ShipCount in shipDamagePickerList do
            ShipCount:setPoints(Points)
        end foreach.

clauses
    getFleetRange() = List :-
        List =
            [ GroupRange ||
                ShipDamagePicker in shipDamagePickerList, %+
                    GroupRange = ShipDamagePicker:getGroupRange_nd()
            ].

predicates
    deleteAllOthers : ().
clauses
    deleteAllOthers() :-
        shipDamagePicker_ctl:setVisible(false),
        ShipCountVars = list::remove(shipDamagePickerList, shipDamagePicker_ctl),
        foreach ShipCount in ShipCountVars do
            ShipCount:setVisible(false),
            ShipCount:destroy()
        end foreach,
        shipDamagePickerList := [].

predicates
    onFrameScroll : window::scrollListener.
clauses
    onFrameScroll(_Source, ScrollCode, _ThumbPosition) :-
        Mod = if ScrollCode = 1 then -1 elseif ScrollCode = 2 then 1 else 0 end if,
        vertScroll_ctl:setThumbPosition(vertScroll_ctl:getThumbPosition() + Mod),
        delayCall(1, { () :- onScroll(vertScroll_ctl, ScrollCode, vertScroll_ctl:getThumbPosition()) }).

% This code is maintained automatically, do not update it manually.
facts
    groupBox_ctl : groupBox.
    shipDamagePicker_ctl : shipDamagePicker.
    vertScroll_ctl : scrollControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("damagePicker"),
        setSize(168, 168),
        addVScrollListener(onFrameScroll),
        Edit_ctl = textControl::new(This),
        Edit_ctl:setText("S/WF/Caw/Arc"),
        Edit_ctl:setPosition(112, 0),
        Edit_ctl:setEnabled(true),
        Edit_ctl:setWidth(44),
        groupBox_ctl := groupBox::new(This),
        groupBox_ctl:setText("Damage Picker:"),
        groupBox_ctl:setRect(vpiDomains::rct(4, 2, 164, 166)),
        groupBox_ctl:setAnchors([control::left, control::top, control::right, control::bottom]),
        shipDamagePicker_ctl := shipDamagePicker::new(groupBox_ctl),
        shipDamagePicker_ctl:setRect(vpiDomains::rct(3, 0, 143, 12)),
        vertScroll_ctl := scrollControl::newVertical(groupBox_ctl),
        vertScroll_ctl:setRect(vpiDomains::rct(143, 0, 155, 154)),
        vertScroll_ctl:setAnchors([control::top, control::right, control::bottom]),
        vertScroll_ctl:addScrollListener(onScroll).
% end of automatic code

end implement damagePicker
