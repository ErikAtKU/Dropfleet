% Copyright

interface shipCountName supports control
    open core

predicates
    setFBS : (shipClass::fleetBuilderStats FBS).

predicates
    getGroupRange : () -> tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}.

end interface shipCountName
