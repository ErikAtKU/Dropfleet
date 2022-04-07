% Copyright

implement shaltariHelium inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(27, 8.0, sig(1.0, 8.0), 16.0, 2, arm(d6(6, p), d6(5, p)), 3, g(1, 3), light(1)).
    special_var : shipSpecial* = [atmospheric, outlier, vectored, voidSkip].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* := [weaponSystem("Pulse Blaster", d6(3, p), i(1), i(2), [front(), side()], [closeAction(beam)])].

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

end implement shaltariHelium
