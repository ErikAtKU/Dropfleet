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
    damageGraph_ctl : damageGraph.
    damagePoints_ctl : editControl.
    generateDamage_ctl : button.
    damagePicker_ctl : damagePicker.
    basaltRadio_ctl : radioButton.
    trials_ctl : editControl.
    londonRadio_ctl : radioButton.
    bellaRadio_ctl : radioButton.
    orpheusRadio_ctl : radioButton.
    shenlongRadio_ctl : radioButton.
    osakaRadio_ctl : radioButton.
    aquamarineRadio_ctl : radioButton.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("generateCostListDlg"),
        setRect(vpiDomains::rct(50, 40, 650, 370)),
        setModal(true),
        setDecoration(titlebar([frameDecoration::closeButton])),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(476, 310),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(540, 310),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        damageGraph_ctl := damageGraph::new(This),
        damageGraph_ctl:setRect(vpiDomains::rct(180, 150, 592, 304)),
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
        generateDamage_ctl:setPosition(180, 128),
        generateDamage_ctl:setClickResponder(onDamage),
        damagePicker_ctl := damagePicker::new(This),
        damagePicker_ctl:setRect(vpiDomains::rct(4, 24, 172, 324)),
        basaltRadio_ctl := radioButton::new(This),
        basaltRadio_ctl:setText("Basalt (Shields + Fighters)"),
        basaltRadio_ctl:setRect(vpiDomains::rct(304, 74, 408, 86)),
        trials_ctl := editControl::new(This),
        trials_ctl:setText("100000"),
        trials_ctl:setPosition(124, 6),
        trials_ctl:addModifiedListener(onIntChange),
        londonRadio_ctl := radioButton::new(This),
        londonRadio_ctl:setText("London (Aegis)"),
        londonRadio_ctl:setRect(vpiDomains::rct(304, 110, 368, 122)),
        bellaRadio_ctl := radioButton::new(This),
        bellaRadio_ctl:setText("Bellarophon (Fighters)"),
        bellaRadio_ctl:setRect(vpiDomains::rct(304, 92, 392, 104)),
        orpheusRadio_ctl := radioButton::new(This),
        orpheusRadio_ctl:setText("Orpheus"),
        orpheusRadio_ctl:setRect(vpiDomains::rct(248, 74, 292, 86)),
        shenlongRadio_ctl := radioButton::new(This),
        shenlongRadio_ctl:setText("Shenlong"),
        shenlongRadio_ctl:setRect(vpiDomains::rct(248, 92, 292, 104)),
        osakaRadio_ctl := radioButton::new(This),
        osakaRadio_ctl:setText("Osaka"),
        osakaRadio_ctl:setRect(vpiDomains::rct(248, 58, 292, 70)),
        aquamarineRadio_ctl := radioButton::new(This),
        aquamarineRadio_ctl:setText("Aquamarine (Shields)"),
        aquamarineRadio_ctl:setRect(vpiDomains::rct(304, 58, 392, 70)).
% end of automatic code
end implement damageGraphDlg
