﻿% Copyright

implement phrHector inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(155, 8.0, 6.0, 7.0, 13, d6(3, p), 5, g(1, 1), heavy).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Medium Calibre Broadside", d6(4, p), i(8), i(1), [side(left)], [linked(1), fusillade(3)]),
            weaponSystem("Medium Calibre Broadside", d6(4, p), i(8), i(1), [side(right)], [linked(1), fusillade(3)]),
            weaponSystem("Twin Supernova Laser", d6(3, p), i(2), i(1), [front(narrow)], [burnthrough(6), flash]),
            weaponSystem("Wasp Drones", d6(3, p), nd3plus(1, 1), i(1), [front(), side(), rear], [closeAction()])
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

end implement phrHector
