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
        name_ctl:setText(string::present(FBS)).

clauses
    getGroupRange() = Return :-
        Min = tryToTerm(min_int:getText()),
        Max = tryToTerm(max_int:getText()),
        !,
        Return = tuple(Min, Max, fbs).
    getGroupRange() = tuple(0, 0, fbs).

predicates
    onMod : editControl::modifiedListener.
clauses
    onMod(Source) :-
        Val = tryToTerm(integer, Source:getText()),
        !,
        if Val < 0 then
            Source:setText("0")
        elseif 20 < Val then
            Source:setText("20")
        end if.
    onMod(min_int) :-
        min_int:setText(max_int:getText()),
        !.
    onMod(max_int) :-
        max_int:setText(min_int:getText()),
        !.
    onMod(_Source).

% This code is maintained automatically, do not update it manually.
facts
    min_int : editControl.
    max_int : editControl.
    name_ctl : editControl.

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
        max_int:setRect(vpiDomains::rct(20, 0, 36, 12)),
        max_int:addModifiedListener(onMod),
        name_ctl := editControl::new(This),
        name_ctl:setText("UCM"),
        name_ctl:setRect(vpiDomains::rct(36, 0, 136, 12)),
        name_ctl:setReadOnly(true).
% end of automatic code

end implement shipCountName
