% Copyright

class generateCostListDlg : generateCostListDlg
    open core

domains
    faction = ucm; scourge; phr; shaltari; resistance.

predicates
    display : (window Parent, faction, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* Fleet = []) -> generateCostListDlg Dialog.

constructors
    new : (window Parent, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* Fleet).

end class generateCostListDlg
