
import js.Browser.document;
import js.html.DivElement;
import js.html.TimeElement;
import atom.Disposable;
import Atom.config;

class ClockView {

    public var element(default,null) : TimeElement;

    var showSeconds : Bool;
    var configChangeListener : Disposable;

    function new() {

        element = untyped document.createElement( 'time' );
        element.classList.add( 'status-bar-clock', 'inline-block' );

        showSeconds = config.get( 'clock.seconds' );

        configChangeListener = config.onDidChange( 'clock', {}, handleConfigChange );
    }

    public function show() {
        element.style.display = 'inline-block';
    }

    public function hide() {
        element.style.display = 'none';
    }

    public function destroy() {
        configChangeListener.dispose();
        element.remove();
    }

    public function setTime( ?time : Date ) {
        // Override me
    }

    function handleConfigChange(e) {
        // Override me
    }
}
