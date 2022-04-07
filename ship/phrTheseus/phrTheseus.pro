﻿% Copyright

implement phrTheseus inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(89, 8.0, 6.0, 10.0, 9, d6(3, p), 2, g(1, 3), medium).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Light Calibre Battery", d6(5, p), i(6), i(1), [side(left)], [calibre([cat_light]), linked(1), fusillade(3)]),
            weaponSystem("Light Calibre Battery", d6(5, p), i(6), i(1), [side(right)], [calibre([cat_light]), linked(2), fusillade(3)]),
            weaponSystem("Medium Calibre Battery", d6(4, p), i(4), i(1), [side(left)], [linked(1), fusillade(2)]),
            weaponSystem("Medium Calibre Battery", d6(4, p), i(4), i(1), [side(right)], [linked(2), fusillade(2)]),
            weaponSystem("Wasp Drones", d6(3, p), nd3plus(1, 1), i(1), [front(), side(), rear], [closeAction()])
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

end implement phrTheseus
