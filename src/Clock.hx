
import js.Browser.document;
import js.html.DivElement;
import atom.Disposable;
import haxe.Timer;

@:keep
class Clock {

    static inline function __init__() untyped module.exports = Clock;

    static var config = {
        seconds: { "title": "Show seconds", "type": "boolean", "default": true }
    };

    static var view : ClockView;
    static var enabled :  Bool;
    static var showSeconds : Bool;
    static var timer : Timer;
    static var commandShow : Disposable;
    static var commandHide : Disposable;
    static var configChangeListener : Disposable;

    static function activate( state ) {

        trace( 'Atom-clock' );

        enabled = (state != null) ? state.enabled : true;
        if( enabled == null ) enabled = true;

        showSeconds = Atom.config.get( 'clock.seconds' );

        view = new ClockView();

        enabled ? show() : hide();

        configChangeListener = Atom.config.onDidChange( 'clock.seconds', {}, function(e){
            showSeconds = e.newValue;
            update();
        });
    }

    static function deactivate() {
        configChangeListener.dispose();
        if(commandShow != null ) commandShow.dispose();
        if(commandHide != null ) commandHide.dispose();
        if( timer != null ) {
            timer.stop();
            timer = null;
        }
    }

    static function serialize() return { enabled: enabled };

    static function show() {
        enabled = view.visible = true;
        timer = new Timer( 1000 );
        timer.run = update;
        commandHide = Atom.commands.add( 'atom-workspace', 'clock:hide', function(_) hide() );
        if( commandShow != null ) commandShow.dispose();
    }

    static function hide() {
        enabled = view.visible = false;
        if( timer != null ) {
            timer.stop();
            timer = null;
        }
        commandShow = Atom.commands.add( 'atom-workspace', 'clock:show', function(_) show() );
        if( commandHide != null ) commandHide.dispose();
    }

    static function update() {
        view.setTime( Date.now(), showSeconds );
    }

    static function consumeStatusBar( bar )
        bar.addRightTile( { item:view, priority:-100 } );

}

private abstract ClockView(DivElement) {

    public var visible(get,set) : Bool;

    public inline function new() {
        this = document.createDivElement();
        this.classList.add( 'status-bar-clock' );
        this.classList.add( 'clock-status' );
        this.classList.add( 'inline-block' );
    }

    inline function get_visible() : Bool return this.style.display == 'visible';
    inline function set_visible(v:Bool) : Bool {
        this.style.display = v ? 'inline-block' : 'none';
        return v;
    }

    public inline function setTime( time : Date, showSeconds : Bool ) {
        var str = formatTimePart( time.getHours() ) +':'+ formatTimePart( time.getMinutes() );
        if( showSeconds ) str += ':' + formatTimePart( time.getSeconds() );
        this.textContent = str;
    }

    static function formatTimePart( i : Int ) : String
        return (i < 10) ? '0$i' : Std.string(i);
}
