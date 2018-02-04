
import atom.Disposable;
import js.Browser.document;
import js.html.DivElement;
import Atom.config;

class DigitalClockView extends ClockView {

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

        contextMenu = Atom.contextMenu.add( { '.status-bar-clock': [
            { label: 'Hide', command: 'clock:hide'  }
        ]});
    }

    public function formatTimeString( time : Date ) : String {

        var strf = '';
        var str = '';

        if( format24 ) {
            strf = '%H:%M';
            if( showSeconds ) strf += ':%S';
        } else {
            strf = '%I:%M';
            if( showSeconds ) strf += ':%S';
            if( amPmSuffix ) strf += ' %p';
        }

        try str = DateTools.format( time, strf ) catch(e:Dynamic) {
            return e;
        }

        return str;
    }

    public override function setTime( ?time : Date ) {
        if( time == null ) time = Date.now();
        var dateTime = time.toString();
        element.dateTime = dateTime;
        element.textContent = formatTimeString( time );
    }

    public override function destroy() {

        super.destroy();

        element.removeEventListener( 'mouseover', handleMouseOver );
        element.removeEventListener( 'mouseout', handleMouseOut );

        if( tooltip != null ) tooltip.dispose();

        contextMenu.dispose();
    }

    function setShowIcon( show : Bool ) {
        show ? element.classList.add( 'icon-clock' ) : element.classList.remove( 'icon-clock' );
    }

    override function handleConfigChange(e) {

        var nv = e.newValue;
        this.showSeconds = nv.seconds;
        this.format24 = nv.format;
        this.amPmSuffix = nv.am_pm_suffix;
        setShowIcon( nv.icon );

        setTime();
    }

    function handleMouseOver(e) {

        if( tooltip != null ) tooltip.dispose();

        var now = Date.now();
        var str = DateTools.format( now, '%A %Y-%m-%d' );
        var html = '<div>$str</div>';

        tooltip = Atom.tooltips.add( element, {
            title: '<div>$html</div>',
            delay: 250,
            html: true
        });
    }

    function handleMouseOut(e){
        tooltip.dispose();
    }

}
