% Copyright

implement shipCountName inherits userControlSupport
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
        min_int:setEnabled(true),
        name_ctl:setText(string::present(FBS)).

clauses
    setModel(tuple(MinNum, MaxNum, FBS)) :-
        setFBS(FBS),
        min_int:setText(toString(MinNum)),
        max_int:setText(toString(MaxNum)).

clauses
    setCostCount(tuple(Min, _Max, FBS)) :-
        setFBS(FBS),
        min_int:setText(toString(Min)),
        max_int:setEnabled(false),
        shipClass::getFBSPoints(FBS, Points),
        max_int:setText(toString(Points)).

clauses
    getGroupRange() = Return :-
        Min = tryToTerm(min_int:getText()),
        Max = tryToTerm(max_int:getText()),
        !,
        Return = tuple(Min, Max, fbs).
    getGroupRange() = tuple(0, 0, fbs).

clauses
    getCostRange_dt() = Return :-
        Num = tryToTerm(min_int:getText()),
        0 < Num,
        Cost = tryToTerm(max_int:getText()),
        !,
        Return = tuple(Num, Cost, fbs).

predicates
    onMod : editControl::modifiedListener.
clauses
    onMod(Source) :-
        false = Source:getEnabled(),
        !.
    onMod(Source) :-
        Val = tryToTerm(integer, Source:getText()),
        !,
        if Val < 0 then
            Source:setText("0")
        elseif 20 < Val then
            Source:setText("20")
        end if,
        if false = max_int:getEnabled() and Count = tryToTerm(integer, min_int:getText()) then
            shipClass::getFBSPoints(fbs, ShipPoints),
            CostVal = math::max(ShipPoints, ShipPoints * Count),
            max_int:setText(toString(CostVal))
        end if.
    onMod(min_int) :-
        min_int:setText(max_int:getText()),
        !.
    onMod(max_int) :-
        max_int:setText(min_int:getText()),
        !.
    onMod(_Source).

predicates
    onClick : button::clickResponder.
clauses
    onClick(_Source) = button::defaultAction :-
        displayImage::displayImage(This, fbs).

% This code is maintained automatically, do not update it manually.
facts
    min_int : editControl.
    max_int : editControl.
    name_ctl : button.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("shipCountName"),
        setSize(140, 12),
        min_int := editControl::new(This),
        min_int:setText("0"),
        min_int:setPosition(4, 0),
        min_int:setWidth(16),
        min_int:addModifiedListener(onMod),
        max_int := editControl::new(This),
        max_int:setText("1"),
        max_int:setRect(vpiDomains::rct(20, 0, 40, 12)),
        max_int:addModifiedListener(onMod),
        name_ctl := button::new(This),
        name_ctl:setText("UCM"),
        name_ctl:setPosition(40, 0),
        name_ctl:setWidth(96),
        name_ctl:defaultHeight := false,
        name_ctl:setHeight(12),
        name_ctl:setClickResponder(onClick).
% end of automatic code

end implement shipCountName
