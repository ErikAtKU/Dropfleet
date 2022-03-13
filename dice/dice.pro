% Copyright

implement dice
    open core, shipClass

facts
    isParticle : predicate_dt := {  :- fail }.
    isBurnthroughCrit : predicate_dt := {  :- fail }.
    lock : shipClass::roll.
    crit : shipClass::roll.

clauses
    new(Lock) :-
        new(Lock, Lock).

clauses
    new(Lock, Crit) :-
        lock := Lock,
        crit := Crit.

clauses
    getRoll_dt() = Roll :-
        d6(Value, Diemod) = lock,
        Roll = 1 + math::random(6),
        (p = Diemod and Roll >= Value orelse e = Diemod and Roll = Value).

clauses
    isCrit(_) :-
        (isParticle() orelse isBurnthroughCrit()),
        !.
    isCrit(Roll) :-
        d6(Value, Diemod) = crit,
        (p = Diemod and Roll >= Value orelse e = Diemod and Roll = Value).

clauses
    setParticle() :-
        isParticle := {  :- succeed }.

clauses
    setBurnthroughCrit() :-
        isBurnthroughCrit := {  :- succeed }.

clauses
    getCount(i(Count)) = Count.
    getCount(nd3plus(N, Constant)) = Count :-
        RollVar = varM_integer::new(Constant),
        foreach _ = std::fromTo(1, N) do
            Roll = 1 + math::random(3),
            RollVar:add(Roll)
        end foreach,
        Count = RollVar:value.
    getCount(nd6plus(N, Constant)) = Count :-
        RollVar = varM_integer::new(Constant),
        foreach _ = std::fromTo(1, N) do
            Roll = 1 + math::random(6),
            RollVar:add(Roll)
        end foreach,
        Count = RollVar:value.
    getCount(star) = 0.

clauses
    getPD(PD) = Sum:value :-
        PDRoll = new(shipClass::d6(5, shipClass::p)),
        Sum = varM_integer::new(0),
        foreach _ = std::fromTo(1, PD) and _ = PDRoll:getRoll_dt() do
            Sum:inc()
        end foreach.

end implement dice
