﻿% Copyright

implement phrEuropa inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(40, 8.0, 3.0, 10.0, 5, d6(3, p), 3, g(2, 4), light(1)).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Medium Calibre Bank", d6(4, p), i(3), i(1), [side(left)], [linked(1)]),
            weaponSystem("Medium Calibre Bank", d6(4, p), i(3), i(1), [side(right)], [linked(1)]),
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
    getFleetBuilderStats() = fbs(ConstructorStats, class_name(), special_var, { () = newShip() }) :-
        ConstructorStats = getFleetBuilderStats(shipStats_var).

clauses
    getShipCount() = shipCount.

clauses
    getImageFile() = string::format("../images/%s.png", class_name()).

end implement phrEuropa
