% Copyright

implement phrHeracles inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(285, 10.0, 12.0, 6.0, 22, d6(3, p), 10, g(1, 1), superHeavy(1)).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Heavy Calibre Cannonade", d6(3, p), i(6), i(1), [side(left)], [calibre([cat_heavy, cat_superHeavy])]),
            weaponSystem("Heavy Calibre Cannonade", d6(3, p), i(6), i(1), [side(right)], [calibre([cat_heavy, cat_superHeavy])]),
            weaponSystem("Dark Matter Cannon", d6(2, p), i(2), i(3), [front(narrow)], [crippling, bloom]),
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
        ConstructorStats = getFleetBuilderStats(class_name(), shipStats_var, special_var, weaponSystemList, { () = newShip() }).

clauses
    getShipCount() = shipCount.

end implement phrHeracles
