
import js.Browser.document;
import js.html.DivElement;
import atom.Disposable;
import atom.CompositeDisposable;
import haxe.Timer;

@:keep
class Clock {

    static inline function __init__() untyped module.exports = Clock;

    public static var enabled(default,null) : Bool;

    static var view : ClockView;
    static var timer : Timer;
    static var disposables : CompositeDisposable;
    static var commandEnable : Disposable;
    static var commandDisable : Disposable;

    static function activate( state ) {

        trace( 'Atom-clock' );

        disposables = new CompositeDisposable();
        view = new DigitalClockView();

        enabled = (state != null) ? state.enabled : true;
        enabled ? enable() : disable();
    }

    static function enable() {
        enabled = true;
        if( commandEnable != null ) commandEnable.dispose();
        disposables.add( commandDisable = Atom.commands.add( 'atom-workspace', 'clock:hide', function(_) disable() ) );
        timer = new Timer( 1000 );
        timer.run = update;
        view.show();
        update();
    }

    static function disable() {
        enabled = false;
        if( timer != null ) {
            timer.stop();
            timer = null;
        }
        if( commandDisable != null ) commandDisable.dispose();
        disposables.add( commandEnable = Atom.commands.add( 'atom-workspace', 'clock:show', function(_) enable() ) );
        view.hide();
    }

    static function serialize() {
        return {
            enabled : enabled
        };
    }

    static function deactivate() {
        if( timer != null ) {
            timer.stop();
            timer = null;
        }
        view.destroy();
        disposables.dispose();
    }

    static inline function update()
        view.setNow();

    static function consumeStatusBar( bar ) {
        bar.addRightTile( { item: view.element, priority: -100 } );
    }
}
