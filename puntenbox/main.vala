using Gtk;

public class MenuPlace : Gtk.TreeView{
	private Gtk.ListStore list_store;
	private enum Columns {
        TOGGLE,
        TEXT,
        N_COLUMNS
    }
    public MenuPlace(){
		list_store = new Gtk.ListStore (Columns.N_COLUMNS, typeof (bool), typeof (string));
        new with_model (list_store);
        var toggle = new CellRendererToggle ();
        toggle.toggled.connect ((toggle, path) => {
            var tree_path = new TreePath.from_string (path);
            TreeIter iter;
            list_store.get_iter (out iter, tree_path);
            list_store.set (iter, Columns.TOGGLE, !toggle.active);
        });

        var column = new TreeViewColumn ();
        column.pack_start (toggle, false);
        column.add_attribute (toggle, "active", Columns.TOGGLE);
        this.append_column (column);

		var text = new CellRendererText ();

        column = new TreeViewColumn ();
        column.pack_start (text, true);
        column.add_attribute (text, "text", Columns.TEXT);
        append_column (column);

        set_headers_visible (false);

        TreeIter iter;
        list_store.append (out iter);
        list_store.set (iter, Columns.TOGGLE, true, Columns.TEXT, "item 1");
        list_store.append (out iter);
        list_store.set (iter, Columns.TOGGLE, false, Columns.TEXT, "item 2");
        list_store.append (out iter);
        list_store.set (iter, Columns.TOGGLE, false, Columns.TEXT, "item 3");
        list_store.append (out iter);
        list_store.set (iter, Columns.TOGGLE, false, Columns.TEXT, "item 4");
        //add (tree_view);
    }
}

public class App: Object {
    Gtk.Window window;
    Gtk.Box gtkBoxMenu;
    Gtk.Label lbTitle;
    construct {
        var builder = new Gtk.Builder();
        try {
            builder.add_from_file("ui/main.glade");
            stdout.printf("BUilder up\n");
        }
        catch (Error e) {
            stderr.printf (@"$(e.message)\n");
           // Posix.exit(1);
        }
        builder.connect_signals (this);
        this.window = builder.get_object("applicationwindow1") as Gtk.Window;
        this.window.destroy.connect (Gtk.main_quit);
        this.gtkBoxMenu = builder.get_object("gtkBoxMenu") as Gtk.Box;
        this.lbTitle = builder.get_object("lbTitle") as Gtk.Label;
    }
    public void start () {
        this.setupMenu();
        this.window.show_all ();
        this.window.maximize();
    }
    public void setupMenu (){
    Gtk.TreeView tv = new MenuPlace();
		this.gtkBoxMenu.pack_start(tv, false, false, 2);
    }

}


static int main (string[] args) {
    Gtk.init (ref args);
    var app = new App ();
    app.start ();
    Gtk.main ();
    return 0;
}
