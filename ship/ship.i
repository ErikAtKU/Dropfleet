interface ship

predicates
    getShipPoints : () -> integer.
    getScan : () -> real.
    getSignature : () -> real.
    getThrust : () -> real.
    getHull : () -> integer.
    getArmour : () -> shipClass::roll.
    getShields_dt : () -> shipClass::roll determ.
    getPointDefense : () -> integer.
    getTonnage : () -> shipClass::tonnage.

predicates
    getWeaponSystem_nd : (shipClass::weaponSpecial* Key [out], shipClass::weaponSystem* [out]) nondeterm.

predicates
    getShipSpecial_nd : () -> shipClass::shipSpecial nondeterm.

predicates
    setShields : (boolean ShieldsUp).

end interface ship
