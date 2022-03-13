% Copyright

implement scourgeHiruko inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(18, 6.0, 2.0, 14.0, 2, d6(6, p), 1, g(1, 3), light(1)).
    special_var : shipSpecial* = [outlier, hiruko_stat].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* := [weaponSystem("Plasma Torch", d6(4, p), nd3plus(1, 0), i(1), [front()], [closeAction(beam)])].

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

end implement scourgeHiruko
