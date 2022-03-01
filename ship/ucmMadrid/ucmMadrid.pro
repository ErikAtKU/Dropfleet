% Copyright

implement ucmMadrid inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(79, 6.0, 6.0, 8.0, 10, d6(3, p), 5, g(1, 2), medium).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("UF-4200 Mass Driver Turret", d6(4, p), i(2), i(1), [front(), side(left)], [linked(1)]),
            weaponSystem("UF-4200 Mass Driver Turret", d6(4, p), i(2), i(1), [front(), side(right)], [linked(1)]),
            weaponSystem("UF-B-8000 Bombardment Turrets", d6(2, p), i(6), i(1), [front(), side(), rear], [bombardment]),
            weaponSystem("Shark Missile Bays", d6(4, p), nd6plus(1, 1), i(1), [front(), side(), rear], [closeAction()])
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

end implement ucmMadrid
