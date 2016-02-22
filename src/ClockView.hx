
import atom.Disposable;
import js.Browser.document;
import js.html.DivElement;

class ClockView {

    public var element(default,null) : DivElement;

    var configChangeListener : Disposable;

    function new() {

        element = document.createDivElement();
        element.classList.add( 'status-bar-clock', 'inline-block' );
        element.style.display = 'inline-block';

        configChangeListener = Atom.config.onDidChange( 'clock', {}, handleConfigChange );
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

    public function setTime( time : Date ) {}
    public inline function setNow() setTime( Date.now() );

    function handleConfigChange(e) {}
}
