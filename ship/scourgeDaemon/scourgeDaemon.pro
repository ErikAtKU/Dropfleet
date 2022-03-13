% Copyright

implement scourgeDaemon inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(260, 8.0, 12.0, 8.0, 18, d6(3, p), 12, g(1, 1), superHeavy(1)).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Oculus Beam Array", d6(3, p), i(2), i(2), [front()], [scald, linked(1)]),
            weaponSystem("Oculus Beam Phalanx", d6(3, p), i(3), i(2), [front(), side(left)], [scald, linked(1)]),
            weaponSystem("Oculus Beam Phalanx", d6(3, p), i(3), i(2), [front(), side(right)], [scald, linked(1)]),
            weaponSystem("Furnace Fangs", d6(4, p), i(4), i(1), [front(narrow)], [alt(1), scald, burnthrough(10)]),
            weaponSystem("Furnace Fangs", d6(2, p), i(2), i(1), [front(narrow)], [alt(1), scald, burnthrough(5), flash]),
            weaponSystem("Plasma Cyclone", d6(2, p), nd6plus(1, 2), i(1), [front(), side(), rear], [closeAction(), scald])
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

end implement scourgeDaemon
