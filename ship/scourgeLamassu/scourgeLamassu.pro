﻿% Copyright

implement scourgeLamassu inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(45, 6.0, 5.0, 6.0, 4, d6(3, p), 4, g(1, 3), light(1)).
    special_var : shipSpecial* = [launch(launchAssets)].
    launchAssets : launchSystem* = [strikeCraft(bulkLander, 1, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Oculus Rays", d6(3, p), i(1), i(1), [front()], [scald]),
            weaponSystem("Plasma Bombs", d6(3, p), i(2), i(1), [front(), side()], [bombardment]),
            weaponSystem("Plasma Cloud", d6(3, p), i(2), i(1), [front(), side(), rear], [closeAction(), scald])
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

end implement scourgeLamassu
