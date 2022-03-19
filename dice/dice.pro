% Copyright

implement dice
    open core, shipClass

facts
    isParticle : predicate_dt := {  :- fail }.
    isBurnthroughCrit : predicate_dt := {  :- fail }.
    isScald : predicate_dt := {  :- fail }.
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
        d6(DieValue, Diemod) = lock,
        Value = if isScald() then DieValue + 1 else DieValue end if,
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
    setScald() :-
        isScald := {  :- succeed }.

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

class facts
    rollMap : mapM{shipClass::roll, integer Count} := mapM_redBlack::new().

clauses
    getBest(Left, Right) = Result :-
        LeftHits = rollMap:tryGet(Left),
        RightHits = rollMap:tryGet(Right),
        !,
        Result = if LeftHits > RightHits then Left else Right end if.
    getBest(Left, Right) = Result :-
        not(_ = rollMap:tryGet(Left)),
        !,
        LeftDie = new(Left),
        LeftCount = varM_integer::new(0),
        foreach _ = std::fromTo(1, 1296) and _ = LeftDie:getRoll_dt() do
            LeftCount:inc()
        end foreach,
        rollMap:set(Left, LeftCount:value),
        Result = getBest(Left, Right).
    getBest(Left, Right) = Result :-
        Result = getBest(Right, Left).

end implement dice
