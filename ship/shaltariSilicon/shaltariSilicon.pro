﻿% Copyright

implement shaltariSilicon inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(55, 14.0, sig(3.0, 16.0), 6.0, 4, arm(d6(4, p), d6(4, p)), 6, g(2, 3), light(1)).
    special_var : shipSpecial* = [monitor_stat].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Quad Ion Cannon", d6(4, p), i(2), i(2), [front()], [ion(2)]),
            weaponSystem("Harpoon Volley", d6(4, p), i(2), i(1), [front(), side(), rear], [closeAction()])
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

end implement shaltariSilicon
