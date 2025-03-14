﻿% Copyright

implement phrEcho inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(30, 8.0, 2.0, 12.0, 2, d6(4, p), 2, g(1, 3), light(1)).
    special_var : shipSpecial* = [atmospheric, stealth, outlier].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Medium Calibre Turret", d6(4, p), i(2), i(1), [front()], []),
            weaponSystem("Vespa Drones", d6(4, p), i(3), i(1), [front(), side(), rear], [airToAir, closeAction()])
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

end implement phrEcho
