﻿% Copyright

implement ucmReykjavik inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(40, 6.0, 3.0, 14.0, 5, d6(5, p), 2, g(2, 3), light(2)).
    special_var : shipSpecial* = [outlier, vectored].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* := [weaponSystem("UF-9000-S Twin Mass Driver", d6(3, p), i(2), i(2), [front()], [fusillade(1)])].

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

end implement ucmReykjavik
