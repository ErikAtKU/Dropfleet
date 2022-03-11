% Copyright

class weapon
    open core

predicates
    simulate : (fleetBuilder::groupTemplate Attacker, fleetBuilder::groupTemplate Defender, boolean WeaponsFree, integer Trials)
        -> mapM{integer HullDamage, integer Count}.

predicates
    getBurnthrough : (integer Dice, integer Burnthrough, integer Lock, integer Crit, integer CurrentHits, integer CurrentCrits,
        integer HitsOut [out], integer CritsOut [out]).

end class weapon
