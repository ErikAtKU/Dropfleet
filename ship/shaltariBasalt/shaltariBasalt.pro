﻿% Copyright

implement shaltariBasalt inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(145, 12.0, sig(3.0, 16.0), 10.0, 9, arm(d6(5, p), d6(4, p)), 9, g(1, 1), medium).
    special_var : shipSpecial* = [launch(launchAssets)].
    launchAssets : launchSystem* = [strikeCraft(shaltariFightersBombers, 4, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Disruptors", d6(4, p), i(6), i(1), [front(narrow)], []),
            weaponSystem("Harpoon Cascade", d6(4, p), i(3), i(1), [front(), side(), rear], [closeAction()])
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

end implement shaltariBasalt
