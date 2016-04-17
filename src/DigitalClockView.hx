
import Atom.config;
import atom.Disposable;
import js.Browser.document;
import js.html.DivElement;

class DigitalClockView extends ClockView {

    var showSeconds : Bool;
    var format24 : Bool;
    var amPmSuffix : Bool;
    var tooltip : Disposable;
    var contextMenu : Disposable;

    public function new() {

        super();

        showSeconds = config.get( 'clock.seconds' );
        format24 = config.get( 'clock.format' );
        amPmSuffix = config.get( 'clock.am_pm_suffix' );

        setShowIcon( config.get( 'clock.icon' ) );

        element.addEventListener( 'mouseover', handleMouseOver, false );
        element.addEventListener( 'mouseout', handleMouseOut, false );

        contextMenu = Atom.contextMenu.add( { '.status-bar-clock': [{ label: 'Hide', command: 'clock:hide'  }] } );
    }

    public override function destroy() {
        super.destroy();
        element.removeEventListener( 'mouseover', handleMouseOver );
        element.removeEventListener( 'mouseout', handleMouseOut );
        if( tooltip != null ) tooltip.dispose();
        contextMenu.dispose();
    }

    public override function setTime( time : Date ) {
        var hours = time.getHours();
        if( !format24 && hours > 12 ) hours -= 12;
        var str = formatTimePart( hours ) + ':' + formatTimePart( time.getMinutes() );
        if( showSeconds ) str += ':' + formatTimePart( time.getSeconds() );
        if( !format24 && amPmSuffix ) str += (time.getHours() > 12) ? ' PM' : ' AM';
        element.textContent = str;
    }

    override function handleConfigChange(e) {
        var v = e.newValue;
        showSeconds = v.seconds;
        format24 = v.format;
        amPmSuffix = v.am_pm_suffix;
        setShowIcon( v.icon );
        if( Clock.enabled ) setNow();
    }

    function setShowIcon( show : Bool ) {
        show ? element.classList.add( 'icon-clock' ) : element.classList.remove( 'icon-clock' );
    }

    function handleMouseOver(e){
        if( tooltip != null ) tooltip.dispose();
        var now = Date.now();
        var html = '<div>' + now.toString() + '</div>';
        html += '<div>This session started: '+om.util.DateUtil.xTimeAgo( Clock.timeStart ) + '</div>';
        tooltip = Atom.tooltips.add( element, {
            title: '<div>$html</div>',
            delay: 250,
            html: true
        });
    }

    function handleMouseOut(e){
        tooltip.dispose();
    }

    static function formatTimePart( i : Int ) : String
        return (i < 10) ? '0$i' : Std.string(i);
}
