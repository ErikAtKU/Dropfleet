% Copyright

interface shipCountName supports control
    open core

predicates
    setFBS : (shipClass::fleetBuilderStats FBS).
    setModel : (tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}).

predicates
    getGroupRange : () -> tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}.

end interface shipCountName
