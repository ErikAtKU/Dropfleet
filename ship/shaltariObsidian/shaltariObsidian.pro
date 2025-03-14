﻿% Copyright

implement shaltariObsidian inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(145, 12.0, sig(3.0, 16.0), 8.0, 11, arm(d6(5, p), d6(4, p)), 9, g(1, 1), heavy).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Particle Lance", d6(3, p), i(1), i(2), [front(narrow)], [particle, linked(1), fusillade(1)]),
            weaponSystem("Particle Lance", d6(3, p), i(1), i(2), [front(narrow)], [particle, linked(1), fusillade(1)]),
            weaponSystem("Particle Lance", d6(3, p), i(1), i(2), [front(narrow)], [particle, fusillade(1)]),
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

end implement shaltariObsidian
