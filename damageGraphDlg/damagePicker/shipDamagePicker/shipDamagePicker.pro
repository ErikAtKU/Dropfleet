% Copyright

implement shipDamagePicker inherits userControlSupport
    open core, vpiDomains

facts
    fbs : shipClass::fleetBuilderStats := erroneous.

clauses
    new(Parent) :-
        new(),
        setContainer(Parent).

clauses
    new() :-
        userControlSupport::new(),
        generatedInitialize().

clauses
    setFBS(FBS) :-
        fbs := FBS,
        name_ctl:setText(string::present(FBS)).

clauses
    setPoints(_Points) :-
        isErroneous(fbs),
        !.
    setPoints(Points) :-
        shipClass::getFBSPoints(fbs, ShipCost),
        Num = math::max(Points div ShipCost, 1),
        max_int:setText(toString(Num)),
        Cost = Num * ShipCost,
        cost_ctl:setText(toString(Cost)).

clauses
    getGroupRange_nd() = Return :-
        Max = tryToTerm(max_int:getText()),
        Max > 0,
        !,
        (standardOrders_ctl:getChecked() = true and SA = true and WF = false or weaponsFree_ctl:getChecked() = true and SA = false and WF = true),
        Return = tuple(SA, WF, closeAction_ctl:getChecked(), launch_ctl:getChecked(), ~~singleLinked_ctl:getChecked(), Max, fbs).

predicates
    onClick : button::clickResponder.
clauses
    onClick(_Source) = button::defaultAction :-
        displayImage::displayImage(This, fbs).

% This code is maintained automatically, do not update it manually.
facts
    max_int : editControl.
    cost_ctl : editControl.
    name_ctl : button.
    standardOrders_ctl : checkButton.
    weaponsFree_ctl : checkButton.
    closeAction_ctl : checkButton.
    launch_ctl : checkButton.
    singleLinked_ctl : checkButton.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("shipDamagePicker"),
        setSize(140, 12),
        max_int := editControl::new(This),
        max_int:setText("10"),
        max_int:setRect(vpiDomains::rct(0, 0, 12, 12)),
        max_int:setEnabled(false),
        cost_ctl := editControl::new(This),
        cost_ctl:setText("10"),
        cost_ctl:setRect(vpiDomains::rct(12, 0, 36, 12)),
        cost_ctl:setEnabled(false),
        name_ctl := button::new(This),
        name_ctl:setText("UCM"),
        name_ctl:setPosition(36, 0),
        name_ctl:setWidth(64),
        name_ctl:defaultHeight := false,
        name_ctl:setHeight(12),
        name_ctl:setClickResponder(onClick),
        standardOrders_ctl := checkButton::new(This),
        standardOrders_ctl:setRect(vpiDomains::rct(100, 0, 108, 12)),
        weaponsFree_ctl := checkButton::new(This),
        weaponsFree_ctl:setRect(vpiDomains::rct(108, 0, 116, 12)),
        closeAction_ctl := checkButton::new(This),
        closeAction_ctl:setRect(vpiDomains::rct(116, 0, 124, 12)),
        launch_ctl := checkButton::new(This),
        launch_ctl:setRect(vpiDomains::rct(124, 0, 132, 12)),
        singleLinked_ctl := checkButton::new(This),
        singleLinked_ctl:setRect(vpiDomains::rct(132, 0, 140, 12)).
% end of automatic code

end implement shipDamagePicker
