% Copyright

implement scourgeNickar inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(22, 6.0, 2.0, 16.0, 2, d6(6, p), 2, g(1, 3), light(1)).
    special_var : shipSpecial* = [atmospheric].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [weaponSystem("Plasma Squall", d6(4, p), nd6plus(1, 0), i(1), [front(), side(), rear], [airToAir, closeAction(), scald])].

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

end implement scourgeNickar
