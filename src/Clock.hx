
import js.Browser.window;
import atom.Disposable;
import atom.CompositeDisposable;
import Atom.commands;

private typedef ClockState = {
    enabled : Bool
}

@:keep
class Clock {

    public static var enabled(default,null) : Bool;

    static var view : ClockView;
    static var disposables : CompositeDisposable;
    static var commandEnable : Disposable;
    static var commandDisable : Disposable;
    static var animationFrameId : Int;

    @:expose("activate")
    static function activate( state : ClockState ) {

        trace( 'Atom-clock '+state );

        disposables = new CompositeDisposable();

        view = new DigitalClockView();

        if( state == null || (state.enabled == null ) || state.enabled ) {
            enable();
        } else {
            disable();
        }
    }

    @:expose("serialize")
    static function serialize()
        return {
            enabled : enabled
        };

    @:expose("deactivate")
    static function deactivate() {

        window.cancelAnimationFrame( animationFrameId );

        /*
        if( timer != null ) {
            timer.stop();
            timer = null;
        }
        */

        view.destroy();
        disposables.dispose();
    }

    static function enable() {

        if( enabled )
            return;

        enabled = true;

        if( commandEnable != null ) commandEnable.dispose();
        disposables.add( commandDisable = commands.add( 'atom-workspace', 'clock:hide', function(_) disable() ) );

        animationFrameId = window.requestAnimationFrame( update );

        view.show();

        //update();
    }

    static function disable() {

        if( !enabled )
            return;

        enabled = false;

        window.cancelAnimationFrame( animationFrameId );

        if( commandDisable != null ) commandDisable.dispose();
        disposables.add( commandEnable = commands.add( 'atom-workspace', 'clock:show', function(_) enable() ) );

        view.hide();
    }

    static function update( time : Float ) {
        animationFrameId = window.requestAnimationFrame( update );
        view.setTime();
    }

    @:expose("consumeStatusBar")
    static function consumeStatusBar( bar ) {
        bar.addRightTile( { item: view.element, priority: -100 } );
    }

    /*
    public static inline function getSessionDuration() : Float
        return Date.now().getTime() - timeStart;
*/
}
