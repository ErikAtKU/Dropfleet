% Copyright

implement shaltariGallium inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(30, 8.0, sig(3.0, 8.0), 16.0, 3, arm(d6(6, p), d6(4, p)), 6, g(1, 3), light(1)).
    special_var : shipSpecial* = [outlier, vectored].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* := [weaponSystem("Bio Atomiser Array", d6(3, p), i(6), i(0), [front()], [closeAction(beam), corruptor])].

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

end implement shaltariGallium
