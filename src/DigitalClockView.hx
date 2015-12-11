
import js.Browser.document;
import js.html.DivElement;

@:forward(classList)
abstract DigitalClockView(DivElement) {

    public var visible(get,set) : Bool;
    public var iconVisible(get,set) : Bool;

    public inline function new() {
        this = document.createDivElement();
        this.classList.add( 'status-bar-clock', 'inline-block' );
        this.style.display = 'inline-block';
    }

    inline function get_visible() : Bool return this.style.display == 'inline-block';
    inline function set_visible(v:Bool) : Bool {
        this.style.display = v ? 'inline-block' : 'none';
        return v;
    }

    inline function get_iconVisible() : Bool return this.classList.contains( 'icon-clock' );
    inline function set_iconVisible(v:Bool) : Bool {
        v ? this.classList.add( 'icon-clock' ) : this.classList.remove( 'icon-clock' );
        return v;
    }

    public function setTime( time : Date, showSeconds : Bool, format24 : Bool, amPmSuffix : Bool ) {
        var hours = time.getHours();
        if( !format24 && hours > 12 ) hours -= 12;
        var str = formatTimePart( hours ) + ':' + formatTimePart( time.getMinutes() );
        if( showSeconds ) str += ':' + formatTimePart( time.getSeconds() );
        if( !format24 && amPmSuffix ) str += (time.getHours() > 12) ? ' PM' : ' AM';
        this.textContent = str;
    }

    static function formatTimePart( i : Int ) : String
        return (i < 10) ? '0$i' : Std.string(i);
}
