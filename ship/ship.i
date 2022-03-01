interface ship

predicates
    getShipPoints : () -> integer.
    getScan : () -> real.
    getSignature : () -> real.
    getThrust : () -> real.
    getHull : () -> integer.
    getArmour : () -> shipClass::roll.
    getPointDefense : () -> integer.

predicates
    getWeaponSystem_nd : () -> shipClass::weaponSystem nondeterm.

predicates
    getShipSpecial_nd : () -> shipClass::shipSpecial nondeterm.

end interface ship
