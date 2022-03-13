% Copyright

implement phrPompeius inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(180, 8.0, 6.0, 12.0, 15, d6(3, p), 7, g(1, 1), heavy).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Heavy Quad Battery", d6(4, p), i(4), i(2), [front()], [calibre([cat_heavy, cat_superHeavy]), fusillade(4)]),
            weaponSystem("Hornet Drones", d6(3, p), nd3plus(1, 3), i(1), [front(), side(), rear], [closeAction()])
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
        ConstructorStats = getFleetBuilderStats(class_name(), shipStats_var, special_var, { () = newShip() }).

clauses
    getShipCount() = shipCount.

end implement phrPompeius
