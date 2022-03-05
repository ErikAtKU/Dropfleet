% Copyright

implement shaltariCaesium inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(35, 8.0, sig(3.0, 8.0), 20.0, 3, arm(d6(6, p), d6(4, p)), 6, g(2, 3), light(1)).
    special_var : shipSpecial* = [outlier, vectored].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* := [weaponSystem("Focused Disruptor", d6(3, p), i(3), i(1), [front(narrow)], [calibre([cat_light])])].

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
    resetNames() :-
        usedNameList := [],
        shipCount := 0.

clauses
    newShip() = Ship :-
        New = new(),
        Ship = ship::new(New).

clauses
    getFleetBuilderStats() = fbs(ConstructorStats, class_name(), special_var, { () = newShip() }) :-
        ConstructorStats = getFleetBuilderStats(shipStats_var).

clauses
    getShipCount() = shipCount.

end implement shaltariCaesium
