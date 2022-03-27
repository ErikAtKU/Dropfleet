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
        setAllEnabled(false),
        damageGraph_ctl:makeDamageMap(damagePicker_ctl:getFleetRange(), getTarget(), lastTrials),
        damageGraph_ctl:setText("Damage Graph"),
        setAllEnabled(true).

predicates
    setAllEnabled : (boolean Enabled).
clauses
    setAllEnabled(Enabled) :-
        damagePoints_ctl:setEnabled(Enabled),
        trials_ctl:setEnabled(Enabled),
        damagePicker_ctl:setEnabled(Enabled),
        hirukoRadio_ctl:setEnabled(Enabled),
        newOrleansRadio_ctl:setEnabled(Enabled),
        castorRadio_ctl:setEnabled(Enabled),
        harpyRadio_ctl:setEnabled(Enabled),
        osakaRadio_ctl:setEnabled(Enabled),
        aquamarineRadio_ctl:setEnabled(Enabled),
        orpheusRadio_ctl:setEnabled(Enabled),
        basaltRadio_ctl:setEnabled(Enabled),
        shenlongRadio_ctl:setEnabled(Enabled),
        bellaRadio_ctl:setEnabled(Enabled),
        londonRadio_ctl:setEnabled(Enabled),
        platinumRadio_ctl:setEnabled(Enabled),
        generateDamage_ctl:setEnabled(Enabled),
        ok_ctl:setEnabled(Enabled),
        cancel_ctl:setEnabled(Enabled).

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

predicates
    getTarget : () -> shipClass::fleetBuilderStats.
clauses
    getTarget() = scourgeHiruko::getFleetBuilderStats() :-
        hirukoRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = ucmNewOrleans::getFleetBuilderStats() :-
        newOrleansRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = phrCastor::getFleetBuilderStats() :-
        castorRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = scourgeHarpy::getFleetBuilderStats() :-
        harpyRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = ucmOsaka::getFleetBuilderStats() :-
        osakaRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = shaltariAquamarine::getFleetBuilderStats() :-
        aquamarineRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = phrOrpheus::getFleetBuilderStats() :-
        orpheusRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = shaltariBasalt::getFleetBuilderStats() :-
        basaltRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = scourgeShenlong::getFleetBuilderStats() :-
        shenlongRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = phrBellerophon::getFleetBuilderStats() :-
        bellaRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = ucmLondon::getFleetBuilderStats() :-
        londonRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = shaltariPlatinum::getFleetBuilderStats() :-
        platinumRadio_ctl:getRadioState() = radioButton::checked(),
        !.
    getTarget() = ucmOsaka::getFleetBuilderStats().

