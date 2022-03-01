% Copyright

implement phrJason inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(65, 8.0, 2.0, 12.0, 6, d6(4, p), 2, g(1, 3), light(2)).
    special_var : shipSpecial* = [rare].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Twin Heavy Calibres", d6(3, p), i(2), i(1), [front()], [calibre([cat_heavy, cat_superHeavy])]),
            weaponSystem("Kingfisher Drones", d6(3, p), nd3plus(1, 3), i(1), [front(), side(), rear], [reEntry, closeAction()])
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

end implement phrJason
