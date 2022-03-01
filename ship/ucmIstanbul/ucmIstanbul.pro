﻿% Copyright

implement ucmIstanbul inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(42, 10.0, 4.0, 6.0, 4, d6(2, p), 3, g(2, 3), light(1)).
    special_var : shipSpecial* = [monitor_stat].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("UF-B-9000s Mass Driver", d6(3, p), i(3), i(1), [front()], [alt(1)]),
            weaponSystem("UF-B-9000s Mass Driver", d6(2, p), i(2), i(2), [front()], [alt(1), bombardment]),
            weaponSystem("Baracuda Missile bays", d6(4, p), i(2), i(1), [front(), side(), rear], [closeAction()])
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

end implement ucmIstanbul
