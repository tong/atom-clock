
import js.Browser.document;
import js.html.DivElement;
import atom.Disposable;
import haxe.Timer;

@:keep
class Clock {

    static inline function __init__() untyped module.exports = Clock;

    static var config = {
        seconds: { "title": "Show seconds", "type": "boolean", "default": true },
        format: { "title": "24-hour format", "type": "boolean", "default": true }
    };

    static var enabled :  Bool;
    static var showSeconds : Bool;
    static var format24 : Bool;
    static var timer : Timer;
    static var commandToggleSeconds : Disposable;
    static var commandShow : Disposable;
    static var commandHide : Disposable;
    static var configChangeListener : Disposable;
    static var view : DigitalClockView;

    static function activate( state ) {

        trace( 'Atom-clock' );

        enabled = (state != null) ? state.enabled : true;
        if( enabled == null ) enabled = true;

        showSeconds = Atom.config.get( 'clock.seconds' );
        format24 = Atom.config.get( 'clock.format' );

        view = new DigitalClockView();

        configChangeListener = Atom.config.onDidChange( 'clock', {}, function(e){
            showSeconds = e.newValue.seconds;
            format24 = e.newValue.format;
            update();
        });

        commandToggleSeconds = Atom.commands.add( 'atom-workspace', 'clock:toggle-seconds', function(_) showSeconds = !showSeconds );

        enabled ? show() : hide();
    }

    static function deactivate() {
        if( timer != null ) {
            timer.stop();
            timer = null;
        }
        if( configChangeListener != null ) configChangeListener.dispose();
        if( commandShow != null ) commandShow.dispose();
        if( commandHide != null ) commandHide.dispose();
        commandToggleSeconds.dispose();
    }

    static function serialize() return { enabled: enabled };

    static function show() {
        enabled = view.visible = true;
        timer = new Timer( 1000 );
        timer.run = update;
        commandHide = Atom.commands.add( 'atom-workspace', 'clock:hide', function(_) hide() );
        if( commandShow != null ) {
            commandShow.dispose();
            commandShow = null;
        }
    }

    static function hide() {
        enabled = view.visible = false;
        if( timer != null ) {
            timer.stop();
            timer = null;
        }
        commandShow = Atom.commands.add( 'atom-workspace', 'clock:show', function(_) show() );
        if( commandHide != null ) {
            commandHide.dispose();
            commandHide = null;
        }
    }

    static inline function update() {
        view.setTime( Date.now(), showSeconds, format24 );
    }

    static function consumeStatusBar( bar ) {
        bar.addRightTile( { item:view, priority:-100 } );
    }
}
