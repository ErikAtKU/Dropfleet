% Copyright

implement ucmLima inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(37, 6.0, 3.0, 10.0, 4, d6(4, p), 3, g(1, 2), light(1)).
    special_var : shipSpecial* = [detector, outlier, rare].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("UF-2200 Mass Driver Turret", d6(4, p), i(1), i(1), [front(), side()], []),
            weaponSystem("Barracuda MIssile Bays", d6(4, p), i(2), i(1), [front(), side(), rear], [closeAction()])
        ].

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
        ConstructorStats = getFleetBuilderStats(class_name(), shipStats_var, special_var, weaponSystemList, { () = newShip() }).

clauses
    getShipCount() = shipCount.

end implement ucmLima
