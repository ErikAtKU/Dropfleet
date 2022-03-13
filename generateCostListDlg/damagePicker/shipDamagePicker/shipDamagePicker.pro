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
        Num = Points div ShipCost,
        max_int:setText(toString(Num)).

clauses
    getGroupRange_nd() = Return :-
        Max = tryToTerm(max_int:getText()),
        Max > 0,
        !,
        (standardOrders_ctl:getChecked() = true and SA = true and WF = false or weaponsFree_ctl:getChecked() = true and SA = false and WF = true),
        Return = tuple(SA, WF, closeAction_ctl:getChecked(), ~~singleLinked_ctl:getChecked(), Max, fbs).

predicates
    onClick : button::clickResponder.
clauses
    onClick(_Source) = button::defaultAction :-
        displayImage::displayImage(This, fbs).

% This code is maintained automatically, do not update it manually.
facts
    max_int : editControl.
    name_ctl : button.
    standardOrders_ctl : checkButton.
    weaponsFree_ctl : checkButton.
    closeAction_ctl : checkButton.
    singleLinked_ctl : checkButton.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("shipDamagePicker"),
        setSize(140, 12),
        max_int := editControl::new(This),
        max_int:setText("1"),
        max_int:setRect(vpiDomains::rct(4, 0, 16, 12)),
        max_int:setEnabled(false),
        name_ctl := button::new(This),
        name_ctl:setText("UCM"),
        name_ctl:setPosition(16, 0),
        name_ctl:setWidth(72),
        name_ctl:defaultHeight := false,
        name_ctl:setHeight(12),
        name_ctl:setClickResponder(onClick),
        standardOrders_ctl := checkButton::new(This),
        standardOrders_ctl:setRect(vpiDomains::rct(92, 0, 100, 12)),
        weaponsFree_ctl := checkButton::new(This),
        weaponsFree_ctl:setRect(vpiDomains::rct(104, 0, 112, 12)),
        closeAction_ctl := checkButton::new(This),
        closeAction_ctl:setRect(vpiDomains::rct(116, 0, 124, 12)),
        singleLinked_ctl := checkButton::new(This),
        singleLinked_ctl:setRect(vpiDomains::rct(128, 0, 136, 12)).
% end of automatic code

end implement shipDamagePicker
