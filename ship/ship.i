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
    getLayer : () -> layer.

domains
    layer = atmosphere; lowOrbit; highOrbit.

predicates
    getWeaponSystem_nd : (shipClass::weaponSpecial* Key [out], shipClass::weaponSystem* [out]) nondeterm.

predicates
    getShipSpecial_nd : () -> shipClass::shipSpecial nondeterm.

predicates
    getLaunch_nd : () -> shipClass::launchSystem nondeterm.

predicates
    setShields : (boolean ShieldsUp).

predicates
    setLayer : (layer).

end interface ship
