(function() {
  function f(a) {
    var c = this;
    this.id = setInterval(function() {
      c.w();
    }, a);
  }
  function a() {
  }
  a.K = function(b) {
    a.enabled = null != b ? b.enabled : !0;
    null == a.enabled && (a.enabled = !0);
    a.i = atom.f.get("clock.seconds");
    a.m = atom.f.get("clock.format");
    a.l = atom.f.get("clock.am_pm_suffix");
    b = window.document.createElement("div");
    b.classList.add("status-bar-clock", "inline-block");
    b.style.display = "inline-block";
    a.a = b;
    b = a.a;
    var c = atom.f.get("clock.icon");
    c ? b.classList.add("icon-clock") : b.classList.remove("icon-clock");
    c;
    a.s = atom.f.I("clock", {}, function(b) {
      a.i = b.newValue.D;
      a.m = b.newValue.format;
      a.l = b.newValue.A;
      var c = a.a;
      (b = b.newValue.icon) ? c.classList.add("icon-clock") : c.classList.remove("icon-clock");
      b;
      e.setTime(a.a, new Date, a.i, a.m, a.l);
    });
    a.B = atom.o.add("atom-workspace", "clock:toggle-seconds", function() {
      a.i = !a.i;
    });
    a.enabled ? a.u() : a.v();
  };
  a.M = function() {
    null != a.b && (a.b.stop(), a.b = null);
    null != a.s && a.s.g();
    null != a.h && a.h.g();
    null != a.c && a.c.g();
    a.B.g();
  };
  a.F = function() {
    return {enabled:a.enabled};
  };
  a.u = function() {
    a.a.style.display = "inline-block";
    !0;
    a.enabled = !0;
    a.b = new f(1E3);
    a.b.w = a.C;
    a.c = atom.o.add("atom-workspace", "clock:hide", function() {
      a.v();
    });
    null != a.h && (a.h.g(), a.h = null);
  };
  a.v = function() {
    a.a.style.display = "none";
    !1;
    a.enabled = !1;
    null != a.b && (a.b.stop(), a.b = null);
    a.h = atom.o.add("atom-workspace", "clock:show", function() {
      a.u();
    });
    null != a.c && (a.c.g(), a.c = null);
  };
  a.C = function() {
    e.setTime(a.a, new Date, a.i, a.m, a.l);
  };
  a.L = function(b) {
    b.G({item:a.a, J:-100});
  };
  var e = {setTime:function(a, c, f, g, h) {
    var d = c.getHours();
    !g && 12 < d && (d -= 12);
    d = e.j(d) + ":" + e.j(c.getMinutes());
    f && (d += ":" + e.j(c.getSeconds()));
    !g && h && (d += 12 < c.getHours() ? " PM" : " AM");
    a.textContent = d;
  }, j:function(a) {
    return 10 > a ? "0" + a : null == a ? "null" : "" + a;
  }};
  f.prototype = {stop:function() {
    null != this.id && (clearInterval(this.id), this.id = null);
  }, w:function() {
  }};
  module.H = a;
  a.f = {D:{title:"Show seconds", type:"boolean", description:"Toggle show seconds", "default":!0}, format:{title:"24-hour format", type:"boolean", description:"Toggle 12/24 format", "default":!0}, A:{title:"AM/PM suffix", type:"boolean", description:"Show AM/PM suffix when 12-hour format is selected", "default":!0}, icon:{title:"Show icon", type:"boolean", description:"Toggle show clock icon", "default":!1}};
})();

