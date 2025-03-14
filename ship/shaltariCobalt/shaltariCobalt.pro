﻿% Copyright

implement shaltariCobalt inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(45, 12.0, sig(3.0, 16.0), 12.0, 5, arm(d6(5, p), d6(4, p)), 6, g(1, 3), light(2)).
    special_var : shipSpecial* = [launch(launchAssets)].
    launchAssets : launchSystem* = [strikeCraft(gates, 1, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Disruption Beamers", d6(3, p), i(2), i(1), [front()], []),
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
    getFleetBuilderStats() = ConstructorStats :-
        ConstructorStats = getFleetBuilderStats(class_name(), shipStats_var, special_var, weaponSystemList, { () = newShip() }).

clauses
    getShipCount() = shipCount.

end implement shaltariCobalt
