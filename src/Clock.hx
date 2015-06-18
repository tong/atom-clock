
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

    static var toggleCommand : Disposable;
    static var enabled :  Bool;
    static var view : ClockView;
    static var timer : Timer;
    static var showSeconds : Bool;

    static function activate( state ) {

        trace( 'Atom-clock' );

        enabled = (state != null) ? state.enabled : true;
        showSeconds = Atom.config.get( 'clock.seconds' );
        view = new ClockView();

        Atom.config.onDidChange( 'clock.seconds', {}, function(e){
            showSeconds = e.newValue;
            update();
        });

        toggleCommand = Atom.commands.add( 'atom-workspace', 'clock:toggle', function(_) toggle() );

        if( enabled ) {
            timer = new Timer( 1000 );
            timer.run = handleTimer;
        }
    }

    static function deactivate() {
        toggleCommand.dispose();
        if( timer != null ) {
            timer.stop();
            timer = null;
        }
    }

    static function serialize()
        return { enabled: enabled };

    static function toggle() {
        if( enabled ) {
            enabled = view.visible = false;
            if( timer != null ) {
                timer.stop();
                timer = null;
            }
        } else {
            enabled = view.visible = true;
            update();
            timer = new Timer( 1000 );
            timer.run = handleTimer;
        }
    }

    static function handleTimer()
        update();

    static function update() {
        var now = Date.now();
        var str = formatTimePart( now.getHours() ) +':'+ formatTimePart( now.getMinutes() );
        if( showSeconds ) str += ':' + formatTimePart( now.getSeconds() );
        view.time( str );
    }

    static inline function formatTimePart( i : Int ) : String
        return (i < 10) ? '0$i' : Std.string(i);

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

    public inline function time( text : String )
        this.textContent = text;
}
