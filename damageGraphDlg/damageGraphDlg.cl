% Copyright

class damageGraphDlg : damageGraphDlg
    open core

predicates
    display : (window Parent, generateCostListDlg::faction, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* Fleet = [])
        -> damageGraphDlg Dialog.

constructors
    new : (window Parent, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* Fleet).

end class damageGraphDlg
