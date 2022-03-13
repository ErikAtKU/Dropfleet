% Copyright

implement phrPegasus inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(45, 6.0, 3.0, 14.0, 5, d6(4, p), 2, g(2, 3), light(1)).
    special_var : shipSpecial* = [outlier, regenerate(6)].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* := [weaponSystem("Nano Drones", d6(4, p), nd3plus(2, 2), i(1), [front(), side()], [closeAction(swarmer)])].

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

end implement phrPegasus
