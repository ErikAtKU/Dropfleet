﻿% Copyright

implement scourgeYokai inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(95, 6.0, 8.0, 12.0, 8, d6(5, p), 2, g(2, 3), medium).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Oculus Beams", d6(3, p), i(1), i(2), [front()], [scald]),
            weaponSystem("Oculus Beam Array", d6(3, p), i(2), i(2), [front(), side(left)], [scald]),
            weaponSystem("Oculus Beam Array", d6(3, p), i(2), i(2), [front(), side(right)], [scald]),
            weaponSystem("Plasma Storm", d6(3, p), nd6plus(1, 2), i(1), [front(), side(), rear], [scald, closeAction()])
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

end implement scourgeYokai
