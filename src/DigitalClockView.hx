
import js.Browser.document;
import js.html.DivElement;

abstract DigitalClockView(DivElement) {

    public var visible(get,set) : Bool;

    public inline function new() {
        this = document.createDivElement();
        this.style.display = 'inline-block';
        this.classList.add( 'status-bar-clock', 'inline-block' );
    }

    inline function get_visible() : Bool return this.style.display == 'inline-block';
    inline function set_visible(v:Bool) : Bool {
        this.style.display = v ? 'inline-block' : 'none';
        return v;
    }

    public function setTime( time : Date, showSeconds : Bool, format24 : Bool ) {
        var hours = time.getHours();
        if( !format24 && hours > 12 ) hours -= 12;
        var str = formatTimePart( hours ) + ':' + formatTimePart( time.getMinutes() );
        if( showSeconds ) str += ':' + formatTimePart( time.getSeconds() );
        this.textContent = str;
    }

    static function formatTimePart( i : Int ) : String
        return (i < 10) ? '0$i' : Std.string(i);
}
