% Copyright

implement simpleCostBuilder inherits dialog
    open core, vpiDomains

clauses
    display(Parent, Faction, Models) = Dialog :-
        FactionList = fillFactionMap(Faction, Models),
        Dialog = new(Parent, FactionList, Faction),
        Dialog:show().

class predicates
    fillFactionMap : (generateCostListDlg::faction, fleet::fleetCount* OwnedFleet)
        -> tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* FullFleet.
clauses
    fillFactionMap(generateCostListDlg::ucm, Fleet) = Return :-
        Return = fillFactionMap_helper(fleetBuilder::getUCMList(), Fleet).
    fillFactionMap(generateCostListDlg::scourge, Fleet) = Return :-
        Return = fillFactionMap_helper(fleetBuilder::getScourgeList(), Fleet).
    fillFactionMap(generateCostListDlg::phr, Fleet) = Return :-
        Return = fillFactionMap_helper(fleetBuilder::getPHRList(), Fleet).
    fillFactionMap(generateCostListDlg::shaltari, Fleet) = Return :-
        Return = fillFactionMap_helper(fleetBuilder::getShaltariList(), Fleet).
    fillFactionMap(generateCostListDlg::resistance, Fleet) = Return :-
        Return = fillFactionMap_helper(fleetBuilder::getResistanceList(), Fleet).

class predicates
    fillFactionMap_helper : (shipClass::fleetBuilderStats* ALLShips, fleet::fleetCount* OwnedFleet)
        -> tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* FullFleet.
clauses
    fillFactionMap_helper(ALLShips, Models) = Return :-
        HelpSet = setM_redBlack::newCustom({ (tuple(_, _, LFBS), tuple(_, _, RFBS)) = shipClass::fbsSorter(LFBS, RFBS) }),
        foreach Ship in ALLShips do
            HelpSet:insert(tuple(0, 0, Ship))
        end foreach,
        foreach
            tuple(ClassName, Count) in Models and Entry in HelpSet
            and tuple(_, _, shipClass::fbs(ConstructorStats, ClassName, Special, Constructor, Description)) = Entry
        do
            %sanity check, assuming faction list is correct
            HelpSet:remove(Entry),
            HelpSet:insert(tuple(Count, Count, shipClass::fbs(ConstructorStats, ClassName, Special, Constructor, Description)))
        end foreach,
        Return = HelpSet:asList.

facts
    faction_var : generateCostListDlg::faction.

clauses
    new(Parent, Fleet, Faction) :-
        dialog::new(Parent),
        generatedInitialize(),
        faction_var := Faction,
        delayCall(1,
            { () :-
                simpleCostPicker_ctl:addShipList(Fleet),
                timerCall()
            }).

predicates
    generate : ().
clauses
    generate() :-
        fleetCost_lbox:setList([]),
        LowerPoints = tryToTerm(lowerPoints_ctl:getText()),
        FleetRange = simpleCostPicker_ctl:getFleetRange(),
        fleetBuilder::buildFleetCostMap_dt(LowerPoints, LowerPoints, FleetRange),
        foreach tuple(Cost, SetMap) in fleetBuilder::getListSet() do
            foreach tuple(Template, _SubMap) in SetMap do
                fleetCost_lbox:add(string::format("%d: %s", Cost, string::present(Template)))
            end foreach
        end foreach,
        fail.
    generate().

predicates
    timerCall : ().
clauses
    timerCall() :-
        try
            Cost = simpleCostPicker_ctl:getTotalCost(),
            lowerPoints_ctl:setText(toString(Cost)),
            delayCall(1000, timerCall)
        catch _Ex do
            succeed
        end try.

predicates
    onGenerate : button::clickResponder.
clauses
    onGenerate(_Source) = button::defaultAction :-
        generate().

predicates
    onOk : button::clickResponder.
clauses
    onOk(_Source) = button::defaultAction :-
        FleetRange = simpleCostPicker_ctl:getFleetRange(),
        ShipList = convertFleetRange(FleetRange),
        if generateCostListDlg::ucm = faction_var then
            fleet::myUCMShips := ShipList
        elseif generateCostListDlg::scourge = faction_var then
            fleet::myScourgeShips := ShipList
        elseif generateCostListDlg::phr = faction_var then
            fleet::myPHRShips := ShipList
        elseif generateCostListDlg::shaltari = faction_var then
            fleet::myShaltariShips := ShipList
        elseif generateCostListDlg::resistance = faction_var then
            fleet::myResistanceShips := ShipList
        end if.

class predicates
    convertFleetRange : (tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*) -> tuple{string ClassName, integer MaxNum}*.
clauses
    convertFleetRange([]) = [].
    convertFleetRange([tuple(Count, _Cost, shipClass::fbs(_, ClassName, _, _, _)) | Rest]) = [tuple(ClassName, Count) | ReturnList] :-
        ReturnList = convertFleetRange(Rest).

% This code is maintained automatically, do not update it manually.
facts
    lowerPoints_ctl : editControl.
    generate_ctl : button.
    ok_ctl : button.
    cancel_ctl : button.
    simpleCostPicker_ctl : simpleCostPicker.
    fleetCost_lbox : lboxScroll_ctl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("generateCostListDlg"),
        setRect(vpiDomains::rct(50, 40, 650, 460)),
        setModal(true),
        setDecoration(titlebar([frameDecoration::closeButton])),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Points"),
        StaticText_ctl:setPosition(4, 8),
        StaticText_ctl:setWidth(24),
        lowerPoints_ctl := editControl::new(This),
        lowerPoints_ctl:setText("480"),
        lowerPoints_ctl:setRect(vpiDomains::rct(32, 6, 56, 18)),
        generate_ctl := button::new(This),
        generate_ctl:setText("Generate"),
        generate_ctl:setPosition(116, 4),
        generate_ctl:setClickResponder(onGenerate),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("Update Ship Count"),
        ok_ctl:setPosition(456, 272),
        ok_ctl:setSize(72, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        ok_ctl:setClickResponder(onOk),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(536, 272),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        simpleCostPicker_ctl := simpleCostPicker::new(This),
        simpleCostPicker_ctl:setRect(vpiDomains::rct(4, 24, 172, 268)),
        fleetCost_lbox := lboxScroll_ctl::new(This),
        fleetCost_lbox:setRect(vpiDomains::rct(180, 24, 600, 268)).
% end of automatic code

end implement simpleCostBuilder
