% Copyright

implement projectToolbar
    open vpiDomains, vpiToolbar, resourceIdentifiers

clauses
    create(Parent) :-
        StatusBar = statusBar::newApplicationWindow(),
        StatusCell = statusBarCell::new(StatusBar, 0),
        StatusBar:cells := [StatusCell],
        Toolbar = create(style, Parent, controlList),
        setStatusHandler(Toolbar, { (Text) :- StatusCell:text := Text }).

% This code is maintained automatically, do not update it manually.%  14:29:47-23.5.2022

constants
    style : vpiToolbar::style = tb_top.
    controlList : vpiToolbar::control_list =
        [
            tb_ctrl(id_file_new, pushb, resId(idb_NewFileBitmap), "New;New File", 1, 1),
            tb_ctrl(id_file_open, pushb, resId(idb_OpenFileBitmap), "Open;Open File", 1, 1),
            tb_ctrl(id_file_save, pushb, resId(idb_SaveFileBitmap), "Save;Save File", 1, 1),
            vpiToolbar::separator,
            tb_ctrl(id_edit_cut, pushb, resId(idb_CutBitmap), "UCM;New UCM Fleet", 1, 1),
            tb_ctrl(id_graphs_ucm_graphs, pushb, resId(idb_graph), "", 1, 1),
            tb_ctrl(id_costs_ucmcosts, pushb, resId(idb_cost), "", 1, 1),
            vpiToolbar::separator,
            tb_ctrl(id_edit_undo, pushb, resId(idb_UndoBitmap), "Scourge;New Scourge Fleet", 1, 1),
            tb_ctrl(id_graphs_scourge_graphs, pushb, resId(idb_graph), "", 1, 1),
            tb_ctrl(id_costs_scourgecosts, pushb, resId(idb_cost), "", 1, 1),
            vpiToolbar::separator,
            tb_ctrl(id_edit_copy, pushb, resId(idb_CopyBitmap), "PHR;New PHR Fleet", 1, 1),
            tb_ctrl(id_graphs_phr_graphs, pushb, resId(idb_graph), "", 1, 1),
            tb_ctrl(id_costs_phrcosts, pushb, resId(idb_cost), "", 1, 1),
            vpiToolbar::separator,
            tb_ctrl(id_edit_redo, pushb, resId(idb_RedoBitmap), "Shaltari;New Shaltari Fleet", 1, 1),
            tb_ctrl(id_graphs_shaltari_graphs, pushb, resId(idb_graph), "", 1, 1),
            tb_ctrl(id_costs_shaltaricosts, pushb, resId(idb_cost), "", 1, 1),
            vpiToolbar::separator,
            tb_ctrl(id_edit_paste, pushb, resId(idb_PasteBitmap), "Resistance;New Resistance Fleet", 1, 1),
            tb_ctrl(id_graphs_resistance_graphs, pushb, resId(idb_graph), "", 1, 1),
            tb_ctrl(id_costs_resistancecosts, pushb, resId(idb_cost), "", 1, 1),
            vpiToolbar::separator,
            tb_ctrl(id_help_contents, pushb, resId(idb_HelpBitmap), "Help;Help", 1, 1)
        ].
% end of automatic code

end implement projectToolbar
