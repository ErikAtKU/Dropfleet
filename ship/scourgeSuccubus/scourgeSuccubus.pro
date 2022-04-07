% Copyright

implement scourgeSuccubus inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(55, 6.0, 5.0, 10.0, 6, d6(4, p), 4, g(2, 3), light(2)).
    special_var : shipSpecial* = [cloakingCrest].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Oculus Beams", d6(3, p), i(1), i(2), [front()], [scald]),
            weaponSystem("Oculus Beams", d6(3, p), i(1), i(2), [front()], [scald]),
            weaponSystem("Seekers", d6(3, p), nd3plus(1, 2), i(1), [front(), side(), rear], [scald, reEntry, closeAction()])
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

end implement scourgeSuccubus