% This code is maintained automatically, do not update it manually.
facts
    damagePoints_ctl : editControl.
    trials_ctl : editControl.
    damagePicker_ctl : damagePicker.
    hirukoRadio_ctl : radioButton.
    newOrleansRadio_ctl : radioButton.
    castorRadio_ctl : radioButton.
    harpyRadio_ctl : radioButton.
    osakaRadio_ctl : radioButton.
    aquamarineRadio_ctl : radioButton.
    orpheusRadio_ctl : radioButton.
    basaltRadio_ctl : radioButton.
    shenlongRadio_ctl : radioButton.
    bellaRadio_ctl : radioButton.
    londonRadio_ctl : radioButton.
    platinumRadio_ctl : radioButton.
    generateDamage_ctl : button.
    damageGraph_ctl : damageGraph.
    ok_ctl : button.
    cancel_ctl : button.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("damageGraphDlg"),
        setRect(vpiDomains::rct(50, 40, 650, 370)),
        setModal(true),
        setDecoration(titlebar([frameDecoration::closeButton])),
        Points_ctl = textControl::new(This),
        Points_ctl:setText("Points"),
        Points_ctl:setRect(vpiDomains::rct(4, 8, 28, 18)),
        damagePoints_ctl := editControl::new(This),
        damagePoints_ctl:setText("100"),
        damagePoints_ctl:setRect(vpiDomains::rct(32, 6, 68, 18)),
        damagePoints_ctl:addModifiedListener(onIntChange),
        trials_ctl := editControl::new(This),
        trials_ctl:setText("100000"),
        trials_ctl:setPosition(124, 6),
        trials_ctl:addModifiedListener(onIntChange),
        damagePicker_ctl := damagePicker::new(This),
        damagePicker_ctl:setRect(vpiDomains::rct(4, 24, 172, 324)),
        hirukoRadio_ctl := radioButton::new(This),
        hirukoRadio_ctl:setText("Hiruko"),
        hirukoRadio_ctl:setRect(vpiDomains::rct(248, 28, 292, 40)),
        newOrleansRadio_ctl := radioButton::new(This),
        newOrleansRadio_ctl:setText("New Orleans (Atmosphere)"),
        newOrleansRadio_ctl:setRect(vpiDomains::rct(320, 28, 424, 40)),
        castorRadio_ctl := radioButton::new(This),
        castorRadio_ctl:setText("Castor"),
        castorRadio_ctl:setRect(vpiDomains::rct(248, 44, 284, 56)),
        harpyRadio_ctl := radioButton::new(This),
        harpyRadio_ctl:setText("Harpy (Atmosphere)"),
        harpyRadio_ctl:setRect(vpiDomains::rct(320, 44, 420, 56)),
        osakaRadio_ctl := radioButton::new(This),
        osakaRadio_ctl:setText("Osaka"),
        osakaRadio_ctl:setRect(vpiDomains::rct(248, 60, 292, 72)),
        osakaRadio_ctl:setRadioState(radioButton::checked),
        aquamarineRadio_ctl := radioButton::new(This),
        aquamarineRadio_ctl:setText("Aquamarine (Shields)"),
        aquamarineRadio_ctl:setRect(vpiDomains::rct(320, 60, 408, 72)),
        orpheusRadio_ctl := radioButton::new(This),
        orpheusRadio_ctl:setText("Orpheus"),
        orpheusRadio_ctl:setRect(vpiDomains::rct(248, 76, 292, 88)),
        basaltRadio_ctl := radioButton::new(This),
        basaltRadio_ctl:setText("Basalt (Shields + Fighters)"),
        basaltRadio_ctl:setRect(vpiDomains::rct(320, 76, 424, 88)),
        shenlongRadio_ctl := radioButton::new(This),
        shenlongRadio_ctl:setText("Shenlong"),
        shenlongRadio_ctl:setRect(vpiDomains::rct(248, 92, 292, 104)),
        bellaRadio_ctl := radioButton::new(This),
        bellaRadio_ctl:setText("Bellarophon (Fighters)"),
        bellaRadio_ctl:setRect(vpiDomains::rct(320, 92, 408, 104)),
        londonRadio_ctl := radioButton::new(This),
        londonRadio_ctl:setText("London (Aegis)"),
        londonRadio_ctl:setRect(vpiDomains::rct(248, 108, 312, 120)),
        platinumRadio_ctl := radioButton::new(This),
        platinumRadio_ctl:setText("Platinum (Fighters)"),
        platinumRadio_ctl:setRect(vpiDomains::rct(320, 108, 404, 120)),
        generateDamage_ctl := button::new(This),
        generateDamage_ctl:setText("Damage Graph"),
        generateDamage_ctl:setPosition(180, 128),
        generateDamage_ctl:setClickResponder(onDamage),
        damageGraph_ctl := damageGraph::new(This),
        damageGraph_ctl:setRect(vpiDomains::rct(180, 150, 592, 304)),
        damageGraph_ctl:setAnchors([control::top, control::right, control::bottom]),
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
        cancel_ctl:setAnchors([control::right, control::bottom]).
% end of automatic code

end implement damageGraphDlg
