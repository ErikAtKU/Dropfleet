% Copyright

implement shaltariAmethyst inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(48, 12.0, sig(2.0, 12.0), 12.0, 4, arm(d6(5, p), d6(4, p)), 6, g(1, 2), light(1)).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [weaponSystem("Microwave Array", d6(3, p), nd3plus(1, 1), i(1), [front(), side(), rear], [closeAction(beam)])].

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

end implement shaltariAmethyst
