% Copyright

implement ucmMoscow inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(150, 6.0, 6.0, 7.0, 12, d6(3, p), 5, g(1, 1), heavy).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("UF-4200 Mass Driver Turret", d6(4, p), i(2), i(1), [front(), side(right)], [linked(1)]),
            weaponSystem("UF-4200 Mass Driver Turret", d6(4, p), i(2), i(1), [front(), side(left)], [linked(1)]),
            weaponSystem("UF-6400 Mass Driver Turrets", d6(3, p), i(4), i(1), [front(), side()], [linked(1)]),
            weaponSystem("UF-6400 Mass Driver Turrets", d6(3, p), i(4), i(1), [front(), side()], []),
            weaponSystem("Shark Missile bays", d6(4, p), nd6plus(1, 1), i(1), [front(), side(), rear], [closeAction()])
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

end implement ucmMoscow
