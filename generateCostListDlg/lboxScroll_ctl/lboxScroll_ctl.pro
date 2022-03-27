% Copyright

implement lboxScroll_ctl inherits userControlSupport
    open core, vpiDomains

clauses
    new(Parent) :-
        new(),
        setContainer(Parent).

clauses
    new() :-
        userControlSupport::new(),
        generatedInitialize().

clauses
    setList(String_List) :-
        listbox_ctl:setList(String_List),
        Lines = list::length(String_List),
        Height = math::max(groupBox_ctl:getHeight(), 9 * Lines),
        listbox_ctl:setHeight(Height),
        onScroll(vertScroll_ctl, 1, 0).

clauses
    add(String) :-
        listbox_ctl:add(String),
        Lines = list::length(listbox_ctl:getAllRows()),
        Height = math::max(groupBox_ctl:getHeight(), 9 * Lines),
        listbox_ctl:setHeight(Height),
        onScroll(vertScroll_ctl, 1, 0).

predicates
    onBoxScroll : window::scrollListener.
clauses
    onBoxScroll(_Source, ScrollCode, ThumbPosition) :-
        onFrameScroll(This, ScrollCode, ThumbPosition).

predicates
    onFrameScroll : window::scrollListener.
clauses
    onFrameScroll(_Source, ScrollCode, _ThumbPosition) :-
        Mod = if ScrollCode = 1 then -1 elseif ScrollCode = 2 then 1 else 0 end if,
        vertScroll_ctl:setThumbPosition(vertScroll_ctl:getThumbPosition() + Mod),
        onScroll(vertScroll_ctl, ScrollCode, vertScroll_ctl:getThumbPosition()).

predicates
    onScroll : scrollControl::scrollListener.
clauses
    onScroll(vertScroll_ctl, _ScrollType, ThumbPosition) :-
        !,
        New = ThumbPosition * (listbox_ctl:getHeight() - groupBox_ctl:getHeight()) div 100,
        NewY = math::min(0, -1 - New),
        listbox_ctl:getPosition(X, _Y),
        listbox_ctl:setPosition(X, NewY).
    onScroll(horScroll_ctl, _ScrollType, ThumbPosition) :-
        !,
        New = ThumbPosition * ((listbox_ctl:getWidth() - groupBox_ctl:getWidth()) div 100),
        NewX = math::min(0, -1 - New),
        listbox_ctl:getPosition(_X, Y),
        listbox_ctl:setPosition(NewX, Y).
    onScroll(_Scroll_ctl, _ScrollType, _ThumbPosition).

% This code is maintained automatically, do not update it manually.
facts
    groupBox_ctl : groupBox.
    horScroll_ctl : scrollControl.
    vertScroll_ctl : scrollControl.
    listbox_ctl : listBox.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("lboxScroll_ctl"),
        setSize(300, 200),
        addVScrollListener(onFrameScroll),
        groupBox_ctl := groupBox::new(This),
        groupBox_ctl:setRect(vpiDomains::rct(0, 0, 288, 190)),
        groupBox_ctl:setAnchors([control::left, control::top, control::right, control::bottom]),
        horScroll_ctl := scrollControl::newHorizontal(This),
        horScroll_ctl:setRect(vpiDomains::rct(0, 190, 288, 200)),
        horScroll_ctl:setAnchors([control::left, control::right, control::bottom]),
        horScroll_ctl:addScrollListener(onScroll),
        vertScroll_ctl := scrollControl::newVertical(This),
        vertScroll_ctl:setRect(vpiDomains::rct(288, 0, 300, 190)),
        vertScroll_ctl:setAnchors([control::top, control::right, control::bottom]),
        vertScroll_ctl:addScrollListener(onScroll),
        listbox_ctl := listBox::new(groupBox_ctl),
        listbox_ctl:setRect(vpiDomains::rct(-1, -2, 999, 19998)),
        listbox_ctl:setHorizontalScroll(false),
        listbox_ctl:setHScroll(false),
        listbox_ctl:setVScroll(false),
        listbox_ctl:setStaticScrollbar(false),
        listbox_ctl:setSort(false),
        listbox_ctl:addVScrollListener(onBoxScroll),
        listbox_ctl:addHScrollListener(onBoxScroll),
        listbox_ctl:setAnchors([control::left, control::top, control::right, control::bottom]),
        listbox_ctl:setVerticalScroll(false).
% end of automatic code

end implement lboxScroll_ctl
