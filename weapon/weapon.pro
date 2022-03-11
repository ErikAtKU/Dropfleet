% Copyright

implement weapon
    open core

clauses
    simulate(Attacker, Defender, WeaponsFree, Trials) = mapM_redBlack::new().

clauses
    getBurnthrough(0, _Burnthrough, _Lock, _Crit, CurrentHits, CurrentCrits, CurrentHits, CurrentCrits) :-
        !.
    getBurnthrough(Dice, Burnthrough, Lock, Crit, CurrentHits, CurrentCrits, HitsOut, CritsOut) :-
        HitCount = varM_integer::new(0),
        CritCount = varM_integer::new(0),
        foreach _ = std::fromTo(1, Dice) do
            Roll = 1 + math::random(6),
            if Roll >= Crit then
                CritCount:inc()
            elseif Roll >= Lock then
                HitCount:inc()
            end if
        end foreach,
        if CurrentCrits > 0 then
            NextCrits = CritCount:value + HitCount:value + CurrentCrits,
            NextHits = CurrentHits
        else
            NextCrits = CritCount:value,
            NextHits = HitCount:value + CurrentHits
        end if,
        if NextCrits + NextHits >= Burnthrough then
            CritsOut = math::min(Burnthrough, NextCrits),
            HitsOut = Burnthrough - CritsOut
        else
            NextDice = CritCount:value + HitCount:value,
            getBurnthrough(NextDice, Burnthrough, Lock, Crit, NextHits, NextCrits, HitsOut, CritsOut)
        end if.

end implement weapon
