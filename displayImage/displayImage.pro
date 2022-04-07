% Copyright

implement displayImage inherits dialog
    open core, vpiDomains

class facts
    allOpen : displayImage* := [].

clauses
    displayImage(Parent, FBS) :-
        Dialog = new(Parent, FBS),
        Dialog:show().

clauses
    new(Parent, FBS) :-
        dialog::new(Parent),
        shipClass::getFBSImageFile(FBS, Filename),
        generatedInitialize(),
        setText(string::present(FBS)),
        imageControl_ctl:setPlace(imageControl::centre),
        Image = image::createFromFile(Filename),
        imageControl_ctl:setGdipImage(Image),
        shipClass::getFBSDesc(FBS, Desc),
        edit_ctl:setText(Desc),
        allOpen := [This | allOpen].

predicates
    onClick : button::clickResponder.
clauses
    onClick(closeAll_ctl) = button::defaultAction :-
        !,
        closeAllOpen().
    onClick(_Source) = button::defaultAction.

class predicates
    closeAllOpen : ().
clauses
    closeAllOpen() :-
        foreach DLG in allOpen do
            try
                DLG:destroy()
            catch _ do
                succeed
            end try
        end foreach,
        allOpen := [].

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data) :-
        center().

% This code is maintained automatically, do not update it manually.%  21:38:13-7.4.2022
facts
    cancel_ctl : button.
    imageControl_ctl : imageControl.
    closeAll_ctl : button.
    edit_ctl : editControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("displayImage"),
        setRect(rct(50, 40, 474, 440)),
        setModal(false),
        setDecoration(titlebar([closeButton])),
        setState([wsf_NoClipSiblings]),
        addShowListener(onShow),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Close"),
        cancel_ctl:setPosition(396, 382),
        cancel_ctl:setSize(24, 14),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl:setClickResponder(onClick),
        closeAll_ctl := button::new(This),
        closeAll_ctl:setText("Close All"),
        closeAll_ctl:setPosition(348, 382),
        closeAll_ctl:setSize(40, 14),
        closeAll_ctl:defaultHeight := false,
        closeAll_ctl:setClickResponder(onClick),
        imageControl_ctl := imageControl::new(This),
        imageControl_ctl:setPosition(4, 2),
        imageControl_ctl:setSize(276, 172),
        imageControl_ctl:setAnchors([control::left, control::top, control::right, control::bottom]),
        edit_ctl := editControl::new(This),
        edit_ctl:setText(""),
        edit_ctl:setPosition(4, 176),
        edit_ctl:setWidth(416),
        edit_ctl:setHeight(210),
        edit_ctl:setMultiLine(),
        edit_ctl:setReadOnly().
% end of automatic code

end implement displayImage
