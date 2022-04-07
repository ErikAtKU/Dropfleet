% Copyright

implement phrAgrippa inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(175, 8.0, 6.0, 12.0, 15, d6(3, p), 7, g(1, 1), heavy).
    special_var : shipSpecial* = [agrippa_stat].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Holographic Drones", d6(5, p), nd3plus(2, 3), i(1), [side(left)], [closeAction(swarmer), linked(1)]),
            weaponSystem("Holographic Drones", d6(5, p), nd3plus(2, 3), i(1), [side(right)], [closeAction(swarmer), linked(1)])
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

end implement phrAgrippa
