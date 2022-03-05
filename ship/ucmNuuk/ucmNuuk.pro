% Copyright

implement ucmNuuk inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(40, 6.0, 3.0, 14.0, 5, d6(5, p), 2, g(2, 3), light(2)).
    special_var : shipSpecial* = [outlier, vectored].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* := [weaponSystem("Haywire Blaster", d6(4, p), i(1), i(0), [front()], [closeAction(beam), haywire])].

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
    getFleetBuilderStats() = fbs(ConstructorStats, class_name(), special_var, { () = newShip() }) :-
        ConstructorStats = getFleetBuilderStats(shipStats_var).

clauses
    getShipCount() = shipCount.

end implement ucmNuuk
