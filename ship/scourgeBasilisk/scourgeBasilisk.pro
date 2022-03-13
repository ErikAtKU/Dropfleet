% Copyright

implement scourgeBasilisk inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(215, 6.0, 8.0, 10.0, 14, d6(4, p), 8, g(1, 1), heavy).
    special_var : shipSpecial* = [stealth, fullCloak].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Oculus Beam Array", d6(3, p), i(2), i(2), [front()], [scald]),
            weaponSystem("Oculus Beam Phalanx", d6(3, p), i(3), i(2), [front(), side(left)], [scald]),
            weaponSystem("Oculus Beam Phalanx", d6(3, p), i(3), i(2), [front(), side(right)], [scald]),
            weaponSystem("Plasma Storm", d6(3, p), nd6plus(1, 2), i(1), [front(), side(), rear], [scald, closeAction()])
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

end implement scourgeBasilisk
