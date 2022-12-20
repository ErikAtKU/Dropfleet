% Copyright

implement generateCostListDlg inherits dialog
    open core, vpiDomains

clauses
    display(Parent, Faction, Models) = Dialog :-
        FactionList = fillFactionMap(Faction, Models),
        Dialog = new(Parent, Faction, FactionList),
        Dialog:show().

clauses
    fillFactionMap(ucm, Fleet) = Return :-
        Return = fillFactionMap_helper(fleetBuilder::getUCMList(), Fleet).
    fillFactionMap(scourge, Fleet) = Return :-
        Return = fillFactionMap_helper(fleetBuilder::getScourgeList(), Fleet).
    fillFactionMap(phr, Fleet) = Return :-
        Return = fillFactionMap_helper(fleetBuilder::getPHRList(), Fleet).
    fillFactionMap(shaltari, Fleet) = Return :-
        Return = fillFactionMap_helper(fleetBuilder::getShaltariList(), Fleet).
    fillFactionMap(resistance, Fleet) = Return :-
        Return = fillFactionMap_helper(fleetBuilder::getResistanceList(), Fleet).

class predicates
    fillFactionMap_helper : (shipClass::fleetBuilderStats* ALLShips, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* OwnedFleet)
        -> tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* FullFleet.
clauses
    fillFactionMap_helper(ALLShips, Models) = Return :-
        HelpSet = setM_redBlack::newCustom({ (tuple(_, _, LFBS), tuple(_, _, RFBS)) = shipClass::fbsSorter(LFBS, RFBS) }),
        foreach Ship in ALLShips do
            HelpSet:insert(tuple(0, 0, Ship))
        end foreach,
        foreach Model in Models and HelpSet:contains(Model) do
            %sanity check, assuming faction list is correct
            HelpSet:remove(Model),
            HelpSet:insert(Model)
        end foreach,
        Return = HelpSet:asList.

facts
    faction_var : faction.

clauses
    new(Parent, Faction, Fleet) :-
        dialog::new(Parent),
        faction_var := Faction,
        generatedInitialize(),
        lowerPoints_ctl:setText(toString(480)),
        upperPoints_ctl:setText(toString(500)),
        delayCall(1, { () :- fleetPicker_ctl:addModelList(Fleet) }).

predicates
    generate : ().
clauses
    generate() :-
        fleetCost_lbox:setList([]),
        LowerPoints = tryToTerm(lowerPoints_ctl:getText()),
        UpperPoints = tryToTerm(upperPoints_ctl:getText()),
        FleetRange = fleetPicker_ctl:getFleetRange(),
        fleetBuilder::buildFleetCostMap_dt(LowerPoints, UpperPoints, FleetRange),
        foreach tuple(Cost, SetMap) in fleetBuilder::getListSet() do
            foreach tuple(Template, _SubMap) in SetMap do
                fleetCost_lbox:add(string::format("%d: %s", Cost, string::present(Template)))
            end foreach
        end foreach,
        fail.
    generate().

predicates
    onGenerate : button::clickResponder.
clauses
    onGenerate(_Source) = button::defaultAction :-
        generate().

predicates
    onOk : button::clickResponder.
clauses
    onOk(_Source) = button::defaultAction.

% This code is maintained automatically, do not update it manually.
facts
    lowerPoints_ctl : editControl.
    upperPoints_ctl : editControl.
    generate_ctl : button.
    ok_ctl : button.
    cancel_ctl : button.
    fleetPicker_ctl : fleetPicker.
    fleetCost_lbox : lboxScroll_ctl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("generateCostListDlg"),
        setRect(vpiDomains::rct(50, 40, 650, 488)),
        setModal(true),
        setDecoration(titlebar([frameDecoration::closeButton])),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Points"),
        StaticText_ctl:setPosition(4, 8),
        StaticText_ctl:setWidth(24),
        lowerPoints_ctl := editControl::new(This),
        lowerPoints_ctl:setText("480"),
        lowerPoints_ctl:setRect(vpiDomains::rct(32, 6, 56, 18)),
        upperPoints_ctl := editControl::new(This),
        upperPoints_ctl:setText("500"),
        upperPoints_ctl:setPosition(56, 6),
        upperPoints_ctl:setWidth(24),
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
        fleetPicker_ctl := fleetPicker::new(This),
        fleetPicker_ctl:setRect(vpiDomains::rct(4, 24, 172, 268)),
        fleetCost_lbox := lboxScroll_ctl::new(This),
        fleetCost_lbox:setRect(vpiDomains::rct(180, 24, 600, 268)).
% end of automatic code

end implement generateCostListDlg
