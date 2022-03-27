% Copyright

interface shipDamagePicker supports control
    open core

predicates
    setFBS : (shipClass::fleetBuilderStats FBS).
    setPoints : (integer Points).

predicates
    getGroupRange_nd : ()
        -> tuple{boolean SA, boolean WF, boolean CAW, boolean Launch, boolean LinkedOverlapping, integer Count, shipClass::fleetBuilderStats Ship}
        nondeterm.

end interface shipDamagePicker
