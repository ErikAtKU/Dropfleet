﻿% Copyright

implement ucmRome inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(170, 6.0, 6.0, 8.0, 14, d6(3, p), 15, g(1, 1), heavy).
    special_var : shipSpecial* = [launch(launchAssets), aegis(9)].
    launchAssets : launchSystem* = [torpedo(ucmHeavyTorpedo, 1, [limited(1)]), torpedo(ucmHeavyTorpedo, 1, [limited(1)])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("UF-4200 Mass Driver Turret", d6(4, p), i(2), i(1), [front(), side(left)], [linked(1)]),
            weaponSystem("UF-4200 Mass Driver Turret", d6(4, p), i(2), i(1), [front(), side(right)], [linked(1)]),
            weaponSystem("Shark Missile Bays", d6(4, p), nd6plus(1, 1), i(1), [front(), side(), rear], [closeAction()])
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

end implement ucmRome
