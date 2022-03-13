% Copyright

implement phrCastor inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(48, 10.0, 4.0, 4.0, 5, d6(2, p), 3, g(2, 3), light(1)).
    special_var : shipSpecial* = [monitor_stat].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Quad battery", d6(4, p), i(4), i(1), [front()], [fusillade(4)]),
            weaponSystem("Mosquito Drones", d6(4, p), i(2), i(1), [front(), side(), rear], [closeAction()])
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
        ConstructorStats = getFleetBuilderStats(class_name(), shipStats_var, special_var, { () = newShip() }).

clauses
    getShipCount() = shipCount.

end implement phrCastor
