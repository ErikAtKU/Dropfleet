% Copyright

implement generateCostListDlg inherits dialog
    open core, vpiDomains

clauses
    display(Parent) = Dialog :-
        Dialog = new(Parent),
        Dialog:show().

clauses
    new(Parent) :-
        dialog::new(Parent),
        generatedInitialize(),
        generate().

predicates
    generate : ().
clauses
    generate() :-
        listbox_ctl:setList([]),
        Points = tryToTerm(points_ctl:getText()),
        ListSet = fleetBuilder::buildFleet_dt(Points, fleet::myShaltariShips),
        foreach tuple(Cost, SetMap) in ListSet do
            foreach tuple(Template, _SubMap) in SetMap do
                listbox_ctl:add(string::format("%d: %s", Cost, string::present(Template)))
            end foreach
        end foreach,
        fail.
    generate().

predicates
    onGenerate : button::clickResponder.
clauses
    onGenerate(_Source) = button::defaultAction :-
        generate().

predicates
    onHScroll : scrollControl::scrollListener.
clauses
    onHScroll(_Source, _ScrollType, ThumbPosition) :-
        New = 0 - ThumbPosition * ((listbox_ctl:getWidth() - getWidth()) div 100),
        listbox_ctl:setPosition(New, 20).

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    listbox_ctl : listBox.
    points_ctl : editControl.
    generate_ctl : button.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("generateCostListDlg"),
        setRect(vpiDomains::rct(50, 40, 650, 180)),
        setModal(true),
        setDecoration(titlebar([frameDecoration::closeButton])),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(472, 120),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(536, 120),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        listbox_ctl := listBox::new(This),
        listbox_ctl:setRect(vpiDomains::rct(0, 20, 2000, 104)),
        listbox_ctl:setColumnWidth(6000),
        HorScroll_ctl = scrollControl::newHorizontal(This),
        HorScroll_ctl:setPosition(8, 102),
        HorScroll_ctl:addScrollListener(onHScroll),
        HorScroll_ctl:setSize(584, 10),
        points_ctl := editControl::new(This),
        points_ctl:setText("500"),
        points_ctl:setPosition(80, 4),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Points"),
        StaticText_ctl:setPosition(32, 6),
        generate_ctl := button::new(This),
        generate_ctl:setText("Generate"),
        generate_ctl:setPosition(132, 2),
        generate_ctl:setClickResponder(onGenerate).
% end of automatic code

end implement generateCostListDlg
