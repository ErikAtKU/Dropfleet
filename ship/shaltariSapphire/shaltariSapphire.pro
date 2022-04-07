% Copyright

implement shaltariSapphire inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(185, 12.0, sig(3.0, 16.0), 10.0, 13, arm(d6(5, p), d6(4, p)), 9, g(1, 1), heavy).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Ion Aura", d6(3, p), nd6plus(1, 3), i(1), [front(), side(), rear], [closeAction(beam), alt(1)]),
            weaponSystem("Ion Storm", d6(2, p), i(4), i(1), [front(), side(), rear], [bombardment, alt(1)]),
            weaponSystem("Gravity Coils", d6(2, p), i(2), i(1), [front(narrow)], [impel(2)]),
            weaponSystem("Harpoon Cascade", d6(4, p), i(3), i(1), [front(), side(), rear], [closeAction()])
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

end implement shaltariSapphire
