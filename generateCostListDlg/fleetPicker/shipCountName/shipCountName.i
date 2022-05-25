% Copyright

interface shipCountName supports control
    open core

predicates
    setFBS : (shipClass::fleetBuilderStats FBS).
    setModel : (tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}).
    setCostCount : (shipClass::fleetBuilderStats FBS).

predicates
    getGroupRange : () -> tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}.

predicates
    getCostRange_dt : () -> tuple{integer Num, integer TotalCost, shipClass::fleetBuilderStats} determ.

end interface shipCountName
