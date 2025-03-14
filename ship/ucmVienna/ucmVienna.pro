﻿% Copyright

implement ucmVienna inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(48, 6.0, 4.0, 6.0, 4, d6(2, p), 3, g(2, 3), light(1)).
    special_var : shipSpecial* = [aegis(4)].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Mamba Laser", d6(3, p), i(2), i(1), [front()], [burnthrough(3), flash]),
            weaponSystem("Shark Missile Bays", d6(4, p), nd6plus(1, 2), i(1), [front(), side(), rear], [closeAction()])
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

end implement ucmVienna
