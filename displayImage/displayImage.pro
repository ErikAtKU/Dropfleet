% Copyright

implement displayImage inherits dialog
    open core, vpiDomains

clauses
    displayImage(Parent, Filename) :-
        Dialog = new(Parent, Filename),
        Dialog:show().

clauses
    new(Parent, Filename) :-
        dialog::new(Parent),
        generatedInitialize(),
        imageControl_ctl:setPlace(imageControl::centre),
        Image = image::createFromFile(Filename),
        imageControl_ctl:setGdipImage(Image).

% This code is maintained automatically, do not update it manually.%  12:45:01-14.2.2022

facts
    cancel_ctl : button.
    imageControl_ctl : imageControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("displayImage"),
        setRect(rct(50, 40, 343, 224)),
        setModal(true),
        setDecoration(titlebar([closeButton])),
        setState([wsf_NoClipSiblings]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Close"),
        cancel_ctl:setPosition(256, 162),
        cancel_ctl:setSize(28, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        imageControl_ctl := imageControl::new(This),
        imageControl_ctl:setPosition(8, 6),
        imageControl_ctl:setSize(276, 172),
        imageControl_ctl:setAnchors([control::left, control::top, control::right, control::bottom]).
% end of automatic code

end implement displayImage
