% Copyright

implement damageGraphDlg inherits dialog
    open core, vpiDomains

clauses
    display(Parent, Faction, Models) = Dialog :-
        FactionList = generateCostListDlg::fillFactionMap(Faction, Models),
        Dialog = new(Parent, FactionList),
        Dialog:show().

clauses
    new(Parent, Fleet) :-
        dialog::new(Parent),
        generatedInitialize(),
        delayCall(1,
            { () :-
                damagePicker_ctl:addShipList(Fleet),
                onIntChange(damagePoints_ctl),
                onIntChange(trials_ctl)
            }).

predicates
    onDamage : button::clickResponder.
clauses
    onDamage(_Source) = button::defaultAction :-
        damageGraph_ctl:makeDamageMap(damagePicker_ctl:getFleetRange(), lastTrials).

facts
    lastNum : integer := 100.
    lastTrials : integer := 100000.

predicates
    onIntChange : editControl::modifiedListener.
clauses
    onIntChange(damagePoints_ctl) :-
        "" = damagePoints_ctl:getText(),
        !,
        lastNum := 0,
        delayCall(1, { () :- damagePicker_ctl:setPoints(0) }).
    onIntChange(damagePoints_ctl) :-
        Num = tryToTerm(damagePoints_ctl:getText()),
        Num < 1000,
        0 <= Num,
        !,
        lastNum := Num,
        delayCall(1, { () :- damagePicker_ctl:setPoints(Num) }).
    onIntChange(damagePoints_ctl) :-
        !,
        damagePoints_ctl:setText(toString(lastNum)).
    onIntChange(trials_ctl) :-
        "" = trials_ctl:getText(),
        !,
        lastTrials := 0.
    onIntChange(trials_ctl) :-
        Num = tryToTerm(trials_ctl:getText()),
        0 <= Num,
        !,
        lastTrials := Num.
    onIntChange(trials_ctl) :-
        !,
        trials_ctl:setText(toString(lastTrials)).
    onIntChange(_).

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    fleetCost_lbox : lboxScroll_ctl.
    damageGraph_ctl : damageGraph.
    damagePoints_ctl : editControl.
    generateDamage_ctl : button.
    damagePicker_ctl : damagePicker.
    vsOsaka_ctl : radioButton.
    trials_ctl : editControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("generateCostListDlg"),
        setRect(vpiDomains::rct(50, 40, 650, 488)),
        setModal(true),
        setDecoration(titlebar([frameDecoration::closeButton])),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(476, 428),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(540, 428),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        fleetCost_lbox := lboxScroll_ctl::new(This),
        fleetCost_lbox:setRect(vpiDomains::rct(176, 180, 596, 424)),
        damageGraph_ctl := damageGraph::new(This),
        damageGraph_ctl:setRect(vpiDomains::rct(180, 24, 592, 178)),
        damageGraph_ctl:setAnchors([control::top, control::right, control::bottom]),
        Points_ctl = textControl::new(This),
        Points_ctl:setText("Points"),
        Points_ctl:setRect(vpiDomains::rct(4, 8, 28, 18)),
        damagePoints_ctl := editControl::new(This),
        damagePoints_ctl:setText("100"),
        damagePoints_ctl:setRect(vpiDomains::rct(32, 6, 68, 18)),
        damagePoints_ctl:addModifiedListener(onIntChange),
        generateDamage_ctl := button::new(This),
        generateDamage_ctl:setText("Damage Graph"),
        generateDamage_ctl:setPosition(184, 4),
        generateDamage_ctl:setClickResponder(onDamage),
        damagePicker_ctl := damagePicker::new(This),
        damagePicker_ctl:setRect(vpiDomains::rct(4, 24, 172, 444)),
        vsOsaka_ctl := radioButton::new(This),
        vsOsaka_ctl:setText("Vs Osaka"),
        vsOsaka_ctl:setRect(vpiDomains::rct(248, 6, 306, 18)),
        trials_ctl := editControl::new(This),
        trials_ctl:setText("100000"),
        trials_ctl:setPosition(124, 6),
        trials_ctl:addModifiedListener(onIntChange).
% end of automatic code

end implement damageGraphDlg
