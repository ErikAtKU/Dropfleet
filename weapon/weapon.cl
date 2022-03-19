% Copyright

class weapon
    open core

predicates
    simulate : (fleetBuilder::groupTemplate Attacker, shipClass::fleetBuilderStats Defender, boolean CloseActionWeapons, boolean WeaponsFree,
        boolean SingleLinkedDirection, integer Trials) -> mapM{integer HullDamage, integer Count}.

predicates
    getBurnthrough : (dice* Attacks, integer BurnthroughCap, integer HitsOut [out], integer CritsOut [out]).

predicates
    getStandard : (dice* Attacks, integer HitsOut [out], integer CritsOut [out]).

end class weapon
