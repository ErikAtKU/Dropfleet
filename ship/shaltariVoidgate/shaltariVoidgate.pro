% Copyright

implement shaltariVoidgate inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(18, 12.0, sig(1.0, 8.0), 12.0, 2, arm(d6(5, p), d6(5, p)), 6, g(1, 3), light(1)).
    special_var : shipSpecial* = [voidgate(1), atmospheric, open_stat].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* := [weaponSystem("Charged Air", d6(6, p), i(1), i(1), [front(), side(), rear], [airToAir])].

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

end implement shaltariVoidgate
