% Copyright

implement phrHarpocrates inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(30, 6.0, 2.0, 10.0, 2, d6(5, p), 2, g(1, 2), light(1)).
    special_var : shipSpecial* = [atmospheric, outlier].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* := [weaponSystem("EM Warfare Suite", d6(5, p), i(1), i(0), [front(), side()], [closeAction(beam), emSabotage])].

clauses
    new() :-
        shipCount := shipCount + 1,
        if Name in nameList and not(list::isMember(Name, usedNameList)) then
            usedNameList := [Name | usedNameList]
        else
            Name = string::format("%s_%d", class_name(), shipCount)
        end if,
        shipClass::new(shipStats_var, special_var, weaponSystemList, Name).

clauses
    newShip() = Ship :-
        New = new(),
        Ship = ship::new(New).

clauses
    resetNames() :-
        usedNameList := [],
        shipCount := 0.

clauses
    getFleetBuilderStats() = ConstructorStats :-
        ConstructorStats = getFleetBuilderStats(class_name(), shipStats_var, special_var, { () = newShip() }).

clauses
    getShipCount() = shipCount.

end implement phrHarpocrates
