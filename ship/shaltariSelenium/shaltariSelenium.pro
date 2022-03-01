% Copyright

implement shaltariSelenium inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(40, 14.0, sig(3.0, 16.0), 6.0, 4, arm(d6(4, p), d6(4, p)), 6, g(1, 2), light(1)).
    special_var : shipSpecial* = [atmospheric, monitor_stat, voidgate(2)].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Defence Array", d6(4, p), i(4), i(1), [front(), side(), rear], [escapeVelocity]),
            weaponSystem("Charged Air", d6(6, p), i(3), i(1), [front(), side(), rear], [airToAir, closeAction()])
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

end implement shaltariSelenium
