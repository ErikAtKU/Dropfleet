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
        fleetCost_lbox:setList([]),
        LowerPoints = tryToTerm(lowerPoints_ctl:getText()),
        UpperPoints = tryToTerm(upperPoints_ctl:getText()),
        fleetBuilder::buildFleetCostMap_dt(LowerPoints, UpperPoints, fleet::myShaltariShips),
        foreach tuple(Cost, SetMap) in fleetBuilder::getListSet() do
            foreach tuple(Template, _SubMap) in SetMap do
                fleetCost_lbox:add(string::format("%d: %s", Cost, string::present(Template)))
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
    onHScroll(fleetCost_scroll, _ScrollType, ThumbPosition) :-
        New = 0 - ThumbPosition * ((fleetCost_lbox:getWidth() - getWidth()) div 100),
        fleetCost_lbox:setPosition(New, 20),
        !.
    onHScroll(fleetList_scroll, _ScrollType, ThumbPosition) :-
        New = 0 - ThumbPosition * ((fleetCost_lbox:getWidth() - getWidth()) div 100),
        fleetCost_lbox:setPosition(New, 20),
        !.
    onHScroll(_fleetCost_scroll, _ScrollType, ThumbPosition).

% This code is maintained automatically, do not update it manually.
facts
    lowerPoints_ctl : editControl.
    upperPoints_ctl : editControl.
    generate_ctl : button.
    fleetCost_lbox : listBox.
    fleetCost_scroll : scrollControl.
    ok_ctl : button.
    cancel_ctl : button.
    fleetList_scroll : scrollControl.
    fleetList_lbox : listBox.
    fleetPicker_ctl : fleetPicker.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("generateCostListDlg"),
        setRect(vpiDomains::rct(50, 40, 650, 488)),
        setModal(true),
        setDecoration(titlebar([frameDecoration::closeButton])),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Points"),
        StaticText_ctl:setPosition(52, 6),
        lowerPoints_ctl := editControl::new(This),
        lowerPoints_ctl:setText("480"),
        lowerPoints_ctl:setRect(vpiDomains::rct(100, 4, 124, 16)),
        upperPoints_ctl := editControl::new(This),
        upperPoints_ctl:setText("500"),
        upperPoints_ctl:setPosition(128, 4),
        upperPoints_ctl:setWidth(24),
        generate_ctl := button::new(This),
        generate_ctl:setText("Generate"),
        generate_ctl:setPosition(180, 2),
        generate_ctl:setClickResponder(onGenerate),
        fleetCost_lbox := listBox::new(This),
        fleetCost_lbox:setRect(vpiDomains::rct(0, 20, 1000, 104)),
        fleetCost_lbox:setColumnWidth(6000),
        fleetCost_scroll := scrollControl::newHorizontal(This),
        fleetCost_scroll:setPosition(8, 102),
        fleetCost_scroll:addScrollListener(onHScroll),
        fleetCost_scroll:setSize(584, 10),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(472, 272),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(536, 272),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        fleetList_scroll := scrollControl::newHorizontal(This),
        fleetList_scroll:setText("scrollControl"),
        fleetList_scroll:setRect(vpiDomains::rct(8, 224, 592, 234)),
        fleetList_scroll:addScrollListener(onHScroll),
        fleetList_lbox := listBox::new(This),
        fleetList_lbox:setText("listBox"),
        fleetList_lbox:setRect(vpiDomains::rct(0, 142, 1000, 226)),
        fleetPicker_ctl := fleetPicker::new(This),
        fleetPicker_ctl:setRect(vpiDomains::rct(60, 250, 228, 364)).
% end of automatic code

end implement generateCostListDlg
