% Copyright

implement compareDamageDlg inherits dialog
    open core, vpiDomains

clauses
    display(Parent) = Dialog :-
        Dialog = new(Parent),
        Dialog:show().

clauses
    new(Parent) :-
        dialog::new(Parent),
        generatedInitialize(),
        AllFleets = list::concat fleetBuilder::getUCMList()


        .

% This code is maintained automatically, do not update it manually.
facts
    fleetPicker_ctl : fleetPicker.
    upperPoints_ctl : editControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("compareDamageDlg"),
        setRect(vpiDomains::rct(50, 40, 374, 406)),
        setModal(true),
        setDecoration(titlebar([frameDecoration::closeButton])),
        fleetPicker_ctl := fleetPicker::new(This),
        fleetPicker_ctl:setText("fleetPicker"),
        fleetPicker_ctl:setRect(vpiDomains::rct(8, 22, 176, 266)),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Points"),
        StaticText_ctl:setRect(vpiDomains::rct(8, 7, 32, 17)),
        upperPoints_ctl := editControl::new(This),
        upperPoints_ctl:setText("500"),
        upperPoints_ctl:setRect(vpiDomains::rct(36, 6, 60, 18)).
% end of automatic code

end implement compareDamageDlg
